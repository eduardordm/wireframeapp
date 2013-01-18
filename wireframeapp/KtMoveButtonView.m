//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import "KtMoveButtonView.h"
#import "KtStencilView.h"


#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>


@implementation KtMoveButtonView

@synthesize stencil;


- (void) initialize 
{
     self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_move_bg.png"]];
}


- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    UIScrollView* scroll = (UIScrollView*)[self superview];
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.superview];
    
    // Set the correct center when touched 
    touchPoint.x -= deltaX ;
    touchPoint.y -= deltaY ;
    
 
    
    self.center = touchPoint;
    
    touchPoint.x /= scroll.zoomScale;
    touchPoint.y /= scroll.zoomScale;
    
    CGRect f = CGRectMake(stencil.frame.origin.x, stencil.frame.origin.y, 
                          (touchPoint.x - stencil.frame.origin.x) , 
                          (touchPoint.y - stencil.frame.origin.y)  );
    
    // CGRect bounds = CGRectMake(0, 0, f.size.width, f.size.height);
    
    [stencil setFrame:f];
    
    if([[stencil title] isEqualToString:@"Draw"]){
        [stencil setNeedsDisplay];
    }
    
    if([[stencil title] isEqualToString:@"Label"]){
        [stencil setNeedsDisplay];
    }
    

    [stencil updatePopover];

    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint beginCenter = self.center;
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.superview];
    
    deltaX = touchPoint.x - beginCenter.x;
    deltaY = touchPoint.y - beginCenter.y;
    
    
    UIScrollView* scroll = (UIScrollView*)[self superview];
    
    scroll.scrollEnabled = false;
    
    [stencil hideSelecionDash];
    
    
  
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UIScrollView* scroll = (UIScrollView*)[self superview];
    
    scroll.scrollEnabled = true;
    
    
    [stencil setNeedsDisplay];
    [stencil showSelectionDash];
    
}


@end
