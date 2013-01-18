//
//  KtBoxRenderer.m
//  WireframeApp
//
//  Created by Eduardo Mourao on 11/28/12.
//
//

#import "KtBoxRenderer.h"

#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>


@implementation KtBoxRenderer


+ (void) render:(KtStencilView*)view withRect: (CGRect) rect
{
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: rect];
    [[UIColor blackColor] setStroke];
    rectanglePath.lineWidth = 2;
    [rectanglePath stroke];
}

@end
