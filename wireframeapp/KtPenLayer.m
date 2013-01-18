//
//  KtPenLayer.m
//  WireframeApp
//
//  Created by [eduardo] on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KtPenLayer.h"
#import "KtViewController.h"
#import "KtStencilView.h"
#import "KtGridView.h"
#import "JPoint.h"

#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@implementation KtPenLayer

@synthesize controller;


CGPoint zmidPoint(CGPoint p1, CGPoint p2);



- (void) initialize
{

    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.delegate = self;
    
    [self addGestureRecognizer:tapGesture];
    
    images = [[NSMutableArray alloc] init];
    currentPoints = [[NSMutableArray alloc] init];
    brushPattern=[UIColor grayColor];
    path= [KtPenLayer createPath];
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

+ (UIBezierPath*) createPath
{
    UIBezierPath *pth;
    pth=[[UIBezierPath alloc]init];
    pth.lineWidth=4;
    pth.miterLimit = 50;
    pth.lineCapStyle = kCGLineCapRound;
    
    pth.flatness = 0.5;
    pth.lineJoinStyle = kCGLineJoinRound;  
    return pth;
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    [controller btnPointerClicked:sender];
}

- (void)drawRect:(CGRect)rect
{
 
//    [brushPattern setStroke];
 //   [path strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
    
    //// General Declarations
    

    
    CGContextRef context = UIGraphicsGetCurrentContext();
    

    CGColorRef shadow = [UIColor blackColor].CGColor;
    CGSize shadowOffset = CGSizeMake(2, 2);
    CGFloat shadowBlurRadius = 5;
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow);
    [[UIColor grayColor] setStroke];
    [path stroke];
    CGContextRestoreGState(context);
 
}

CGPoint zmidPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

#pragma mark - Touch Methods
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
   // UITouch *mytouch=[[touches allObjects] objectAtIndex:0];

    

        UITouch *touch = [touches anyObject];
        
        previousPoint1 = [touch previousLocationInView:self];
        previousPoint2 = [touch previousLocationInView:self];
        currentPoint = [touch locationInView:self];
        

       [path moveToPoint:[touch locationInView:self]];
    
    JPoint* p = [JPoint alloc];
    p.point = currentPoint;
    p.controlPoint = currentPoint;
    [currentPoints addObject:p];

}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch  = [touches anyObject];
    
    previousPoint2  = previousPoint1;
    previousPoint1  = [touch previousLocationInView:self];
    currentPoint    = [touch locationInView:self];
    
    CGPoint mid1    = zmidPoint(previousPoint1, previousPoint2); 
    CGPoint mid2    = zmidPoint(currentPoint, previousPoint1);
    
    
    
    [path addQuadCurveToPoint:mid2 controlPoint:previousPoint1];
    
    JPoint* p = [JPoint alloc];
    p.point = mid2;
    p.controlPoint = previousPoint1;
    [currentPoints addObject:p];

    
    // THIS CODE FINDS THE SPECIFIC REDRAW AREA!!
    CGMutablePathRef draw_path = CGPathCreateMutable();
    CGPathMoveToPoint(draw_path, NULL, mid1.x, mid1.y);
    CGPathAddQuadCurveToPoint(draw_path, NULL, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y); 
    CGRect bounds = CGPathGetBoundingBox(draw_path);
    CGPathRelease(draw_path);
    CGRect drawBox = bounds;
    drawBox.origin.x        -= 5 * 2;
    drawBox.origin.y        -= 5 * 2;
    drawBox.size.width      += 5 * 4;
    drawBox.size.height     += 5 * 4;
    [self setNeedsDisplayInRect:drawBox];
    
    
    
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    CGRect origin = CGPathGetBoundingBox([path CGPath]);
    origin.size.width += 40;
    origin.size.height += 40;
    origin.origin.x -= 27;
    origin.origin.y -= 50;
    
    
    KtStencilView* stencil = [[KtStencilView alloc] initWithFrame:origin ];
    [stencil setPathData:path];
    [stencil setTitle:@"Draw"];
    [stencil setPointData:currentPoints];
    [controller.gridView addSubview:stencil];
    [controller.gridView bringSubviewToFront:controller.penLayer];
    
    path = nil;
    path = [KtPenLayer createPath];
    
    currentPoints = nil;
    currentPoints = [[NSMutableArray alloc] init];
    
    [self setNeedsDisplay];
    
}

@end
