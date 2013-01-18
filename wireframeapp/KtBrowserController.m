//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import "KtBrowserController.h"
#import "KtViewController.h"
#import "KtBrowserView.h"
#import "KtBrowserHeader.h"
#import "KtBrowserItemView.h"
#import "KtBrowserInfoPanel.h"

#import "KtDeletePopoverController.h"
#import "KtRenamePopoverController.h"
#import "KtCloudPopoverController.h"

#import "Wireframe.h"
#import "Documents.h"
#import "BackgroundSync.h"

#import "Reachability.h"

#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@implementation KtBrowserController


@synthesize infoPanel;
@synthesize browserView;
@synthesize btnEdit;
@synthesize btnDel;
@synthesize btnDone;
@synthesize btnAdd;
@synthesize lblTitle;
@synthesize browserHeader;
@synthesize scrollView;
@synthesize btnCloudSettings;
@synthesize wireframes;
@synthesize headerState;
@synthesize currentSelection;

@synthesize cloudPopover;
@synthesize deletePopover;
@synthesize renamePopover;

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self rebuild:self];
    cloudSyncTimer = [NSTimer scheduledTimerWithTimeInterval: 60 target: self selector: @selector(cloudSync) userInfo: nil repeats: YES];

    deletePopoverController = [[KtDeletePopoverController alloc] initWithNibName:@"KtDeletePopoverController" bundle:nil];
    deletePopover = [[UIPopoverController alloc] initWithContentViewController:deletePopoverController];
    deletePopover.popoverContentSize = deletePopoverController.view.frame.size;
    [deletePopoverController setBrowser:self];
    [deletePopoverController setPopover:deletePopover];
    
    renamePopoverController = [[KtRenamePopoverController alloc] initWithNibName:@"KtRenamePopoverController" bundle:nil];
    renamePopover = [[UIPopoverController alloc] initWithContentViewController:renamePopoverController];
    renamePopover.popoverContentSize = renamePopoverController.view.frame.size;
    [renamePopoverController setController:self];
    [renamePopoverController setPopover:renamePopover];
    
    cloudPopoverController = [[KtCloudPopoverController alloc] initWithNibName:@"KtCloudPopoverController" bundle:nil];
    [cloudPopoverController setBrowser:self];
    cloudPopover = [[UIPopoverController alloc] initWithContentViewController:cloudPopoverController];
    cloudPopover.popoverContentSize = cloudPopoverController.view.frame.size;
  //  if([[cloudPopoverController switcher] isOn] ) {
        [self.browserView refreshPositions];
  //  }
    [self.browserView findSize];
    [renamePopoverController.txtName setDelegate:self];
}


- (void)rename:(KtBrowserItemView*)w
{
    [renamePopoverController setBrowserItemView:w];
    [renamePopoverController refresh];
    [renamePopover presentPopoverFromRect:w.frame inView:self.browserView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];  
    
}

- (void) cloudSync
{
    NSLog(@"cloud sync");
 //   
    
  //  BOOL wifi = [[Reachability reachabilityForLocalWiFi] isReachableViaWiFi];
    
  //  dispatch_queue_t queue = dispatch_get_global_queue(                                              //DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
   //    dispatch_async(queue, ^{
    

            [[BackgroundSync getInstance] sync]; 
//    });
}

- (void)openWireframe:(Wireframe*)w
{
    currentFile = w;
    [self performSegueWithIdentifier:@"open" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"new"]) {
        KtViewController *vc = [segue destinationViewController];
        vc.browserController = self;
    }
    
    if ([[segue identifier] isEqualToString:@"open"]) {
        KtViewController *vc = [segue destinationViewController];
        vc.browserController = self;
        vc.wireframe =  currentFile;
    
    }
}

- (void)viewDidUnload
{
    [self setBrowserView:nil];
    [self setBtnEdit:nil];
    [self setBtnDel:nil];
    [self setBtnDone:nil];

    [self setBtnAdd:nil];
    [self setLblTitle:nil];
    [self setBrowserHeader:nil];
    [self setScrollView:nil];
    [self setBtnCloudSettings:nil];
    [self setInfoPanel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.browserHeader setNeedsDisplay];
    [self.infoPanel setNeedsDisplay];

}

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //[self.browserHeader setNeedsDisplay];
    //if([[cloudPopoverController switcher] isOn] ) {
        [self.browserView refreshPositions];
  //  }
    [self.browserView findSize];
    //CGRect bbounds = CGRectMake(0, 0, 1024, 3000);
    //self.browserView.bounds = bbounds;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // selected_object = 0;
    [self performSegueWithIdentifier: @"open" sender: self];
}

- (IBAction)btnEditClicked:(id)sender {
    [self setHeaderState:EDITING];
    [self refreshHeader:sender];
}

- (IBAction)btnDoneClicked:(id)sender {
    [self setHeaderState:BROWSING];
    [self.browserView deselectAll];
    [self refreshHeader:sender];
}

- (IBAction)btnDeleteClicked:(id)sender {
    [deletePopover presentPopoverFromRect:btnDel.frame inView:self.browserHeader permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)btnSyncClicked:(id)sender {
    [[BackgroundSync getInstance] sync];
}

- (IBAction)btnCloudSettingsClicked:(id)sender {
    [cloudPopover presentPopoverFromRect:btnCloudSettings.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


- (void) enterEditing:(id)sender
{
    [self.browserView shakeGallery:sender];
    
    [UIView animateWithDuration:KT_ANIMATION_DURATION animations:^{
        
        [self.btnDone setAlpha:1.0];
        [self.btnEdit setAlpha:0.0];
        [self.btnDel setAlpha:1.0];
        [self.btnAdd setAlpha:0.0];
        [self.lblTitle setText:KT_SELECT_FILE];
    }];
    
    [self.btnDone setHidden:NO];
    [self.btnEdit setHidden:YES];
    [self.btnDel setHidden:NO];
    [self.btnAdd setHidden:YES];  
    

}


- (void) enterBrowsing:(id)sender
{
    [self.browserView unshakeGallery:sender];
    
    [UIView animateWithDuration:KT_ANIMATION_DURATION animations:^{
        [self.btnDone setAlpha:0.0];
        [self.btnEdit setAlpha:1.0];
        [self.btnDel setAlpha:0.0];
        [self.btnAdd setAlpha:1.0];
        [self.lblTitle setText:@" "];
     }];
    
    [self.btnDone setHidden:YES];
    [self.btnEdit setHidden:NO];
    [self.btnDel setHidden:YES];
    [self.btnAdd setHidden:NO];  
}

- (void)rebuild:(id)sender {
    [self fetchRecords];
    [self.browserView setWireframes:self.wireframes];
    [self.browserView setController:self];
    [self.browserView rebuildViews];
    
    [self setHeaderState:BROWSING];
    [self refreshHeader:nil];
    
   
}


-(void)refreshHeader:(id)sender {
    switch (headerState) {
        case BROWSING:
            [self enterBrowsing:sender];
            break;
        
        case EDITING:
            [self enterEditing:sender];
            break;
            
        default:
            break;
    }
}


- (void)fetchRecords {   
    if(wireframes == nil) {
        wireframes = [[NSMutableArray alloc] init];
    } else {
        [wireframes removeAllObjects]; // lazy ass will reload everything
    }
    [Documents listWireframesSorted:wireframes];
} 

- (void) viewDidAppear:(BOOL)animated {
    [self rebuild:self];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == [renamePopoverController txtName]) {
        [renamePopoverController btnClicked:textField];
        //[textField resignFirstResponder];
    }
    return NO;
}


@end
