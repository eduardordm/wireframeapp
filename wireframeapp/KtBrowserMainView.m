//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//
#import "KtBrowserMainView.h"

@implementation KtBrowserMainView

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //// Color Declarations
    UIColor* gradient4Color = [UIColor colorWithRed: 0.522 green: 0.525 blue: 0.522 alpha: 1];
    UIColor* gradient1Color = [UIColor colorWithRed: 0.01 green: 0.01 blue: 0.01 alpha: 1];
    
    //// Gradient Declarations
    NSArray* gradientBasicoColors = [NSArray arrayWithObjects:
                                     (id)gradient4Color.CGColor,
                                     (id)gradient1Color.CGColor, nil];
    CGFloat gradientBasicoLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)CFBridgingRetain(gradientBasicoColors), gradientBasicoLocations);
    
    
    CGContextDrawLinearGradient(context,
                                gradient,
                                CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds)),
                                CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds)),
                                0);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRestoreGState(context);
}


@end
