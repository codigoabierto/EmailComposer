//
//  EmailComposer.m
//
//	Version 1.2
//
//  Created by codigoabierto on 2013/09/21
//

#import "EmailComposer.h"
#import <Cordova/CDV.h>
#import <MobileCoreServices/MobileCoreServices.h>

/*
#define RETURN_CODE_EMAIL_CANCELLED 0
#define RETURN_CODE_EMAIL_SAVED 1
#define RETURN_CODE_EMAIL_SENT 2
#define RETURN_CODE_EMAIL_FAILED 3
#define RETURN_CODE_EMAIL_NOTSENT 4
*/

@implementation EmailComposer

- (void) showEmailComposer:(CDVInvokedUrlCommand*)command{

	NSDictionary* parameters = [command.arguments objectAtIndex:0];
	NSString* subject = [parameters objectForKey:@"subject"];
	NSString* body = [parameters objectForKey:@"body"];
	NSArray* toRecipientsArray = [parameters objectForKey:@"toRecipients"];
	NSArray* ccRecipientsArray = [parameters objectForKey:@"ccRecipients"];
	NSArray* bccRecipientsArray = [parameters objectForKey:@"bccRecipients"];
	BOOL isHTML = [[parameters objectForKey:@"isHTML"] boolValue];
	NSArray* attachmentPaths = [parameters objectForKey:@"attachments"];
	int counter = 1;
	CDVPluginResult* pluginResult = nil;

    MFMailComposeViewController* mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    
	// set subject
	if(subject){
		[mailComposer setSubject:subject];
	}
	// set body and isHTML
	if(body){

		// @todo validate existence of isHTML
		[mailComposer setMessageBody:body isHTML:isHTML];

	}

	// set recipients
	if(toRecipientsArray){
		[mailComposer setToRecipients:toRecipientsArray];
	}
	if(ccRecipientsArray){
		[mailComposer setCcRecipients:ccRecipientsArray]; 
	}
	if(bccRecipientsArray){
		[mailComposer setBccRecipients:bccRecipientsArray];
	}

	if(attachmentPaths){
		for(NSString* path in attachmentPaths){
			@try{
				NSData* data = [[NSFileManager defaultManager] contentsAtPath:path];
				[mailComposer 
					addAttachmentData:data 
					mimeType:[self getMimeTypeFromFileExtension:[path pathExtension]] 
					fileName:[NSString stringWithFormat:@"attachment%d.%@", counter, [path pathExtension]]];
			} @catch(NSException* exception){
				DLog(@"Cannot attach file at path %@; error %@", path, exception);
			}
		}
	}

    if (mailComposer != nil) {  	
        [self.viewController presentModalViewController:mailComposer animated:YES];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Showing Mail composer dialog"];
    } else {
    	pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Unable to show Mail composer dialog"];
    }

    // report back to JS Interface
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];


}


// Dismisses the email composition interface when users tap Cancel or Send. 
// Proceeds to update the message field with the result of the operation.
- (void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    // Notifies users about errors associated with the interface
    // @todo report back to JS interface using CDVPluginResult
    /* 
	int webviewResult = 0;

    switch (result){
        case MFmailComposerResultCancelled:
			webviewResult = 0;
            break;
        case MFmailComposerResultSaved:
			webviewResult = 1;
            break;
        case MFmailComposerResultSent:
			webviewResult =2;
            break;
        case MFmailComposerResultFailed:
            webviewResult = 3;
            break;
        default:
			webviewResult = 4;
            break;
    }
    */

    [controller dismissModalViewControllerAnimated:YES];

    /*
	//NSString* jsString = [[NSString alloc] initWithFormat:@"window.plugins.emailComposer._didFinishWithResult(%d);",webviewResult];
	//[self writeJavascript:jsString];
	*/

}

// Retrieve the mime type from the file extension
- (NSString*) getMimeTypeFromFileExtension:(NSString*)extension {

    if (!extension){
        return nil;
    }
    CFStringRef pathExtension, type;
    // Get the UTI from the file's extension
    pathExtension = (CFStringRef)CFBridgingRetain(extension);
    type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, NULL);
    
    // Converting UTI to a mime type
   return (NSString*)CFBridgingRelease(UTTypeCopyPreferredTagWithClass(type, kUTTagClassMIMEType));

}

@end