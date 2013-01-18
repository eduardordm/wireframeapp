//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KtBrowserController;

@interface KtCloudPopoverController : UIViewController {
    KtBrowserController *browser;
}
- (IBAction)btnDropbox:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnICloud;
- (IBAction)switchSwitched:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *switcher;

@property (retain, nonatomic) KtBrowserController *browser;

@end
