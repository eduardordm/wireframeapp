//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import "KtStencilView.h"
#import "ktStencilButton.h"
#import "KtGridView.h"
#import "KtPopoverView.h"
#import "KtPopoverController.h"
#import "KtMoveButtonController.h"
#import "KtMoveButtonView.h"
#import "KtViewController.h"
#import "UIPlaceHolderTextView.h"
#import "KtViewController.h"
#import "KtSidebar.h"
#import "KtSidebarViewCell.h"


#import "KtPdfRenderer.h"
#import "KtWindowRenderer.h"
#import "KtArrowRenderer.h"
#import "KtDrawRenderer.h"
#import "KtLabelRenderer.h"
#import "KtBoxRenderer.h"

#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@implementation KtStencilView

@synthesize selected;

@synthesize title;
@synthesize data;
@synthesize imgData;
@synthesize pathData;
@synthesize pointData;
@synthesize label;
@synthesize popover;

@synthesize x_s;
@synthesize y_s;


- (void) setup {

}

- (void) initialize
{
    [self setClipsToBounds:true];
    [self buildButtons];

    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
    
    doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapGesture.delegate = self;
    [doubleTapGesture setNumberOfTapsRequired:2];
    [self addGestureRecognizer:doubleTapGesture];
 
    
    [self setBackgroundColor: [UIColor clearColor]];
    [self.layer setMasksToBounds: FALSE];

    [self setClipsToBounds:FALSE];
    
 
}

- (void) deleteStencil
{
    
    [self select:FALSE];
    [self removeFromSuperview];
    
    
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)sender
{
    UIScrollView *scroll = (UIScrollView *)[[self grid] superview];
    
    //CGFloat currentf = scroll.zoomScale * self.frame.width;

    
    float f = ( scroll.frame.size.width / (self.frame.size.width + 40));
    
    [scroll setZoomScale:f animated:TRUE];
    
//    CGRect m = CGRectMake(self.frame.origin.x-60, self.frame.origin.y-60, self.frame.size.width+40, self.frame.size.height);
    
    
    
   // [scroll scrollRectToVisible:m animated:YES];
    CGPoint p = CGPointMake(self.frame.origin.x, self.frame.origin.y);
    [scroll setContentOffset:p animated:YES];
}

- (void)handleTap:(UITapGestureRecognizer *)sender 
{
    UIScrollView *scroll = (UIScrollView *)[[self grid] superview];
  //  if([[[self grid] controller] selectedTool] == POINTER) {
        [self select:TRUE];
    [scroll scrollRectToVisible:self.frame animated:YES];
    
  //  }
    
}

-(CGRect) findPopoverPosition
{
    // top
    UIView *mainView = [[[self grid] superview] superview];
    return CGRectMake(mainView.bounds.size.width - (320+4), 
                      4, 
                      320, 172);
    
    
    // Follow
    /* UIScrollView *scroll = [[self grid] superview];
    
    
    CGFloat x = (self.frame.origin.x+self.frame.size.width ) * scroll.zoomScale - 40;
    CGFloat y = (self.frame.origin.y ) * scroll.zoomScale - 200 + 40;
    
    return CGRectMake(round(x), round(y), 240, 200); */
    
    
    // botton 
/*    UIView *mainView = [[[self grid] superview] superview];
    return CGRectMake(mainView.bounds.size.width - (320+10), 
                      mainView.bounds.size.height - (172+10), 
                      320, 172); */
    
}

- (void) showPopover
{
    
    popover = [[KtPopoverController alloc] initWithNibName:@"KtPopoverController" bundle:nil];
    
    [self.grid.controller setCurrentPopoverController:popover];
    [popover setStencilView:self];
    
    KtPopoverView *view = (KtPopoverView *)((UIViewController*)popover).view;
    [popover.txtData setPopover:popover];
    [popover.txtData setText:data];
    [view setStencil:self];
    view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    
  //  UIView *scroll = (UIView *)[[self grid] superview];
    
    CGRect frame = [self findPopoverPosition];
    [view setFrame:frame];
    [[[[self grid] superview] superview ] addSubview:view];
}

- (void) hidePopover
{
    if(popover != NULL) {
        data = [popover.txtData text];
        [((UIViewController*)popover).view removeFromSuperview];
        [self.grid.controller setCurrentPopoverController:nil];
        popover = nil;
    }
}

- (void) showResizeButton
{

    moveButton = [[KtMoveButtonController alloc] initWithNibName:@"KtMoveButtonController" bundle:nil];
    
    KtMoveButtonView *view = (KtMoveButtonView *)((UIViewController*)moveButton).view;
    [moveButton setStencil:self];
    [view setStencil:self];
    
    // UIView *scroll = (UIView *)[[self grid] superview];
    
    CGRect frame = [self findResizeButtonPosition];
    [view setFrame:frame];
    [[[self grid] superview] addSubview:view];
}

