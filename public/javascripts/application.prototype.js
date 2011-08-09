// Include this for prototype.js 
// Supports some application specific actions

// Periodically call and replace inner html
document.observe("dom:loaded", function() {
    $$('div.periodic-replace').each(function(name, index) {
	    new Ajax.PeriodicalUpdater(this, readAttribute(this, 'data-url'), 
		    { method: 'get', frequency: parseInt(readAttribute(this, 'data-frequency')) })
    });
});

