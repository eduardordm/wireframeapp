//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KtBrowserController;
@class KtBrowserInfoPanel;
@class KtBrowserInfoPanelController;
@class KtBrowserItemView;

@interface KtBrowserView : UIView {
    NSMutableArray *wireframes;
    NSMutableArray *views;
   // KtBrowserInfoPanel *infoPanel;
    KtBrowserInfoPanelController *infoPanelController;
}


@property (nonatomic, retain) NSMutableArray *wireframes; 
@property (nonatomic, retain) NSMutableArray *views; 
//@property (nonatomic, retain) KtBrowserInfoPanel *infoPanel;

@property (nonatomic, retain) KtBrowserController *controller; 

- (void) initialize;
- (void) rebuildViews;
- (void) refreshPositions;
- (void) findSize;


- (CGRect) buildItemRect: (int)line : (int)column : (KtBrowserItemView*)v_view;

- (void) deselectAll;
- (void)shakeGallery:(id)sender;
- (void)unshakeGallery:(id)sender;

@end