- (void) hideResizeButton 
{
    if(moveButton != NULL) {
        [((UIViewController*)moveButton).view removeFromSuperview];
        moveButton = nil;
    }
}

- (void) showPositionPopover 
{
    
}

- (void) hidePositionPopover
{
    
}

-(CGRect) findResizeButtonPosition
{
    UIScrollView *scroll = (UIScrollView *)[[self grid] superview];
    
    
    CGFloat x = (self.frame.origin.x+self.frame.size.width ) * scroll.zoomScale - 17;
    CGFloat y = (self.frame.origin.y+self.frame.size.height ) * scroll.zoomScale - 17;
    
    
    return CGRectMake(round(x), round(y), 39, 40);
}

- (void) buildButtons
{
    /*  btnMove = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     btnMove.frame = CGRectMake(0, 0, 30, 30);
     btnMove.backgroundColor = [UIColor grayColor];
     btnMove.alpha = 0.2; UITap
     [btnMove setImage:[UIImage imageNamed:@"256Px - 059.png"] forState:UIControlStateNormal];
     //   [btnMove addTarget:self action:@selector(btnMoveClick:)forControlEvents:UIControlEvent];
     
     [btnMove addTarget:self action:@selector(draggedOut:withEvent: ) forControlEvents: UIControlEventTouchDragOutside | UIControlEventTouchDragInside];
     
     btnMove.center = self.center;
     [self addSubview:btnMove];*/
    
    KtStencilButton* btn = [[KtStencilButton alloc ] initWithFrame:CGRectMake(0, 0, 40, 40)];
    btn.center = self.bounds.origin;
    // [self addSubview:btn];
}


- (void) draggedOut: (UIControl *) c withEvent: (UIEvent *) ev {
    c.center = [[[ev allTouches] anyObject] locationInView:self];
    self.center = c.center;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
        
    }
    return self;
}





- (void) showSelectionDash 
{
    
    [self hideSelecionDash];
    
   // if(![self.title isEqualToString:@"Draw"]) {
        // CGFloat rectanglePattern[] = {5, 1, 1, 1};
        
        CABasicAnimation *dashAnimation;
        
        shapeLayer = [CAShapeLayer layer]; 
        
        CGRect shapeRect = self.frame;
        [shapeLayer setBounds:shapeRect];
        [shapeLayer setPosition:self.center];
        [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
        [shapeLayer setStrokeColor:[[UIColor blackColor] CGColor]];
        [shapeLayer setOpacity:0.4f];
        [shapeLayer setLineWidth:1.0f];
        [shapeLayer setLineJoin:kCALineCapRound];
        [shapeLayer setLineDashPattern: [NSArray arrayWithObjects:[NSNumber numberWithInt:10],  [NSNumber numberWithInt:5],  nil]];
        
        CGRect r = CGRectMake(round(self.bounds.origin.x - 1), round(self.bounds.origin.y - 1),round(self.bounds.size.width + 2), round(self.bounds.size.height + 2));
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:r];
        [shapeLayer setPath:path.CGPath];
        [[self layer] addSublayer:shapeLayer];
        
        dashAnimation = [CABasicAnimation 
                         animationWithKeyPath:@"lineDashPhase"];
        
        [dashAnimation setFromValue:[NSNumber numberWithFloat:0.0f]];
        [dashAnimation setToValue:[NSNumber numberWithFloat:15.0f]];
        [dashAnimation setDuration:0.25f];
        [dashAnimation setRepeatCount:10000];
        
        [shapeLayer addAnimation:dashAnimation forKey:@"linePhase"];
 //   } 
   
    
}

- (void) hideSelecionDash 
{
    if(shapeLayer != NULL) {
        [shapeLayer removeAllAnimations];
        [shapeLayer setHidden:TRUE];
        [shapeLayer removeFromSuperlayer];
        shapeLayer = nil;
    }
}

- (void) select:(BOOL)stencilselected
{
    if(stencilselected || ![self selected]) {
        [self.grid deselectAll];
    }
    selected = stencilselected;
    if(stencilselected) {
        [self showPopover];
        [self showResizeButton];
        [self showSelectionDash];}
    else {
        [self hidePopover];
        [self hideResizeButton];
        [self hideSelecionDash];
    }   
    [self updatePopover];
}

- (IBAction)btnMoveClick:(id)sender {
}


