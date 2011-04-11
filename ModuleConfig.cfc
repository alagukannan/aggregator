/**
Module Directives as public properties
this.title 				= "Title of the module";
this.author 			= "Author of the module";
this.webURL 			= "Web URL for docs purposes";
this.description 		= "Module description";
this.version 			= "Module Version"

Optional Properties
this.viewParentLookup   = (true) [boolean] (Optional) // If true, checks for views in the parent first, then it the module.If false, then modules first, then parent.
this.layoutParentLookup = (true) [boolean] (Optional) // If true, checks for layouts in the parent first, then it the module.If false, then modules first, then parent.
this.entryPoint  		= "" (Optional) // If set, this is the default event (ex:forgebox:manager.index) or default route (/forgebox) the framework
									       will use to create an entry link to the module. Similar to a default event.

structures to create for configuration
- parentSettings : struct (will append and override parent)
- settings : struct
- datasources : struct (will append and override parent)
- webservices : struct (will append and override parent)
- interceptorSettings : struct of the following keys ATM
	- customInterceptionPoints : string list of custom interception points
- interceptors : array
- layoutSettings : struct (will allow to define a defaultLayout for the module)
- routes : array Allowed keys are same as the addRoute() method of the SES interceptor.
- wirebox : The wirebox DSL to load and use

Available objects in variable scope
- controller
- appMapping (application mapping)
- moduleMapping (include,cf path)
- modulePath (absolute path)
- log (A pre-configured logBox logger object for this object)
- binder (The wirebox configuration binder)

Required Methods
- configure() : The method ColdBox calls to configure the module.

Optional Methods
- onLoad() 		: If found, it is fired once the module is fully loaded
- onUnload() 	: If found, it is fired once the module is unloaded

*/
component {

	// Module Properties
	this.title 				= "aggregator";
	this.author 			= "AL";
	this.webURL 			= "http://www.alagukannan.com/";
	this.description 		= "A simple blog aggregator";
	this.version			= "1.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= false;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = false;
	// Module Entry Point
	this.entryPoint			= "aggregator.home.index";

	function configure(){

		// parent settings
		parentSettings = {

		};

		// module settings - stored in modules.name.settings
		settings = {
			feedInfo = { description='A simple blog aggregator', title ='Coldbox Aggregator'},
			PagingBandGap = 3,
			PagingMaxRows = 10
		};

		// Layout Settings
		layoutSettings = {
			defaultLayout = "aggregator.cfm"
		};

		// datasources
		datasources = {

		};

		// web services
		webservices = {

		};

		// SES Routes
		routes = [
			{pattern="/:page-numeric?", handler="home",action="index"},
			{pattern="/feed", handler="home",action="feed"},
			{pattern="/faq", handler="home",action="faq"},
			{pattern="/list", handler="home",action="list"},
			{pattern="/ping", handler="home",action="ping"},
			{pattern="/search", handler="home",action="search"},
			{pattern="/:handler/:action?"}
		];

		// Custom Declared Points
		interceptorSettings = {
			customInterceptionPoints = ""
		};

		// Custom Declared Interceptors
		interceptors = [
			// Transactional Hibernation annotations
/*	 		{class="coldbox.system.orm.hibernate.transactionaspect",
			 properties = {metadatacachereload=false}
			}*/
		];

		// WireBox Binder configuration
		binder.map("blogService@aggregator").to("#moduleMapping#.model.blogService").asSingleton();
	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		var schedulerPlugin = controller.getPlugin('scheduler',true,false,this.title,true);
		// create a schedule
		schedulerPlugin.create( taskname = 'ScheduledDailyCrawl@aggregator',url="#controller.getSetting('htmlbaseURL')##this.title#/schedule/dailyCrawl");
		log.info('aggregator module started and ScheduledDailyCrawl@aggregator schedule task created in server');
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
		var schedulerPlugin = controller.getPlugin('scheduler',true,false,this.title,true);
		// create a schedule
		schedulerPlugin.remove( taskname = 'ScheduledDailyCrawl@aggregator');
		log.info('aggregator module unloaded and ScheduledDailyCrawl@aggregator schedule task removed from server');
	}

}