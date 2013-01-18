//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KtBrowserController;

@interface KtDeletePopoverController : UIViewController {
    KtBrowserController* browser;
}

- (IBAction)btnDeleteClicked:(id)sender;

@property (nonatomic, retain) KtBrowserController* browser;
@property (nonatomic, retain) UIPopoverController* popover;

@end
