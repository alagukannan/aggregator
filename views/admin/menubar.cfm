<cfoutput>
<div id="sidebar">
	<div class="sidebarbox">
       <h2>Admin Options</h2>
		<ul class="sidemenu">
			<li><a href="#event.BuildLink(linkto='#event.getCurrentModule()#.admin')#">Currently Aggregated feeds</a></li>
			<li><a href="#event.BuildLink(linkto='#event.getCurrentModule()#.admin.add')#">Add New Feed</a></li>			
		</ul>
	</div>
</div>
</cfoutput>
