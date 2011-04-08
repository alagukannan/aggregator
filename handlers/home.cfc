/**
* the aggregator home page
*/
component extends="baseHandler"{
	property name="feedgenerator" inject="coldbox:plugin:feedgenerator" scope="instance";
	property name="blogService" inject="model:blogService@aggregator" scope="instance";	
	property name="cacheBox" inject="coldbox:cacheManager" scope="instance";
	property name="paging" inject="coldbox:myplugin:paging@aggregator" scope="instance";	
	instance = {};
	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only 	= "";
	this.prehandler_except 	= "";
	this.posthandler_only 	= "";
	this.posthandler_except = "";
	this.aroundHandler_only = "";
	this.aroundHandler_except = "";		
	// REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
	this.allowedMethods = {ping='get',feed='get',index='get,post'};
	
	
		
	function feed(event) cache=true cachetimeout=5 cacheLastAccesstimeout=5{
		var rc = event.getCollection();
		var prc = event.getCollection(private=true);
		
		if ( instance.cacheBox.lookup('rssfeed') eq false or instance.cacheBox.isExpired('rssfeed')){
			var feeddata = {};
			feeddata.items = 	instance.blogService.getLatestEntries();
			feeddata.itemsdatebuilt = now();
			structAppend(feeddata,getModuleSettings(event.getCurrentModule()).settings.feedInfo);
			feeddata.link = event.buildLink(linkto=event.getCurrentModule());
			instance.cacheBox.set('rssfeed',instance.feedGenerator.createFeed(feedStruct=feeddata),5,5);	
		}
	
		event.renderData(type='plain',data = instance.cacheBox.get('rssfeed'),contentType="text/xml");
	}	
	function list(event){
		var rc = event.getCollection();
		var prc = event.getCollection(private = true);
		addAsset("#event.getModuleRoot()#/includes/scripts/jquery-1.5.1.min.js");
		addAsset("#event.getModuleRoot()#/includes/scripts/DataTables-1.7.6/media/js/jquery.dataTables.min.js");
		addAsset("#event.getModuleRoot()#/includes/scripts/aggregator.js");
		addAsset("#event.getModuleRoot()#/includes/scripts/DataTables-1.7.6/media/css/datatable.css");
		prc.title = 'Blogs List - Aggregator Module';
		prc.qBlogs = instance.blogService.listBlogs(max=0);
	}	

	function faq(event) cache=true cachetimeout=30 cacheLastAccesstimeout=30{
			var prc = event.getCollection(private = true);
			prc.title = 'FAQ - Aggregator Module';
			prc.eventLink = '#event.buildlink(linkto='#event.getCurrentModule()#/faq')#';
	}
	function index(event) cache=true cachetimeout=15 cacheLastAccesstimeout=15{
		var rc = event.getCollection();
		var prc = event.getCollection(private=true);
		event.paramValue('offset',0);
		event.paramValue('max',10);
		event.paramvalue('page',1);
		rc.boundaries = instance.paging.getBoundaries();
		rc.offset = rc.boundaries.startrow;
		prc.results = 	instance.blogService.searchEntries(argumentCollection=rc);	
		prc.title = 'Recent Blog posts - Aggregator Module';			
	}		function search(event){
		var rc = event.getCollection();
		var prc = event.getCollection(private=true);
		event.paramValue('offset',0);
		event.paramValue('max',10);
		event.paramvalue('page',1);
		if (event.valueExists('q') and len(rc.q)){
			rc.boundaries = instance.paging.getBoundaries();
			rc.offset = rc.boundaries.startrow;
			prc.results = 	instance.blogService.searchEntries(argumentCollection=rc);
			prc.title = 'Search Blog posts - Aggregator Module';
		}
		else
			setNextEvent(event='#event.getCurrentModule()#');
	}	
	/**
	* @hint ping service requires blogURL
	**/	function ping(event){
		var rc = event.getCollection();
		var prc = event.getCollection(private=true);
		var returnStruct = {hasError = true, message= ''};
		if (event.valueExists('blogURL') and isvalid('url',rc.blogURL)){
			try{
				var oblog = instance.blogService.findWhere(entityname="blogs",criteria={blogURL=rc.blogURL});
				if (isdefined('oblog')){
					//blog found process the feeds					
					instance.blogService.processEntries(oblog);
					returnStruct = {hasError = false, message= 'Thanks for the ping.'};
				}
				else{
					returnStruct.message= 'Blog URL not found in the aggregator.';
				}
			}
			catch (any e){
				instance.logger.error('error occured during ping',e);
				returnStruct.message= 'Error occured while processing ping';		
			}			
		}
		else{
			returnStruct.message= 'blogURL is required';
		}		
		event.renderdata(type="json",data = returnStruct);
	}	
	
}
