//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import "KtGridView.h"
#import "KtStencilView.h"
#import "KtViewController.h"
#import "KtSidebarViewCell.h"
#import "Documents.h"
#import "Wireframe.h"
#import "KtPopoverController.h"
#import "KtPopoverView.h"
#import "UIPlaceHolderTextView.h"
 
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>


@implementation KtGridView

@synthesize controller;
@synthesize shouldDrawGrid;
@synthesize shouldSnapToGrid;
@synthesize gridSize;

- (void) initialize
{
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if([prefs objectForKey:@"display_grid"] == nil) {
        [prefs setBool:TRUE forKey:@"display_grid"];
    }
    if([prefs objectForKey:@"snap_grid"] == nil) {
        [prefs setBool:FALSE forKey:@"snap_grid"];
    }    
    if([prefs objectForKey:@"grid_size"] == nil) {
        [prefs setFloat:8.0 forKey:@"grid_size"];
    }   
    
    [prefs synchronize];
    
    shouldDrawGrid = [prefs boolForKey:@"display_grid"];
    shouldSnapToGrid = [prefs boolForKey:@"snap_grid"];
    gridSize = [prefs floatForKey:@"grid_size"];
    
    
    [self initColors];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.delegate = self;
    [tapGesture setNumberOfTapsRequired:1];
    [self addGestureRecognizer:tapGesture];    
    
    
    doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapGesture.delegate = self;
    [doubleTapGesture setNumberOfTapsRequired:2];
    [self addGestureRecognizer:doubleTapGesture];    
    
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grid_bg.png"]];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (id) init 
{
    self = [super init];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;  
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (NSData*)pdfImage
{
    [self prepareToSave];
    
    // Creates a mutable data object for updating with binary data, like a byte array
    NSMutableData *pdfData = [NSMutableData data];
    
    // Points the pdf converter to the mutable data object and to the UIView to be converted
    UIGraphicsBeginPDFContextToData(pdfData, self.usedBounds, nil);
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    
    // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
    
    [self.layer renderInContext:pdfContext];
    
    // remove PDF rendering context
    UIGraphicsEndPDFContext();
    
    return pdfData;
}
//- (void) draggedOut: (UIControl *) c withEvent: (UIEvent *) ev;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withImage:(UIImage *)sourceImage 
{

    UIImage *newImage = nil;        
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) 
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) 
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
        }
        else 
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }       
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) 
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)saveThumb:(NSString*)fname;
{
    [self prepareToSave];
    UIImage *image = [self imageByScalingAndCroppingForSize:CGSizeMake(200, 200) withImage:self.image];
    
    NSData * data = UIImagePNGRepresentation(image);
    
    NSString* fz =  [NSString stringWithFormat:@"%@.png", fname]; 
    
    [data writeToFile:[[Documents thumbsPath] stringByAppendingPathComponent:fz] atomically:true]; 
    
    image = NULL;
    
}

- (NSData*)pngImage
{
    [self prepareToSave];
    UIImage *image = self.image;
    NSData * data = UIImagePNGRepresentation(image);
    image = NULL;
    return data;
}

- (UIImage *)image {
   
    CGSize imageSize = self.usedBounds.size;
    
    UIGraphicsBeginImageContext(imageSize);
    

    
    CGContextRef imageContext = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(imageContext, 0.0, 0);
    CGContextScaleCTM(imageContext, 1.0, 1.0);
    

    
    //for (CALayer* layer in self.layer.sublayers) {
    //  [layer renderInContext: imageContext];
    //}
    
    [self.layer renderInContext: imageContext];
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return viewImage;
}


- (void) prepareToSave {
    [self deselectAll];
    [self setShouldDrawGrid:false];
    [self toggleGrid];
    
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)sender
{
  //  [self deselectAll];
   // CGPoint p = [sender locationInView:self];
    UIScrollView *scroll = (UIScrollView *)[super superview];
     [scroll setZoomScale:1.0f animated:TRUE];
    
}

