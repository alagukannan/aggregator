component  displayname="basehandler" hint="the base handler" output="false"
{
	property name="logger" inject="logBox:logger:aggregatorModule" scope="instance";
	property name="htmlhelper" inject="coldbox:plugin:htmlhelper" scope="instance";	
	instance = {};
	public any function init(){
		return this;
	}
	
	function onMissingAction(event,missingAction,eventArguments){
		var rc = event.getCollection();
	}
	
	function onError(event,faultAction,exception,eventArguments){
		var rc = event.getCollection();
		rc.exception = arguments.exception;
		instance.logger.error('error occured @ #event.getCurrentEvent()#',arguments.exception);
		event.setView("error");
	}
}