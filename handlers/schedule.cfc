/**
* the aggregator home page
*/
component extends="baseHandler"{
	property name="blogService" inject="model:blogService@aggregator" scope="instance";	
	
	instance = {};
	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only 	= "";
	this.prehandler_except 	= "";
	this.posthandler_only 	= "";
	this.posthandler_except = "";
	this.aroundHandler_only = "";
	this.aroundHandler_except = "";		
	// REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
	this.allowedMethods = {};
	
	/**
	IMPLICIT FUNCTIONS: Uncomment to use
	function preHandler(event,action,eventArguments){
		var rc = event.getCollection();
	}
	function postHandler(event,action,eventArguments){
		var rc = event.getCollection();
	}
	function aroundHandler(event,targetAction,eventArguments){
		var rc = event.getCollection();
		// executed targeted action
		arguments.targetAction(event);
	}
	*/
		
		
	function dailyCrawl(event){
		var rc = event.getCollection();
		var criteria = {isActive =1};
		var qblogs = instance.blogService.listBlogs(max=0,criteria = criteria);
		event.norender();
		log.info('daily crawl started @ #now()# and we will crawl : #qblogs.recordCount# feeds');
		for (var i=1; i lte qblogs.recordcount; i++){
			thread action="run" name="scheduleThread_#qblogs['id'][i]#_#i#" blogURL=qblogs["blogURL"][i] blogID=qblogs['id'][i]{				
				try{
					log.info('starting new thread #thread.name# for processing feeds for #blogURL#');
					oblog = instance.blogService.get(entityname="blogs",id=blogID);
					instance.blogService.processEntries(blogEntity = oblog, throwonError=true);
					log.info('exiting thread #thread.name# for processing feeds for #blogURL#');
				}
				catch (any e){
					log.error('Error occured in thread #thread.name# when processing feed #blogURL#',e);
				}
			}
		}	
	}
	
}
