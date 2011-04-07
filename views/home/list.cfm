<cfoutput>
<h2>Aggregated Blogs List</h2>
<table id="blogsTable" class="datatable">
		<thead>
			<tr>
				<th>Title</th>
				<th>Website URL</th>
				<th>Language</th>			
				<th>Last Build</th>
				<th>Last Updated</th>
			</tr>
		</thead>
		<tbody>
			<cfloop query="prc.qBlogs">	
				<tr>
					<td><a href="#blogURL#" title="#Title#">#Title#</a></td>
					<td><a href="#Websiteurl#">#Websiteurl#</a></td>
					<td>#Language#</td>			
					<td>#dateFormat(dateBuilt,'short')# #timeformat(dateBuilt,"medium")# </td>
					<td>#dateFormat(dateSumitted,'short')# #timeformat(dateSumitted,"medium")#</td>
				</tr>
			</cfloop>
		</tbody>
		<tfoot>
			<tr>
				<th>Title</th>
				<th>Website URL</th>
				<th>Language</th>			
				<th>Date Last Build</th>
				<th>Last Updated</th>
			</tr>
		</tfoot>
</table>
</cfoutput>