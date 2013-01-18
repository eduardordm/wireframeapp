//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CAShapeLayer;
@class CABasicAnimation;

@class KtGridView;
@class KtPopoverController;
@class KtMoveButtonController;

@interface KtStencilView : UIView <UIGestureRecognizerDelegate> {
    UIButton* btnMove;
    @private float deltaX;
    @private float deltaY;
    BOOL selected;
    UITapGestureRecognizer* tapGesture;
    UITapGestureRecognizer* doubleTapGesture;
    CAShapeLayer* shapeLayer;
    KtPopoverController *popover;
    KtMoveButtonController *moveButton;
    
    
    NSString* title;
    NSString* data;
    UIImage* imgData;
    UIBezierPath* pathData;
    NSMutableArray* pointData;
    CGFloat x_s;
    CGFloat y_s;

    UITextField* label;
}


- (KtGridView*) grid;

- (void) draggedOut: (UIControl *) c withEvent: (UIEvent *) ev;

- (void) initialize;

- (void) setup;

- (void) buildButtons;

- (void)handleTap:(UITapGestureRecognizer *)sender;
- (void)handleDoubleTap:(UITapGestureRecognizer *)sender;

- (void) select:(BOOL)stencilselected;

- (void) deleteStencil;

- (void) snapIt;

- (void) updatePopover;

@property (atomic) BOOL selected;


@property (readwrite) CGFloat x_s;
@property (readwrite) CGFloat y_s;

@property (retain, nonatomic) NSString* title;
@property (retain, nonatomic) NSString* data;
@property (retain, nonatomic) UIImage* imgData;
@property (retain, nonatomic) UIBezierPath* pathData;
@property (retain, nonatomic) NSMutableArray* pointData;
@property (retain, nonatomic) UITextField* label;
@property (retain, nonatomic) KtPopoverController *popover;

- (void) showSelectionDash;
- (void) hideSelecionDash;

- (void) showPopover;
- (void) hidePopover;
-(CGRect) findPopoverPosition;

- (void) showResizeButton;
- (void) hideResizeButton;
-(CGRect) findResizeButtonPosition;

- (void) showPositionPopover;
- (void) hidePositionPopover;


@end
