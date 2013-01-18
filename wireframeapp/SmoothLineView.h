//
//  SmoothLineView.h
//  Smooth Line View
//
//  Created by Levi Nunnink on 8/15/11.
//  Copyright 2011 culturezoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KtViewController;


@interface SmoothLineView : UIView {
    @private
    CGPoint currentPoint;
    CGPoint previousPoint1;
    CGPoint previousPoint2;
    CGFloat lineWidth;
    UIColor *lineColor;
    UIImage *curImage;

}
@property (nonatomic, retain) UIColor *lineColor;
@property (readwrite) CGFloat lineWidth;

@property (retain, nonatomic) KtViewController* controller;

@property (retain, nonatomic) UIImage *curImage;

@end
