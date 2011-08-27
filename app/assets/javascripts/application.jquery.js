// App specific javascript using JQuery

// Reply links in blogs to pop up a dialog
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

// Periodically update a div on page
$(document).ready(function() {
	$('.periodic-replace').each(function() {
		var $target = $(this);
		var $msec = parseInt($(this).attr('data-frequency')) * 1000;
		var $url = $(this).attr('data-url');
//		var $progress = $(this).attr('data-progress');
		setInterval(function() {
			$target.load($url)
		}, $msec);
	});
});
