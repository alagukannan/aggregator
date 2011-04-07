/**
* the blogs admin handler
*/
component extends="baseHandler" {
	property name="blogService" inject="model:blogService@aggregator" scope="instance";
	property name="messagebox" inject="coldbox:plugin:messagebox" scope="instance";	
	
	instance = {};
	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only 	= "";
	this.prehandler_except 	= "";
	this.posthandler_only 	= "";
	this.posthandler_except = "";
	this.aroundHandler_only = "";
	this.aroundHandler_except = "";		
	// REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
	this.allowedMethods = {doadd='post'};

		
	function index(event){
		var rc = event.getCollection();
		var prc = event.getCollection(private = true);	
		addAsset("#event.getModuleRoot()#/includes/scripts/jquery-1.5.1.min.js");
		addAsset("#event.getModuleRoot()#/includes/scripts/DataTables-1.7.6/media/js/jquery.dataTables.min.js");
		addAsset("#event.getModuleRoot()#/includes/scripts/aggregator.js");
		addAsset("#event.getModuleRoot()#/includes/scripts/DataTables-1.7.6/media/css/datatable.css");
		prc.title = 'Currently Aggregated feeds - Aggregator Module Admin';
		prc.qBlogs = instance.blogService.listBlogs(max=0);
	}		function doAdd(event){
		var rc = event.getCollection();
		event.norender();
		if (event.valueExists("feedURL") and isvalid("URL",rc.feedurl)){
			//check if blog url already exists
			if ( instance.blogService.list(entityName="blogs",criteria = {blogURL = rc.feedurl}).recordcount eq 0){
				var oblog = instance.blogService.new(entityname="blogs");		
				oblog.setblogURL(rc.feedURL);
				instance.blogService.saveBlogs(oblog);
				instance.blogService.processEntries(oblog);
				setNextEvent(event='#event.getCurrentModule()#.admin.detail',queryString='pk=#oblog.getid()#');		
			}
			else{
				instance.messagebox.warn("FeedURL already exists in the aggregator");
				setNextEvent(event='#event.getCurrentModule()#.admin.add');			
			}
		}
		else{
			instance.messagebox.error("FeedURL text field is required");
			setNextEvent(event='#event.getCurrentModule()#.admin.add');
		}	
	}		function add(event){
		var rc = event.getCollection();
		var prc = event.getCollection(private = true);
		prc.title = 'Add new feeds - Aggregator Module Admin';
	}		function detail(event){
		var rc = event.getCollection();
		var prc = event.getCollection(private = true);
		if (event.valueexists('pk') and isnumeric(rc.pk)){
			//get the entity
			prc.title = 'Aggregator Module Admin';
			prc.oblog = instance.blogService.get(entityname="blogs",id=rc.pk);
			prc.title = '#prc.oblog.getTitle()# - Aggregator Module Admin';
		}
		else
			setnextevent(event="#event.getCurrentModule()#.admin");	
	}		function dodelete(event) transactional{
		var rc = event.getCollection();
		event.norender();
		if (event.valueexists('pk') and isnumeric(rc.pk)){
			//get the entity
			var oBlog = instance.blogService.get(entityname="blogs",id=rc.pk);
			instance.blogService.delete(oBlog);
			instance.messagebox.info("Blog #oBlog.getblogURL()# removed successfully from aggregator module.");
			setnextevent(event="#event.getCurrentModule()#.admin");
		}
		else
			setnextevent(event="#event.getCurrentModule()#.admin");	
	}		function fetchfeed(event){
		var rc = event.getCollection();
		event.norender();
		if (event.valueexists('pk') and isnumeric(rc.pk)){
			//get the entity
			var oblog = instance.blogService.get(entityname="blogs",id=rc.pk);
			instance.blogService.processEntries(oblog);
			setNextEvent(event='#event.getCurrentModule()#.admin.detail',queryString='pk=#oblog.getid()#');	
		}
		else
			setnextevent(event="#event.getCurrentModule()#.admin");	
	}
	

	
}
