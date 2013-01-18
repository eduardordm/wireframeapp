//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import "KtCloudPopoverController.h"
#import "KtBrowserController.h"
#import <DropboxSDK/DropboxSDK.h>

@implementation KtCloudPopoverController
@synthesize switcher;
@synthesize btnICloud;
@synthesize browser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [switcher setOn:[prefs boolForKey:@"auto_organize"]];
    
}

- (void)viewDidUnload
{
    [self setBtnICloud:nil];

    [self setSwitcher:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)btnDropbox:(id)sender {
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] link];
    }
}
- (IBAction)switchSwitched:(id)sender {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:[switcher isOn] forKey:@"auto_organize"];
   // if(![switcher isOn]) {
        [browser rebuild:sender];
   // }
    [browser.cloudPopover dismissPopoverAnimated:TRUE];
}
@end
