//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import "KtRenamePopoverController.h"

#import "KtBrowserItemView.h"
#import "Wireframe.h"
#import "KtBrowserController.h"

@implementation KtRenamePopoverController
@synthesize txtName;
@synthesize popover;
@synthesize browserItemView;
@synthesize controller;

- (void) initialize
{
  //  [txtName setDelegate:controller];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initialize];
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


- (void) refresh {
    [txtName setText:browserItemView.wireframe.name];
    [txtName becomeFirstResponder];
}

- (void)viewDidUnload
{
    [self setTxtName:nil];
    [self setPopover:nil];
    [self setController:nil];
    [self setBrowserItemView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)btnClicked:(id)sender {
    [browserItemView.wireframe renameFile:txtName.text];
    [popover dismissPopoverAnimated:TRUE];
    [browserItemView.label setText:browserItemView.wireframe.name];
}


@end
