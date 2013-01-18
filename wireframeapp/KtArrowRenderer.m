//
//  KtArrowRenderer.m
//  WireframeApp
//
//  Created by [eduardo] on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KtArrowRenderer.h"

@implementation KtArrowRenderer


+ (void) render:(KtStencilView*)view withRect: (CGRect) rect
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Shadow Declarations
    CGColorRef shadow = [UIColor lightGrayColor].CGColor;
    CGSize shadowOffset = CGSizeMake(2, 2);
    CGFloat shadowBlurRadius = 3;
    
    
    //// Polygon 2 Drawing
    UIBezierPath* polygon2Path = [UIBezierPath bezierPath];
    [polygon2Path moveToPoint: CGPointMake(124.33, -0)];
    [polygon2Path addLineToPoint: CGPointMake(129.26, 7.31)];
    [polygon2Path addLineToPoint: CGPointMake(0, 11.47)];
    [polygon2Path addLineToPoint: CGPointMake(129.26, 13.69)];
    [polygon2Path addLineToPoint: CGPointMake(124.33, 20)];
    [polygon2Path addLineToPoint: CGPointMake(140, 10.49)];
    [polygon2Path addLineToPoint: CGPointMake(124.33, -0)];
    [polygon2Path closePath];
    
    
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow);
    [[UIColor blackColor] setFill];
    [polygon2Path fill];
    CGContextRestoreGState(context);
    
    [[UIColor whiteColor] setStroke];
    polygon2Path.lineWidth = 1;
    [polygon2Path stroke];
}

@end
