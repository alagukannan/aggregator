$(function(){
	if ($('.datatable').length == 1){
		$('.datatable').dataTable();
	}
	
	$('a.remove').click(function(event){
		event.preventDefault();
		 var where_to= confirm("Do you really want to remove this feed?");
		 if (where_to== true)
		   window.location.href = $(this).attr('href');
	});
});
