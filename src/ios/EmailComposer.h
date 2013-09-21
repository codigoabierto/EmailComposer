//
//  EmailComposer.h
//
//	Version 1.2
//
//  Created by codigoabierto on 2013/09/21
//

#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <Cordova/CDV.h>

@interface EmailComposer : CDVPlugin <MFMailComposeViewControllerDelegate>{}

- (void) showEmailComposer:(CDVInvokedUrlCommand*)command;
//- (void) returnWithCode:(int)code;
- (NSString*) getMimeTypeFromFileExtension:(NSString*)extension;

@end