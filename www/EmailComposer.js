var exec = require('cordova/exec');

// Constructor
function EmailComposer(){}

EmailComposer.prototype = {

	//
	// Call to the Native code Class method
	// 
	// @param	{Object} args
	//			The args object can contain any of the following properties:
	//				{String}	subject, 
	//				{String}	body, 
	//				{Array}		toRecipients, 
	//				{Array}		ccRecipients,
	//				{Array}		bccRecipients,
	//				{Boolean}	isHTML
	//
	// @param	{Function} successCallback
	// @param	{Function} errorCallback
	//
	showEmailComposer: function(args, successCallback, errorCallback){

		exec(successCallback, errorCallback, 'EmailComposer', 'showEmailComposer', [args]);

	}
	
}

module.exports = new EmailComposer();