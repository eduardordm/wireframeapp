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
    
    
    [[UIColor lightGrayColor] setFill];
    [rectanglePath fill];

}

@end
