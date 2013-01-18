//
//  KtDrawRenderer.m
//  WireframeApp
//
//  Created by [eduardo] on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KtDrawRenderer.h"
#import "KtStencilView.h"

#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@implementation KtDrawRenderer


+ (void) render:(KtStencilView*)view withRect: (CGRect) rect {
  //  UIImage *img = view.imgData;
  //  [img drawInRect:rect];
    
    UIBezierPath* path = view.pathData;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSLog(@"DIFERENCE x    %f   %f", rect.size.width,  path.bounds.size.width);
    
    CGFloat x_s = rect.size.width / (path.bounds.size.width+40);
    CGFloat y_s = rect.size.height / (path.bounds.size.height+40);
    
    [view setX_s:x_s];
    [view setY_s:y_s];
    
    [path applyTransform:CGAffineTransformMakeScale(x_s, y_s)];
    
    
    [path applyTransform:CGAffineTransformMakeTranslation(-path.bounds.origin.x+20, -path.bounds.origin.y+20)];
    

    
    CGColorRef shadow = [UIColor blackColor].CGColor;
    CGSize shadowOffset = CGSizeMake(2, 2);
    CGFloat shadowBlurRadius = 5;
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow);
    [[UIColor grayColor] setStroke];
    [path stroke];
    CGContextRestoreGState(context);
}




@end
