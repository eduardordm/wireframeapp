//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KtViewController;

@interface KtGridView : UIView <UIGestureRecognizerDelegate>  {
    BOOL shouldDrawGrid;
    BOOL shouldSnapToGrid;
    CGFloat gridSize;
    
    CGColorRef lightColor;
    CGColorRef darkColor; 
    UITapGestureRecognizer* tapGesture;
    UITapGestureRecognizer* doubleTapGesture;
}

@property (weak) KtViewController *controller;
@property (readwrite) BOOL shouldDrawGrid;
@property (readwrite) BOOL shouldSnapToGrid;
@property (readwrite) CGFloat gridSize;

- (UIImage*)image;
- (NSData*)pngImage;
- (NSData*)pdfImage;
- (void)saveThumb:(NSString*)fname;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withImage:(UIImage *)sourceImage;

- (CGRect) usedBounds;

- (void) prepareToSave;

- (void)initialize;

- (void)toggleGrid;
- (void)initColors;
- (void)drawGrid:(CGRect)rect;

- (void)deselectAll;

- (void)handleTap:(UITapGestureRecognizer *)sender;
- (void)handleDoubleTap:(UITapGestureRecognizer *)sender;

@end
