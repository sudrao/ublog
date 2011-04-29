// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Event.observe makes the cursor go to the very first input field (if any)
Event.observe(window, 'load', function() {
    var e = $A(document.getElementsByTagName('*')).find(function(e) {
      return (e.id == 'blog_content'); // (e.tagName.toUpperCase() == 'INPUT' && (e.type == 'text' || e.type == 'password'))
          // || e.tagName.toUpperCase() == 'TEXTAREA' || e.tagName.toUpperCase() == 'SELECT';
    });
    if (e) e.focus();
  });
