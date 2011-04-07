<cfcomponent hint="scheduler plugin" output="false" singleton="true">

<!------------------------------------------- CONSTRUCTOR ------------------------------------------->

	<cffunction name="init" access="public" returntype="any" output="false" hint="constructor">
		<cfscript>
			setPluginName("Scheduler plugin");
			setPluginVersion("1.5");
			setPluginDescription("Scheduler plugin");
			setPluginAuthor("AL");
			setPluginAuthorURL("http://www.alagukannan.com");
			return this;
		</cfscript>
	</cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------->

	<cffunction name="create" access="public" returntype="void" output="false" hint="create a schedule">
		<cfargument name="taskname" type="string" required="true">
		<cfargument name="interval" type="string" required="true" default="daily">
		<cfargument name="url" type="string" required="true">
		<cfargument name="startdate" type="string" required="true" default="#now()#">
		<cfargument name="starttime" type="string" required="true" default="00:00 AM">
		<cfargument name="requestTimeout" type="numeric" required="false" default="600">
		
		<cfschedule action="update" 
					task= "#arguments.taskname#"
					operation="httprequest" 
				    url= "#arguments.url#"
					interval= "#arguments.interval#"
					startdate="#arguments.startdate#"
					starttime ="#arguments.starttime#"
					requestTImeout= "#arguments.requestTimeout#"
					/>
	</cffunction>
	
	<cffunction name="remove" access="public" returntype="void" output="false" hint="stop a schedule task">
		<cfargument name="taskname" type="string" required="true">
		
		<cfschedule action="delete" 
					task= "#arguments.taskname#"
					/>
	</cffunction>
	
	<cffunction name="run" access="public" returntype="void" output="false" hint="stop a schedule task">
		<cfargument name="taskname" type="string" required="true">
		
		<cfschedule action="run" 
					task= "#arguments.taskname#"
					/>
	</cffunction>	

</cfcomponent>	
