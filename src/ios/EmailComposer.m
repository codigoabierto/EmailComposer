#import "EmailComposer.h"
#import <Cordova/CDV.h>

@implementation EmailComposer

- (void) showEmailComposer:(CDVInvokedUrlCommand*)command{

	NSDictionary* parameters		= [command.arguments objectAtIndex:0];
	NSString* subject 				= [parameters valueForKey:@"subject"];
	NSString* body 					= [parameters valueForKey:@"body"];
	NSString* toRecipientsString 	= [parameters valueForKey:@"toRecipients"];
	NSString* ccRecipientsString 	= [parameters valueForKey:@"ccRecipients"];
	NSString* bccRecipientsString 	= [parameters valueForKey:@"bccRecipients"];
	NSString* isHtml 				= [parameters valueForKey:@"isHtml"];
	CDVPluginResult* pluginResult 	= nil;

    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    mailCompose.mailComposeDelegate = self;
    
	// Set subject
	if(subject != nil){
		[mailCompose setSubject:subject];
	}
	// set body
	if(body != nil){
		if(isHtml != nil && [isHtml boolValue]){
			[mailCompose setMessageBody:body isHTML:YES];
		} else {
			[mailCompose setMessageBody:body isHTML:NO];
		}
	}

	// Set recipients
	if(toRecipientsString != nil){
		[mailCompose setToRecipients:[ toRecipientsString componentsSeparatedByString:@","]];
	}
	if(ccRecipientsString != nil){
		[mailCompose setCcRecipients:[ ccRecipientsString componentsSeparatedByString:@","]]; 
	}
	if(bccRecipientsString != nil){
		[mailCompose setBccRecipients:[ bccRecipientsString componentsSeparatedByString:@","]];
	}

    // Attach an image to the email
	// NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"png"];
	// NSData *myData = [NSData dataWithContentsOfFile:path];
	// [mailCompose addAttachmentData:myData mimeType:@"image/png" fileName:@"rainy"];
    
    if (mailCompose != nil) {  	
        [self.viewController presentModalViewController:mailCompose animated:YES];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Showing email compose dialog"];
    } else {
    	pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Unable to show email compose dialog"];
    }

    // Report back to JS Interface
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];


}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {   
    
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