- (void)handleTap:(UITapGestureRecognizer *)sender 
{
    [self deselectAll];
    CGPoint p = [sender locationInView:self];
    
    if([[[self controller] table] indexPathForSelectedRow] != NULL) {
        NSIndexPath *indexPath = [[[self controller] table] indexPathForSelectedRow] ;
        
        KtSidebarViewCell *viewCell=  (KtSidebarViewCell*)[[[self controller].sidebarModel cells] objectAtIndex:indexPath.row];
        
        KtStencilView* stencilView = [[KtStencilView alloc]
                                        initWithFrame:CGRectMake(p.x, p.y,
                                                                 viewCell.fwidth.intValue,
                                                                 viewCell.fheight.intValue)];
       
        [stencilView setTitle:viewCell.title];
        
        [self addSubview:stencilView];
        
        [[[self controller] table] deselectRowAtIndexPath:indexPath animated:TRUE];
        
    }
    
    if(controller.selectedTool == ARROW) {
        KtStencilView* stencilView = [[KtStencilView alloc] initWithFrame:CGRectMake(p.x, p.y, 140, 20)];
        [stencilView setTitle:@"Arrow"];
        
        [self addSubview:stencilView];
        
        controller.selectedTool = POINTER;
        controller.gridScroll.scrollEnabled = true;
        [controller refreshToolIcons];  
    }
    
    if(controller.selectedTool == LABEL) {
        KtStencilView* stencilView = [[KtStencilView alloc] initWithFrame:CGRectMake(p.x, p.y, 140, 20)];
        [stencilView setTitle:@"Label"];
        
        [self addSubview:stencilView];
        
        controller.selectedTool = POINTER;
        controller.gridScroll.scrollEnabled = true;
        [controller refreshToolIcons];  
        [stencilView select:TRUE];
        [stencilView.popover.txtData becomeFirstResponder];
    }
    
    
    [self bringSubviewToFront:(UIView*)[controller penLayer]];
}

- (CGRect) usedBounds
{
    CGFloat max_x = 100.0f;
    CGFloat max_y = 100.0f;
    for(UIView* item in self.subviews) 
    {
        if([item  class] == [KtStencilView class]) {
            if((item.frame.origin.x + item.frame.size.width) > max_x) {
                max_x = item.frame.origin.x + item.frame.size.width;
            }
            if((item.frame.origin.y + item.frame.size.height) > max_y) {
                max_y = item.frame.origin.y + item.frame.size.height;
            }
        }
    }
    
    return CGRectMake(0, 0, max_x+20, max_y+20);
}


- (void)deselectAll
{
    UIScrollView *scroll = (UIScrollView *)[super superview];
    //[scroll setDelaysContentTouches:TRUe];
   // [
    for(UIView* item in self.subviews) 
    {
        if([item  class] == [KtStencilView class]) {
        
            KtStencilView* kt = (KtStencilView *)item;
            if([kt selected]) {
                [kt select:FALSE];
            }
        }
    }
    scroll.scrollEnabled = true;
    
    [self setNeedsDisplay];
}


- (void)toggleGrid
{
    if(shouldDrawGrid) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grid_bg.png"]];
    }
    else {
        self.backgroundColor = [UIColor whiteColor];
    }
    [self setNeedsDisplay];
}


- (void) initColors
{
#ifndef __clang_analyzer__
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat lightColorComponents[] = {230/255,240/255,255/255,0.5};
    CGFloat darkColorComponents[] = {196/255,221/255,255/255,1.0};
    
    lightColor = CGColorCreate(colorspace, lightColorComponents);
    darkColor = CGColorCreate(colorspace, darkColorComponents);
    
    colorspace = nil;
#endif 
    
}

- (void)drawGrid:(CGRect)rect
{
    NSLog(@"drawGrid");
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGRect frameRect = [self bounds];
    
    float cell_size = 10;
    int number_of_rows = frameRect.size.height / cell_size;
    int number_of_cols = frameRect.size.width / cell_size;
    
    CGContextSetLineWidth(context, 0.1);
    
    CGContextSetStrokeColorWithColor(context, lightColor); 
    for(int i = 0; i < number_of_cols+1; i++ ) {
        CGContextMoveToPoint(context, cell_size * i , 0.0f);
        CGContextAddLineToPoint(context, cell_size * i, frameRect.size.height);
    }
    
    for(int i = 0; i < number_of_rows+1; i++ ) {
        CGContextMoveToPoint(context, 0.0f, cell_size * i);
        CGContextAddLineToPoint(context, frameRect.size.width, cell_size * i);  
    }    
    CGContextStrokePath(context);
    
    
    CGContextSetStrokeColorWithColor(context, darkColor);
    for(int i = 0; i < number_of_cols+1; i+=10) {
        CGContextMoveToPoint(context, cell_size * i , 0.0f);
        CGContextAddLineToPoint(context, cell_size * i, frameRect.size.height);
    }
    for(int i = 0; i < number_of_rows+1; i+=10 ) {
        CGContextMoveToPoint(context, 0.0f, cell_size * i);
        CGContextAddLineToPoint(context, frameRect.size.width, cell_size * i);  
    } 
    CGContextStrokePath(context);
    
}



- (void)drawRect:(CGRect)rect
{
   // if (shouldDrawGrid == YES ) {
   //     [self drawGrid:rect];
   // }
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.7f;
    self.layer.shadowOffset = CGSizeMake(-10.0f, 0.0f);
    self.layer.shadowRadius = 5.0f;
    self.layer.masksToBounds = NO;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.shadowPath = path.CGPath;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}


@end
