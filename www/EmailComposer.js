var exec = require('cordova/exec');

// Constructor
function EmailComposer(){}

EmailComposer.prototype = {

	//
	// Call to the Native code Class method
	// 
	// @param	{Object} args
	//			The object contains the following properties:
	//			subject, 
	//			body, 
	//			toRecipients, 
	//			ccRecipients,
	//			bccRecipients,
	//			isHtml
	//
	// @param	{Function} successCallback
	// @param	{Function} errorCallback
	//
	showEmailComposer: function(args, successCallback, errorCallback){

		exec(successCallback, errorCallback, 'EmailComposer', 'showEmailComposer', [args]);

	}
	
}

module.exports = new EmailComposer();