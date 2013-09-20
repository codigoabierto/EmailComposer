#import "EmailComposer.h"
#import <Cordova/CDV.h>

@implementation EmailComposer

- (void) showEmailComposer:(CDVInvokedUrlCommand*)command{

	NSString* subject 				= [options valueForKey:@"subject"];
	NSString* body 					= [options valueForKey:@"body"];
	NSString* toRecipientsString 	= [options valueForKey:@"toRecipients"];
	NSString* ccRecipientsString 	= [options valueForKey:@"ccRecipients"];
	NSString* bccRecipientsString 	= [options valueForKey:@"bccRecipients"];
	NSString* isHtml 				= [options valueForKey:@"isHtml"];
	CDVPluginResult* pluginResult 	= nil;

    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
	// Set subject
	if(subject != nil){
		[picker setSubject:subject];
	}
	// set body
	if(body != nil){
		if(isHtml != nil && [isHtml boolValue]){
			[picker setMessageBody:body isHtml:YES];
		} else {
			[picker setMessageBody:body isHtml:NO];
		}
	}

	// Set recipients
	if(toRecipientsString != nil){
		[picker setToRecipients:[ toRecipientsString componentsSeparatedByString:@","]];
	}
	if(ccRecipientsString != nil){
		[picker setCcRecipients:[ ccRecipientsString componentsSeparatedByString:@","]]; 
	}
	if(bccRecipientsString != nil){
		[picker setBccRecipients:[ bccRecipientsString componentsSeparatedByString:@","]];
	}

    // Attach an image to the email
	// NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"png"];
	// NSData *myData = [NSData dataWithContentsOfFile:path];
	// [picker addAttachmentData:myData mimeType:@"image/png" fileName:@"rainy"];
    
    if (picker != nil) {  	
        [self.viewController presentModalViewController:picker animated:YES];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Showing email compose dialog"];
    } else {
    	pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Unable to show email compose dialog"];
    }

    [picker release];

    // Report back to JS Interface
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];


}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {   
    
    CDVPluginResult* pluginResult = nil;
    // Notifies users about errors associated with the interface
	int webviewResult = 0;

    switch (result){
        case MFMailComposeResultCancelled:
			webviewResult = 0;
            break;
        case MFMailComposeResultSaved:
			webviewResult = 1;
            break;
        case MFMailComposeResultSent:
			webviewResult =2;
            break;
        case MFMailComposeResultFailed:
            webviewResult = 3;
            break;
        default:
			webviewResult = 4;
            break;
    }

    [self.viewController dismissModalViewControllerAnimated:YES];

    // Report back to JS Interface
	if(webviewResult != 4){
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:webviewResult];
	} else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"email composition completed but received no valid result"];
	}

	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

	//NSString* jsString = [[NSString alloc] initWithFormat:@"window.plugins.emailComposer._didFinishWithResult(%d);",webviewResult];
	//[self writeJavascript:jsString];
	//[jsString release];

}

/*
- (void) echo:(CDVInvokedUrlCommand*)command{

	CDVPluginResult* pluginResult = nil;
	NSString* echo = [command.arguments objectAtIndex:0];

	if(echo != nil && [echo length] > 0){
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
	} else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was null"];
	}

	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}
*/

@end