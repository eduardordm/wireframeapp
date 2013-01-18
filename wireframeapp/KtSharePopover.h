//
//  KtSharePopover.h
//  WireframeApp
//
//  Created by [eduardo] on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@class KtGridView;

@interface KtSharePopover : UIViewController <MFMailComposeViewControllerDelegate> {
    KtGridView* grid;
}

@property (retain, nonatomic) KtGridView* grid;

- (IBAction)cloudSync:(id)sender;

- (IBAction)emailPng:(id)sender;

- (IBAction)emailPdf:(id)sender;
@end
