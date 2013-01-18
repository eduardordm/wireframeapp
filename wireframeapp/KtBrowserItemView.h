//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Wireframe;
@class KtBrowserThumb;
@class KtBrowserController;
@class KtBrowserView;

@interface KtBrowserItemView : UIView {
    Wireframe* wireframe;
    BOOL selected;
    UILongPressGestureRecognizer* longPress;
    UITapGestureRecognizer* tap;
    UIActivityIndicatorView *spinner;
    
    UITapGestureRecognizer *labelTap;
    
    @private float deltaX;
    @private float deltaY;
}

@property (readwrite) BOOL selected;

@property (nonatomic, retain) Wireframe* wireframe;

@property (retain, nonatomic) KtBrowserView* browserView;

@property (weak, nonatomic) IBOutlet UILabel *subLabel;

@property (weak, nonatomic) IBOutlet UILabel *label;


@property (weak, nonatomic) IBOutlet KtBrowserThumb *thumb;

@property (weak, nonatomic) KtBrowserController *controller;

@property (retain, nonatomic) UITapGestureRecognizer *labelTap;

-(void) refreshThumb;
-(void) openWireframe;

-(void) initialize;
-(void) select;
-(void) deselect;

- (IBAction)longPressed:(id)sender;
- (IBAction)tapped:(id)sender;
- (IBAction)labelTapped:(id)sender;

@end
