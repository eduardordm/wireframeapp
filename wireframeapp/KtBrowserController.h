//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KtBrowserView;
@class KtBrowserHeader;
@class KtBrowserItemView;
@class KtBrowserInfoPanel;

@class KtDeletePopoverController;
@class KtRenamePopoverController;
@class KtCloudPopoverController;

@class Wireframe;

enum HeaderState
{
    BROWSING = 0,
    EDITING = 1
};

@interface KtBrowserController : UIViewController <UITextFieldDelegate> {
    NSMutableArray *wireframes; 
    KtBrowserItemView *currentSelection;
    enum HeaderState headerState;
    Wireframe* currentFile;
    NSTimer* cloudSyncTimer;
    
    KtDeletePopoverController *deletePopoverController;
    UIPopoverController *deletePopover;
    
    KtRenamePopoverController *renamePopoverController;
    UIPopoverController *renamePopover;
    
    KtCloudPopoverController *cloudPopoverController;
    UIPopoverController *cloudPopover;
}

@property (nonatomic, retain) NSMutableArray *wireframes; 
@property (retain, nonatomic) KtBrowserItemView *currentSelection;
@property (readwrite) enum HeaderState headerState;


// EXPOSE POPOVERS
@property (nonatomic, retain) UIPopoverController *deletePopover;
@property (nonatomic, retain) UIPopoverController *renamePopover;
@property (nonatomic, retain) UIPopoverController *cloudPopover;

// OUTLETS
@property (weak, nonatomic) IBOutlet KtBrowserInfoPanel *infoPanel;
@property (weak, nonatomic) IBOutlet KtBrowserView *browserView;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnDel;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet KtBrowserHeader *browserHeader;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnCloudSettings;

// ACTIONS
- (IBAction)btnEditClicked:(id)sender;
- (IBAction)btnDoneClicked:(id)sender;
- (IBAction)btnDeleteClicked:(id)sender;
- (IBAction)btnSyncClicked:(id)sender;
- (IBAction)btnCloudSettingsClicked:(id)sender;

// MSG
- (void)rebuild:(id)sender;
- (void)refreshHeader:(id)sender;
- (void)fetchRecords;
- (void)openWireframe:(Wireframe*)w;
- (void)rename:(KtBrowserItemView*)w;

// PRIVATE!
- (void) enterEditing:(id)sender;
- (void) enterBrowsing:(id)sender;
- (void) cloudSync;



@end
