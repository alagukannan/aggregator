/**
* A ColdBox Enabled virtual entity service
* @singleton
* @alias=blogService@aggregator
*/
component extends="coldbox.system.orm.hibernate.BaseORMService"{
	property name="feedreader" inject="coldbox:plugin:feedreader" scope="instance";
	property name="logger" inject="logBox:logger:aggregatorModule" scope="instance";	
	
	this.approvedSortOrder = 'asc,desc';
	instance = {};
	/**
	* @hint Constructor
	*/
	public any function init(){
		
		// init super class
		super.init();
		
		// Use Query Caching
	    setUseQueryCaching( true );
	    // Query Cache Region
	    setQueryCacheRegion( 'ORMService.defaultCache' );
	    // EventHandling
	    setEventHandling( false );
		    
	    return this;
	}
	
	/**
	* @hint get all blogs in the system
	**/
	public any function listBlogs(required string entityName="blogs",
					  struct criteria=structnew(),
					  string sortOrder="dateBuilt desc",
					  numeric offset=0,
					  numeric max=10,
					  numeric timeout=10,
					  boolean ignoreCase=false,
					  boolean asQuery=true){
		return list(argumentCollection  = arguments);
	}
	
	/**
	* Get the latest blog entries
	*/
	public any function getLatestEntries(required string entityName="blogEntries",
					  struct criteria=structnew(),
					  string sortOrder="datePublished desc",
					  numeric offset=0,
					  numeric max=10,
					  numeric timeout=10,
					  boolean ignoreCase=false,
					  boolean asQuery=true){
		return list(argumentCollection = arguments);
	}
	
	
	/**
	* search the blog entries and get counts as well. Returns a structure with found records count and query
	*/
	public any function searchEntries( q='',
					  string sortcolumn="datePublished",
					  string sortorder = "desc",
					  numeric offset=0,
					  numeric max=10,
					  timeout=10,
					  boolean asQuery=true){
		var returnStruct = {foundrows = 0, qentries = ''};
		var hqlfoundrows = "select count(id) from blogEntries where isActive=1";
		var hqlsearchquery = "from blogEntries  where isActive=1";
		var criteria = {};
		
		if (len(arguments.q) gt 0){
			hqlfoundrows = hqlfoundrows & " and (title like :q or description like :q)";
			hqlsearchquery = hqlsearchquery & " and (title like :q or description like :q)";
			criteria.q = '%#arguments.q#%';		
		}
		
		if (len(arguments.sortcolumn) and 
			listFindNoCase(this.approvedSortOrder,arguments.sortOrder,',') > 0 and
			arrayFindnocase(getBlogEntriesPropertynames(),arguments.sortcolumn) > 0 ){
			hqlsearchquery = hqlsearchquery & " order by #arguments.sortcolumn# #arguments.sortorder#";
		}
		

		returnStruct.foundrows = executeQuery(query=hqlFoundrows,params = criteria,timeout=arguments.timeout,asquery=false)[1];
		returnStruct.qentries = executeQuery(query=hqlsearchquery,
											max=arguments.max,
											params = criteria,
											offset=arguments.offset,
											timeout=arguments.timeout,
											asQuery=arguments.asQuery);
		return returnStruct;
	}
	
	/**
	* save the blogs entry
	**/
	public void function saveBlogs(required any blogEntity,required boolean throwonError = true){
		//save it with hibernate transaction.
		var feedInfo = instance.feedreader.readfeed(arguments.blogEntity.getblogURL());
		//set the blogEntity values
	
		if ( isdate(feedinfo.datebuilt) eq false)
			feedinfo.datebuilt = now();
		if (isdefined("feedinfo.author.email") and len(feedinfo.author.email))
			arguments.blogEntity.setAuthoremail(feedinfo.author.email);
		if (isdefined("feedinfo.author.name") and len(feedinfo.author.name))
			arguments.blogEntity.setAuthorname(feedinfo.author.name);
		if (isdefined("feedinfo.author.url") and len(feedinfo.author.url))
			arguments.blogEntity.setAuthorurl(feedinfo.author.url);
		
		populate(target = arguments.blogEntity, memento = feedinfo);
		save(entity=arguments.blogEntity,transactional=true);				
	}
	
	
	/**
	* @hint process the feeds on a constant scehdule
	**/
	public any function processEntries(required any blogEntity,struct feeddata, required boolean throwonError = true){
		var oblogEntry = '';
		try{
			if (arguments.BlogEntity.getID() gt 0 and arguments.blogEntity.getIsactive()){
				//if feeddata isnn't present refetch the feeddata
				if (not structkeyexists(arguments,"feeddata"))
					arguments.feeddata = instance.feedreader.readfeed(arguments.blogEntity.getblogURL());
	
				var entriesArray = [];
				var itemsArrayLength = arrayLen(arguments.feeddata.items); 
				//loop through active blogs and add/update using saveblogs method.
				for (var i=1; i lte itemsArrayLength; i++){
					//check if the entry is already in DB
					oblogEntry = findWhere(entityname="blogEntries",criteria = {link=arguments.feeddata.items[i].url,isActive=true});
					
					if ( isdefined("oblogEntry"))
						entriesArray[i] = oblogEntry;	
					else
						entriesArray[i] = new(entityName='blogEntries');			
					entriesArray[i].setlink(arguments.feeddata.items[i].url);
					entriesArray[i].settitle(arguments.feeddata.items[i].title);
					
					entriesArray[i].setdescription(ReReplaceNoCase(left(arguments.feeddata.items[i].body,4000), "<[^>]*>", "", "ALL"));
					if (isdate(arguments.feeddata.items[i].datePublished))
						entriesArray[i].setdatePublished(arguments.feeddata.items[i].datePublished);
					else
						entriesArray[i].setdatePublished(now());
					if (isdate(arguments.feeddata.items[i].datePublished))	
						entriesArray[i].setdateUpdated(arguments.feeddata.items[i].dateUpdated);
					else
						entriesArray[i].setdateUpdated(now());
					//set relationship
					entriesArray[i].setblogs(arguments.blogEntity);
				}
				saveall(entities=entriesArray,transactional=true);
				//update the blogsDatesubmitted Time stamp.
				arguments.blogEntity.setdateSumitted(now());
				save(entity=arguments.blogEntity,transactional=true);					
			}
		}
		catch (any e){
			//log it or rethrow depending on the throwonError flag
			if (arguments.throwonError)
				rethrow;
			else
				instance.logger.error("error occured while processing feeds",e);
		}
	}

	
	/**
	* @hint function to set the availalble blogEntries property names in instance scopes
	**/
	public void function setBlogEntriesPropertynames() onDIComplete{
		instance.blogEntriesProperties = getPropertyNames('blogEntries');
	}
	
	/**
	* @hint function to get the availalble blogEntries property names in instance scopes
	**/
	public array function getBlogEntriesPropertynames(){
		return instance.blogEntriesProperties;
	}
	
}