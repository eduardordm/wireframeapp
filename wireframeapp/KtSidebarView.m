//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import "KtSidebarView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>


@implementation KtSidebarView

@synthesize controller;




- (void) initialize
{
    [self setAutoresizingMask:UIViewAutoresizingNone];
    
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"new_toolbar.png"]];
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

- (void) hide 
{

    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect
{
    NSLog(@"Sideview draw");
 /*   self.layer.shadowColor = [UIColor blackColor].CGColor;
    
    self.layer.shadowOpacity = 0.6f;
    self.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);
    self.layer.shadowRadius = 2.0f;*/
   /*   self.layer.cornerRadius = 8.0f;
    self.layer.masksToBounds = YES;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.shadowPath = path.CGPath;

    
    [self.layer setCornerRadius:8.0f];
    [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.layer setBorderWidth:1.5f];
  [self.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.layer setShadowOpacity:0.8];
    [self.layer setShadowRadius:3.0];
    [self.layer setShadowOffset:CGSizeMake(2.0, 2.0)];*/
    
}


@end
