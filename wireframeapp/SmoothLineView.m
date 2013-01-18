//
//  SmoothLineView.m
//  Smooth Line View
//
//  Created by Levi Nunnink on 8/15/11.
//  Copyright 2011 culturezoo. All rights reserved.
//

#import "SmoothLineView.h"
#import "KtViewController.h"
#import <QuartzCore/QuartzCore.h>

#define DEFAULT_COLOR [UIColor blackColor]
#define DEFAULT_WIDTH 3.0f

@interface SmoothLineView () 

#pragma mark Private Helper function

CGPoint midPoint(CGPoint p1, CGPoint p2);

@end

@implementation SmoothLineView

@synthesize controller;
@synthesize curImage;

#pragma mark -

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.lineWidth = DEFAULT_WIDTH;
        self.lineColor = DEFAULT_COLOR;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.lineWidth = DEFAULT_WIDTH;
        self.lineColor = DEFAULT_COLOR;
    }
    return self;
}

#pragma mark Private Helper function

CGPoint midPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    
    previousPoint1 = [touch previousLocationInView:self];
    previousPoint2 = [touch previousLocationInView:self];
    currentPoint = [touch locationInView:self];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    


    UITouch *touch  = [touches anyObject];
    
    previousPoint2  = previousPoint1;
    previousPoint1  = [touch previousLocationInView:self];
    currentPoint    = [touch locationInView:self];
    
    // calculate mid point
    CGPoint mid1    = midPoint(previousPoint1, previousPoint2); 
    CGPoint mid2    = midPoint(currentPoint, previousPoint1);
    
 //   CGPathAddQuadCurveToPoint
    
    if([controller selectedTool] == ERASER) {
        
     /*   CGSize s = curImage.size;
        UIGraphicsBeginImageContext(s);
        CGContextRef g = UIGraphicsGetCurrentContext();
        
        CGMutablePathRef erasePath = CGPathCreateMutable();

        CGPathAddRect(erasePath, NULL, CGRectMake(currentPoint.x, currentPoint.y, 100, 100));
      //  CGPathMoveToPoint(erasePath, NULL, mid1.x, mid1.y);
        CGPathAddQuadCurveToPoint(erasePath, NULL, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y);
        
        CGContextAddPath(g,erasePath);

       // CGCONTEXT
        CGContextEOClip(g);

        
        UIGraphicsEndImageContext();   */
        
       // CGContextRef g = UIGraphicsGetCurrentContext();
       //  
        
        CGSize s = curImage.size;
        UIGraphicsBeginImageContext(s);
        CGContextRef g = UIGraphicsGetCurrentContext();
        CGContextClearRect(g, CGRectMake(currentPoint.x-25, currentPoint.y-25, 50, 50));
        curImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [self setNeedsDisplayInRect:CGRectMake(currentPoint.x-25, currentPoint.y-25, 50, 50)];
     
        
      //  return; 
    }
    
    
    
    
    
 
    
    CGMutablePathRef path = CGPathCreateMutable();
  
 
    CGPathMoveToPoint(path, NULL, mid1.x, mid1.y);
    CGPathAddQuadCurveToPoint(path, NULL, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y); 
    
    
    
    CGRect bounds = CGPathGetBoundingBox(path);
    CGPathRelease(path);
    
    CGRect drawBox = bounds;
    
    //Pad our values so the bounding box respects our line width
    drawBox.origin.x        -= self.lineWidth * 2;
    drawBox.origin.y        -= self.lineWidth * 2;
    drawBox.size.width      += self.lineWidth * 4;
    drawBox.size.height     += self.lineWidth * 4;
    
    
    //if([controller selectedTool] == DRAW) {
        UIGraphicsBeginImageContext(drawBox.size);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        [self setCurImage: UIGraphicsGetImageFromCurrentImageContext()];
        // [curImage retain];
        UIGraphicsEndImageContext();
 /*   } else {
        CGContextRef g = UIGraphicsGetCurrentContext();
       CGContextAddPath(g,path);
        CGContextAddRect(g,drawBox);
        CGContextEOClip(g);
        [curImage drawAtPoint:CGPointZero];
        curImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }*/

    
    [self setNeedsDisplayInRect:drawBox];

    
}

- (void)drawRect:(CGRect)rect
{
  //  
    
        [curImage drawAtPoint:CGPointMake(0, 0)];
            CGPoint mid1 = midPoint(previousPoint1, previousPoint2); 
    CGPoint mid2 = midPoint(currentPoint, previousPoint1);

    CGContextRef context = UIGraphicsGetCurrentContext(); 
    
    //[[self layer] drawInContext:context];

    [self.layer renderInContext:context];
    
     if([controller selectedTool] == DRAW) {

         CGContextMoveToPoint(context, mid1.x, mid1.y);
         // Use QuadCurve is the key
         CGContextAddQuadCurveToPoint(context, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y); 
    
   
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        CGContextStrokePath(context);
    } else {
        
      /*  CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
        CGContextStrokePath(context);
        */
        CGContextClearRect(context, CGRectMake(currentPoint.x-25, currentPoint.y-25, 50, 50));
        

    }
    
    

    [super drawRect:rect];
 //   }
    
//    [curImage release];
    
}

@synthesize lineColor,lineWidth;
@end


