//
//  KtPopoverController.m
//  WireframeApp
//
//  Created by [eduardo] on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KtPopoverController.h"

#import "KtStencilView.h"
#import "KtGridView.h"
#import "KtPopoverView.h"
#import "KtViewController.h"
#import "UIPlaceHolderTextView.h"

@implementation KtPopoverController
@synthesize btnDelete;
@synthesize sizeLabel;
@synthesize positionLabel;
@synthesize txtData;
@synthesize stencilView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
       // [txtData setPlaceholder:@"Text or data goes here"];
        //[txtData setPlaceholderColor:[UIColor grayColor]];
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

-(void)textFieldDidChange {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [txtData setDelegate:self];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [stencilView setData:textView.text];
    [stencilView setNeedsDisplay];
}

- (void)viewDidUnload
{


    [self setBtnDelete:nil];
    [self setSizeLabel:nil];
    [self setPositionLabel:nil];
    [self setTxtData:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


- (IBAction)sendToBack:(id)sender {
    KtStencilView *stencil = [((KtPopoverView*)self.view) stencil];
    [[stencil grid] sendSubviewToBack:[((KtPopoverView*)self.view) stencil]];
    [[stencil grid] bringSubviewToFront:(UIView*)[[stencil.grid controller] penLayer] ];
}

- (IBAction)bringToFront:(id)sender {
    KtStencilView *stencil = [((KtPopoverView*)self.view) stencil];
    [[stencil grid] bringSubviewToFront:stencil];
    [[stencil grid] bringSubviewToFront:(UIView*)[[stencil.grid controller] penLayer] ];
}

- (IBAction)btnDeleteClicker:(id)sender {
     KtStencilView *stencil = [((KtPopoverView*)self.view) stencil];
    [stencil deleteStencil];
}




@end
