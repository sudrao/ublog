// Include this for prototype.js 
// Supports some application specific actions

// Periodically call and replace inner html
document.observe("dom:loaded", function() {
	$$('div.periodic-replace').each(function(div, index) {
		new Ajax.PeriodicalUpdater(div, div.readAttribute('data-url'),
		 {method: 'get', frequency: parseInt(div.readAttribute('data-frequency')) });
		 return false;
	});
});

