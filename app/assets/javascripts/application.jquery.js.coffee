# App specific Coffeescript using JQuery
# Reply links in blogs to pop up a dialog
$(document).ready ->
  $('.replier').each ->
    $link = $(this)
    $dialog = $('<div></div>')
      .load($link.attr 'href')
      .dialog {
         autoOpen: false
         title: 'ublog reply'
         width: 600
         height: 300
         }
	    
    $link.click ->
      $dialog.dialog 'open'
      false

# Periodically update a div on page
$(document).ready ->
  $('.periodic-replace').each ->
    $target = $(this)
    $msec = parseInt($(this).attr 'data-frequency') * 1000
    $url = $(this).attr 'data-url'
#	$progress = $(this).attr 'data-progress'
    setInterval ->
      $target.load $url
    , $msec

