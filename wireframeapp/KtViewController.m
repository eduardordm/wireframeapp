//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import "KtViewController.h"
#import "KtSidebarViewCell.h"
#import "KtBrowserController.h"
#import "KtSidebar.h"
#import "Wireframe.h"
#import "KtPopoverView.h"
#import "KtStencilView.h"
#import "KtMoveButtonView.h"
#import "KtSharePopover.h"
#import "KtGridOptionsPopover.h"
#import "SmoothLineView.h"
#import "KtPenLayer.h"

#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@implementation KtViewController
@synthesize scrollView;
@synthesize btnFullscreen;
@synthesize btnGrid;
@synthesize pinchRecognizer;
@synthesize btnZoom100;
@synthesize btnPointer;
@synthesize btnArrow;
@synthesize btnText;
@synthesize btnDraw;
@synthesize penLayer;
@synthesize popoverFrameView;
@synthesize lblZoom;


@synthesize mainView;
@synthesize sidebarView;
@synthesize gridView;
@synthesize gridScroll;
@synthesize screenState;
@synthesize selectedTool;
@synthesize table;
@synthesize btnShare;
@synthesize sidebarModel;

@synthesize wireframe;
@synthesize imgView;
@synthesize browserController;
@synthesize currentPopoverController;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    selectedTool = POINTER;
	// Do any additional setup after loading the view, typically from a nib.
    [self.btnZoom100 setHidden:TRUE];
    self.screenState = SIDEBAR_AND_GRID;
    [self refreshDisplay]; 
    self.sidebarModel = [[KtSidebar alloc] init];
    
    sharePopoverController = [[KtSharePopover alloc] initWithNibName:@"KtSharePopover" bundle:nil];
    sharePopover = [[UIPopoverController alloc] initWithContentViewController:sharePopoverController];
    sharePopover.popoverContentSize = CGSizeMake(272, 174);
    [sharePopoverController setGrid:gridView];
    
    gridPopoverController = [[KtGridOptionsPopover alloc] initWithNibName:@"KtGridOptionsPopover" bundle:nil];
    gridPopover = [[UIPopoverController alloc] initWithContentViewController:gridPopoverController];
    gridPopover.popoverContentSize = gridPopoverController.view.frame.size;
    [gridPopoverController setGrid:gridView];
    [gridPopoverController setController:self];
    
    [gridScroll setContentSize:gridView.frame.size];
    
    //self.table.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.jpg"]];
    
   // self.table.layer.cornerRadius = 30.0f;
    
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.jpg"]];
    
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.maximumZoomScale = 6.0;
    self.scrollView.delegate = self;
    
    if(wireframe == nil) {    // new file     
        wireframe = [[Wireframe alloc] initWithGrid:self.gridView];
    }
    [wireframe setGridView:self.gridView];
    [wireframe loadFromFile];
    [self refreshToolIcons];
    
    [penLayer setController:self];
    
    [gridView bringSubviewToFront:penLayer];
    
}

- (void) mergeWireframe
{
    
    [wireframe mergeExistingFile]; 
    
}

- (void) refreshToolIcons
{
    
    
    [btnDraw setImage:[UIImage imageNamed: (selectedTool == DRAW ? @"btn_draw_over.png" : @"btn_draw.png")] forState:UIControlStateNormal];
    [btnPointer setImage:[UIImage imageNamed: (selectedTool == POINTER ? @"btn_hand_over.png" : @"btn_hand.png")] forState:UIControlStateNormal];
    [btnArrow setImage:[UIImage imageNamed: (selectedTool == ARROW ? @"btn_arrow_over.png" : @"btn_arrow.png")] forState:UIControlStateNormal];
    [btnText setImage:[UIImage imageNamed: (selectedTool == LABEL ? @"btn_text_over.png" : @"btn_text.png")] forState:UIControlStateNormal];
}

