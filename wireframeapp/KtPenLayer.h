//
//  KtPenLayer.h
//  WireframeApp
//
//  Created by [eduardo] on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KtViewController;

@interface KtPenLayer : UIView <UIGestureRecognizerDelegate> {
    UIBezierPath *path;
    UIColor *brushPattern;
    UIImage *image;
    
    
    CGPoint currentPoint;
    CGPoint previousPoint1;
    CGPoint previousPoint2;
    
    NSMutableArray* images;
    NSMutableArray* currentPoints;
    
    UITapGestureRecognizer* tapGesture;

}


+ (UIBezierPath*) createPath;


@property (retain, nonatomic) KtViewController* controller;

- (void)handleTap:(UITapGestureRecognizer *)sender;

- (void) initialize;

@end
