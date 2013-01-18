//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KtSidebarView.h"
#import "KtGridView.h"
#import "KtMainView.h"
#import "KtSidebar.h"


enum ScreenState
{
    SIDEBAR_AND_GRID = 0,
    FULLSCREEN_ONLY = 1
};

enum ToolSelection
{
    POINTER = 0,
    ARROW = 1,
    LABEL = 2,
    DRAW = 3,
    ERASER = 4
};

@class Wireframe;
@class KtBrowserController;
@class KtSharePopover;
@class KtGridOptionsPopover;
@class SmoothLineView;
@class KtPenLayer;
@class KtPopoverController;

@interface KtViewController : UIViewController <UIScrollViewDelegate> {
    
    enum ScreenState screenState;
    
    KtSidebar* sidebarModel;
    
    Wireframe* wireframe;
    
    KtSharePopover *sharePopoverController;
    UIPopoverController *sharePopover;
    
    KtGridOptionsPopover *gridPopoverController;
    UIPopoverController *gridPopover;
    
    enum ToolSelection selectedTool;
    

    NSIndexPath * currentIndexPath;
    
    
    
}

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic, retain) KtBrowserController *browserController;

@property (weak, nonatomic) KtPopoverController *currentPopoverController;

@property (nonatomic, retain) Wireframe* wireframe;

@property (readwrite) enum ToolSelection selectedTool;

@property (readwrite) enum ScreenState screenState;
@property (strong) KtSidebar* sidebarModel;

- (void) refreshDisplay;
- (void) refreshToolIcons;
- (void) mergeWireframe;

- (void)keyboardWillShow:(NSNotification *)notif;
- (void)keyboardWillHide:(NSNotification *)notif;

/* OUTLETS */
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet KtMainView *mainView;
@property (weak, nonatomic) IBOutlet KtSidebarView *sidebarView;
@property (weak, nonatomic) IBOutlet KtGridView *gridView;
@property (weak, nonatomic) IBOutlet UIScrollView *gridScroll;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnFullscreen;
@property (weak, nonatomic) IBOutlet UIButton *btnGrid;
@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer *pinchRecognizer;
@property (weak, nonatomic) IBOutlet UIButton *btnZoom100;
@property (weak, nonatomic) IBOutlet UIButton *btnPointer;
@property (weak, nonatomic) IBOutlet UIButton *btnArrow;
@property (weak, nonatomic) IBOutlet UIButton *btnText;
@property (weak, nonatomic) IBOutlet UIButton *btnDraw;
@property (weak, nonatomic) IBOutlet KtPenLayer *penLayer;
@property (weak, nonatomic) IBOutlet UIView *popoverFrameView;
@property (weak, nonatomic) IBOutlet UILabel *lblZoom;


/* ACTIONS */
- (IBAction)btnFullscreenClicked:(id)sender;
- (IBAction)closeClicked:(id)sender;
//- (IBAction)pinched:(id)sender;
- (IBAction)btnZoom100Clicked:(id)sender;

- (IBAction)btnCloudUpClicked:(id)sender;
- (IBAction)btnPointerClicked:(id)sender;
- (IBAction)btnArrowClicked:(id)sender;
- (IBAction)btnTextClicked:(id)sender;
- (IBAction)btnDrawClicked:(id)sender;
- (IBAction)btnEraserClicked:(id)sender;




@end