- (void)viewDidUnload
{
    [self setGridView:nil];
    [self setSidebarView:nil];
    [self setMainView:nil];
    [self setTable:nil];
    [self setGridScroll:nil];
    [self setScrollView:nil];
    [self setBtnFullscreen:nil];
    [self setBtnGrid:nil];
    [self setPinchRecognizer:nil];
    [self setBtnZoom100:nil];
    [self setBtnShare:nil];
    [self setBtnPointer:nil];
    [self setBtnArrow:nil];
    [self setBtnText:nil];
    [self setBtnDraw:nil];

    [self setPenLayer:nil];

    [self setImgView:nil];
    [self setPopoverFrameView:nil];
    [self setLblZoom:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.gridView toggleGrid];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) 
                                                 name:UIKeyboardWillHideNotification object:self.view.window]; 
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.sidebarView setController:self];
    [self.gridView setController:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [gridView saveThumb:wireframe.name];
    [self mergeWireframe]; 
	[super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    for(UIView* v in mainView.subviews) {
        if(v.class == [KtPopoverView class]) {
            KtPopoverView *view = (KtPopoverView *)v;
            CGRect frame = [[view stencil] findPopoverPosition];
            
            
             [UIView animateWithDuration:KT_ANIMATION_DURATION animations:^{
            [view setFrame:frame];
              }];
        } 
        
    } 
}

- (void)keyboardWillShow:(NSNotification *)notif
{
    // The keyboard will be shown. If the user is editing the author, adjust the display:
    NSLog(@"SHOW KEYBOARD");
    
}

- (void)keyboardWillHide:(NSNotification *)notif
{
     NSLog(@"HIDE KEYBOARD");
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{

    
    [sidebarView setNeedsDisplay];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


- (IBAction)closeClicked:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];
    [self.browserController fetchRecords];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for(UIView* v in gridScroll.subviews) {
        if(v.class == [KtPopoverView class]) {
            KtPopoverView *view = (KtPopoverView *)v;
            CGRect frame = [[view stencil] findPopoverPosition];
            
            //frame = CGRectMake(frame.origin.x * scale, frame.origin.y * scale, frame.size.width, frame.size.height);
            
           // [UIView animateWithDuration:KT_ANIMATION_DURATION animations:^{
                [view setFrame:frame];
          //  }];
        }
        
        if(v.class == [KtMoveButtonView class]) {
            KtMoveButtonView *view = (KtMoveButtonView *)v;
            
            CGRect frame = [[view stencil] findResizeButtonPosition];
            
            [view setFrame:frame];
            
        }
        
        
    }
    
    if(selectedTool == DRAW || selectedTool == ERASER) {
        penLayer.userInteractionEnabled = TRUE;
        gridScroll.scrollEnabled = false;
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView2
{
    [btnZoom100 setHidden:(scrollView2.zoomScale == 1.0)];
    [lblZoom setHidden:(scrollView2.zoomScale == 1.0)];
    [lblZoom setText:[NSString stringWithFormat:@"%.0f%%", scrollView2.zoomScale * 100]];    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale 
{
    NSLog(@"BANG!");
    [btnZoom100 setHidden:(scale == 1.0)];
    [lblZoom setHidden:(scale == 1.0)];
    [lblZoom setText:[NSString stringWithFormat:@"%.0f%%", scale * 100]];
    
    for(UIView* v in gridScroll.subviews) {
        if(v.class == [KtPopoverView class]) {
                KtPopoverView *view = (KtPopoverView *)v;
                CGRect frame = [[view stencil] findPopoverPosition];
                
            //frame = CGRectMake(frame.origin.x * scale, frame.origin.y * scale, frame.size.width, frame.size.height);
            
                [UIView animateWithDuration:KT_ANIMATION_DURATION animations:^{
                    [view setFrame:frame];
                }];
        }
        if(v.class == [KtMoveButtonView class]) {
            KtMoveButtonView *view = (KtMoveButtonView *)v;
            
            CGRect frame = [[view stencil] findResizeButtonPosition];
            
            [view setFrame:frame];
            
        }
        
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.gridView;
}

/*
- (IBAction)pinched:(id)sender {
    CGAffineTransform transform = CGAffineTransformMakeScale(pinchRecognizer.scale, pinchRecognizer.scale);

    self.gridView.transform = transform;
}*/

- (void) refreshDisplay
{
    CGFloat alpha = 1.0;
    switch (screenState) {
        case FULLSCREEN_ONLY: {
            [self.btnFullscreen setImage:[UIImage imageNamed:@"icon_display_m.png"] forState:UIControlStateNormal];
            alpha = 0.0;
            break;
        }
            
        case SIDEBAR_AND_GRID: {
            [self.btnFullscreen setImage:[UIImage imageNamed:@"icon_display.png"] forState:UIControlStateNormal];
            alpha = 1.0;
            break;
        }
            
        default:
            break;
    } 
    
    [UIView animateWithDuration:KT_ANIMATION_DURATION animations:^{
        [sidebarView setAlpha:alpha];
    }];
    
    [self.mainView setNeedsDisplay];
   
}

- (IBAction)btnFullscreenClicked:(id)sender {
    
    switch (screenState) {
        case FULLSCREEN_ONLY: {
            screenState = SIDEBAR_AND_GRID; 
            break;
        }
            
        case SIDEBAR_AND_GRID: {
             screenState = FULLSCREEN_ONLY;
            break;
        }
            
        default:
            break;
    }
    
    [self refreshDisplay];
}

- (IBAction)btnGridClicked:(id)sender {
    [gridPopover presentPopoverFromRect:btnGrid.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}

- (void) switchSidebar
{
/*    CGRect sidebarFrame = [sidebarView frame];
    CGRect gridFrame = [gridView frame];
    CGRect gridBounds = [gridView bounds];
    CGRect scrollFrame = [gridScroll frame];
    CGRect sidebarButtonFrame = sidebarShowButton.frame;
    float alpha = 0.0;
    
    scrollFrame.size.width = self.mainView.bounds.size.width;
    gridFrame.size.width = 5000;
    gridBounds.size.width = 5000;
    
    sidebarButtonFrame.origin.y = mainView.bounds.size.height - sidebarShowButton.frame.size.height - 6;
    
    switch (screenState) {
        case FULLSCREEN_ONLY: {
            screenState = SIDEBAR_AND_GRID; 
            sidebarButtonFrame.origin.x = KT_SIDEBAR_WIDTH + 6;
            sidebarFrame.origin.x = 0;
            gridFrame.origin.x = KT_SIDEBAR_WIDTH;
            scrollFrame.origin.x = KT_SIDEBAR_WIDTH;
            alpha = 1.0;
            break;
        }
        
        case SIDEBAR_AND_GRID: {
            screenState = FULLSCREEN_ONLY;
            sidebarFrame.origin.x = -KT_SIDEBAR_WIDTH;
            
            sidebarButtonFrame.origin.x = 6;
            gridFrame.origin.x = 0;   
            scrollFrame.origin.x = 0;
            alpha = 0.0;
            break;
        }
            
        default:
            break;
    }
    
    [UIView animateWithDuration:KT_ANIMATION_DURATION animations:^{
        [sidebarShowButton setFrame:sidebarButtonFrame];
        [sidebarView setFrame:sidebarFrame];
        [scrollView setFrame:scrollFrame];
    }];*/
    
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.sidebarModel cells] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    
    return [[self.sidebarModel cells] objectAtIndex:indexPath.row];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentIndexPath = indexPath;
    selectedTool = POINTER;
    gridScroll.scrollEnabled = true;
    [self refreshToolIcons];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"close"]) {
  
    }
}

- (IBAction)btnZoom100Clicked:(id)sender {
   // CGAffineTransform transform = CGAffineTransformMakeScale(1.0, 1.0);
   // self.gridView.transform = transform; 
   // [self.scrollView setNeedsDisplay];
    
    [UIView animateWithDuration:KT_ANIMATION_DURATION animations:^{
        [self.scrollView setZoomScale:1.0];
        [self.btnZoom100 setHidden:true];
    }];

}

- (IBAction)btnCloudUpClicked:(id)sender {
    
       [sharePopover presentPopoverFromRect:btnShare.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)btnPointerClicked:(id)sender {
    
    [table deselectRowAtIndexPath:currentIndexPath animated:TRUE];
    selectedTool = POINTER;
    penLayer.userInteractionEnabled = FALSE;
    [self refreshToolIcons];
    gridScroll.scrollEnabled = true;
}

- (IBAction)btnArrowClicked:(id)sender {
    [table deselectRowAtIndexPath:currentIndexPath animated:TRUE];
    selectedTool = ARROW;
    penLayer.userInteractionEnabled = FALSE;
    [self refreshToolIcons];
    gridScroll.scrollEnabled = false;
}

- (IBAction)btnTextClicked:(id)sender {
    [table deselectRowAtIndexPath:currentIndexPath animated:TRUE];
    selectedTool = LABEL;
    penLayer.userInteractionEnabled = FALSE;
    [self refreshToolIcons];
    gridScroll.scrollEnabled = true;
}

- (IBAction)btnDrawClicked:(id)sender {
    [table deselectRowAtIndexPath:currentIndexPath animated:TRUE];
    selectedTool = DRAW;
    penLayer.userInteractionEnabled = TRUE;
    [self refreshToolIcons];
    gridScroll.scrollEnabled = false;
}

- (IBAction)btnEraserClicked:(id)sender {
    [table deselectRowAtIndexPath:currentIndexPath animated:TRUE];
    selectedTool = ERASER;
    penLayer.userInteractionEnabled = TRUE;
    [self refreshToolIcons];
    gridScroll.scrollEnabled = false;
}

//---called when the user clicks outside the popover view---
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    
    NSLog(@"popover about to be dismissed");
    return YES;
}

//---called when the popover view is dismissed---
- (void)popoverControllerDidDismissPopover:
(UIPopoverController *)popoverController {
    
    NSLog(@"popover dismissed");    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"KEYBOARD!");
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    /* resign first responder, hide keyboard, move views */
}


@end
