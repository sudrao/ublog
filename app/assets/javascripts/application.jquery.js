// App specific javascript using JQuery
$(document).ready(function() {
	$('.replier').each(function() {
		var $link = $(this);
		var $dialog = $('<div></div>')
	  	  .load($link.attr('href'))
	  	  .dialog({
	  	  	autoOpen: false,
	    	title: 'ublog reply',
	    	width: 600,
	    	height: 300
	  	  });
	    
		$link.click(function() {
			$dialog.dialog('open');
			return false;
		});
	});
});
