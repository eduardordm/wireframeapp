//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KtBrowserController;
@class KtBrowserItemView;

@interface KtRenamePopoverController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtName;

@property (retain, nonatomic) KtBrowserController *controller;
@property (retain, nonatomic) UIPopoverController *popover;

@property (retain, nonatomic) KtBrowserItemView* browserItemView;

- (void) initialize;

- (IBAction)btnClicked:(id)sender;

//- (BOOL)textFieldShouldReturn:(UITextField *)textField;

- (void) refresh;

@end
