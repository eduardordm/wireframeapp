//
//  KtPopoverView.m
//  WireframeApp
//
//  Created by [eduardo] on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KtPopoverView.h"


#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>


@implementation KtPopoverView

@synthesize stencil;



- (void) initialize
{
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"new_component_bg2.png"]];
    
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




- (void)drawRect:(CGRect)rect
{
  /* self.layer.shadowColor = [UIColor blackColor].CGColor;
    
    self.layer.shadowOpacity = 0.6f;
    self.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);
    self.layer.shadowRadius = 2.0f;
    self.layer.cornerRadius = 8.0f;
    self.layer.masksToBounds = YES;

    
    
    [self.layer setCornerRadius:8.0f];
    

    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.4f;
    self.layer.shadowOffset = CGSizeMake(4.0f, 4.0f);
    self.layer.shadowRadius = 1.5f;
 //   self.layer.masksToBounds = NO;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.shadowPath = path.CGPath;

    
 //   [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
 //   [self.layer setBorderWidth:1.5f];*/
  
}


- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.superview];
    
    // Set the correct center when touched 
    touchPoint.x -= deltaX;
    touchPoint.y -= deltaY;
    
    self.center = touchPoint;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint beginCenter = self.center;
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.superview];
    
    deltaX = touchPoint.x - beginCenter.x;
    deltaY = touchPoint.y - beginCenter.y;
    
    
  //  UIScrollView* scroll = [[self superview] superview];
    
 //   scroll.scrollEnabled = false;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  //  UIScrollView* scroll = [[self superview] superview];
    
  //  scroll.scrollEnabled = true;
}

@end