- (void)drawRect:(CGRect)rect
{
    
    
    if([title isEqualToString:@"Label"]) {
        [KtLabelRenderer render:self withRect:rect];
        return;
    }
    
    if([title isEqualToString:@"Rect"]) {
        [KtBoxRenderer render:self withRect:rect];
        return;
    }
    
    if([title isEqualToString:@"Arrow"]) {
        [KtArrowRenderer render:self withRect:rect];
        return;
    } 
    
    if([title isEqualToString:@"Draw"]) {
        [KtDrawRenderer render:self withRect:rect];
        return;  
    }
    
    if([title isEqualToString:@"Label"]) {
        [KtLabelRenderer render:self withRect:rect];
        return;  
    }
    
    NSMutableArray* cells = self.grid.controller.sidebarModel.cells;
    
    if(cells == nil) {
        KtSidebar* sb = [[KtSidebar alloc] init];
        [sb buildViews];
        cells = sb.cells; // memory leak.
    }
    
    for(KtSidebarViewCell* cell in cells) {
        if ([title isEqualToString:cell.title]) {
            [KtPdfRenderer render:self withRectAndPdf:rect:cell.pdf];
            return;
        }
    }
    
    
    // Abstracted Graphic Attributes
    NSString* textContent = @"STENCIL NOT FOUND";
    

    // Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: rect];
    [[UIColor lightGrayColor] setFill];
    [rectanglePath fill];
     
    
    // Text Drawing
    CGRect textFrame = rect;
    [[UIColor blackColor] setFill];

    [textContent drawInRect: textFrame withFont: [UIFont fontWithName: @"Helvetica" size: 12] lineBreakMode: UILineBreakModeWordWrap alignment: UITextAlignmentCenter];

    
}

- (void) snapIt
{

    
    if([self.grid shouldSnapToGrid]) {
        
        
        // assume these constants
        CGFloat kVGridOffset, kHGridOffset; // the difference between the origin of the view and the origin of the grid
        kVGridOffset = 0;
        kHGridOffset = 0;
        
        CGFloat kVGridSpacing, kHGridSpacing; // the size of the grid itself
        kVGridSpacing = [self.grid gridSize]+[self.grid gridSize]/8.0;
        kHGridSpacing = [self.grid gridSize]+[self.grid gridSize]/8.0;
        
        CGPoint lastTouch = self.frame.origin;
        CGFloat horizontalOffset = 1;
        CGFloat verticalOffset = 1;
        
        // set initial coordinates from touch
        CGPoint drawPoint = CGPointMake(lastTouch.x - horizontalOffset, lastTouch.y - verticalOffset);
    
        // remove the offset, round to nearest increment of spacing, and return offset
        drawPoint.x = nearbyint((drawPoint.x - kHGridOffset) / kHGridSpacing) * kHGridSpacing + kHGridOffset;
        drawPoint.y = nearbyint((drawPoint.y - kVGridOffset) / kVGridSpacing) * kVGridSpacing + kVGridOffset;
    
        CGRect snapped = CGRectMake(drawPoint.x, drawPoint.y, self.frame.size.width, self.frame.size.height);
        //
        [self setFrame:snapped];
    
    }
    

    

}

- (void) updatePopover
{
    if (popover != NULL) {
        NSString* sizel = [NSString stringWithFormat:@"W:%.0f  H: %.0f",self.frame.size.width, self.frame.size.height ];
        NSString* posl = [NSString stringWithFormat:@"X:%.0f  Y: %.0f",self.frame.origin.x, self.frame.origin.y ];
        [popover.sizeLabel setText:sizel]; 
        [popover.positionLabel setText:posl]; 
    }
}


- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    if([[[self grid] controller] selectedTool] != POINTER) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.superview];
    
    // Set the correct center when touched 
    touchPoint.x -= deltaX;
    touchPoint.y -= deltaY;
    
    self.center = touchPoint;
    
    [self snapIt];
    
    if(moveButton != NULL) {
        UIView *view = ((UIViewController*)moveButton).view;
        
        CGRect frame = [self findResizeButtonPosition];
        
        [view setFrame:frame];
    }
    
    [self updatePopover];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if([[[self grid] controller] selectedTool] != POINTER) {
        return;
    }
    
    CGPoint beginCenter = self.center;
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.superview];
    
    deltaX = touchPoint.x - beginCenter.x;
    deltaY = touchPoint.y - beginCenter.y;
    
    
    UIScrollView* scroll = (UIScrollView*)[[self superview] superview];
    
    scroll.scrollEnabled = false;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if([[[self grid] controller] selectedTool] != POINTER) {
        return;
    }
    
    UIScrollView* scroll = (UIScrollView*)[[self superview] superview];
    
    scroll.scrollEnabled = true;
    
    if (popover != NULL) {
        KtPopoverView *view = (KtPopoverView *)((UIViewController*)popover).view;
        [view setStencil:self];
        
        CGRect frame = [self findPopoverPosition];
        
        [UIView animateWithDuration:KT_ANIMATION_DURATION animations:^{
            [view setFrame:frame];
        }];
    }
    
    if(moveButton != NULL) {
        UIView *view = ((UIViewController*)moveButton).view;
        
        CGRect frame = [self findResizeButtonPosition];
        
        [UIView animateWithDuration:KT_ANIMATION_DURATION animations:^{
            [view setFrame:frame];
        }]; 
    }
    
    [self snapIt];
    
    [self.grid.controller mergeWireframe];  
}

- (KtGridView*) grid
{
    return (KtGridView*)[self superview];
}

@end
