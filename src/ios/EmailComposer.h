//
//  EmailComposer.h
//
//
//  Created by Jesse MacFadyen on 10-04-05.
//  Copyright 2010 Nitobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <Cordova/CDV.h>

@interface EmailComposer : CDVPlugin <MFMailComposeViewControllerDelegate>{}

- (void) showEmailComposer:(CDVInvokedUrlCommand*)command;

@end