//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import "KtDeletePopoverController.h"

#import "KtBrowserController.h"
#import "KtBrowserItemView.h"

#import "Wireframe.h"

@implementation KtDeletePopoverController

@synthesize browser;
@synthesize popover;

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)btnDeleteClicked:(id)sender {
    if(browser.currentSelection != nil) {
        [[browser.currentSelection wireframe] deleteFile];
        browser.currentSelection = nil;
        NSLog(@"delete!");
        [browser rebuild:sender];
    } 
    [popover dismissPopoverAnimated:TRUE];
}
@end
