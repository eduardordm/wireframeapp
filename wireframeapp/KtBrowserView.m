//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import "KtBrowserView.h"
#import "Wireframe.h"
#import "KtBrowserItemView.h"
#import "KtBrowserController.h"
#import "KtBrowserInfoPanel.h"


#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>


@implementation KtBrowserView

@synthesize wireframes;
@synthesize views;
@synthesize controller;
//@synthesize infoPanel;

- (void) initialize
{
   
 //    infoPanelController = [[KtBrowserInfoPanelController alloc] initWithNibName:@"KtBrowserInfoPanel" bundle:nil];
    
    
  //  self.infoPanel = infoPanelController.view;
    
  //   [self addSubview:self.infoPanel ];
    

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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



- (CGRect) buildItemRect: (int)line : (int)column : (KtBrowserItemView*)v_view;
{
    float width = 200;
    float height = 200;
    float border = 42;
   /* 
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    for(UIView* v in self.subviews) {
        if([v class] == [KtBrowserItemView class]) {
            KtBrowserItemView* item_v = v;
            
            NSString *x_key = [NSString stringWithFormat:@"%@_X", [item_v.wireframe fileName]];
            NSString *y_key = [NSString stringWithFormat:@"%@_Y", [item_v.wireframe fileName]];
            
            [prefs removeObjectForKey:x_key];
            [prefs removeObjectForKey:y_key];
            
            [prefs setFloat:item_v.frame.origin.x forKey:x_key];
            [prefs setFloat:item_v.frame.origin.y forKey:y_key];
        }
    }*/
  
        return CGRectMake(
                          (column * (width + border)) + border , 
                          line * (height + border) + border, 
                          width, height); 


}

- (void) deselectAll
{
    if(self.subviews != nil) {
    for (UIView* v in self.subviews)
    {
        if ([v isKindOfClass:[KtBrowserItemView class]])
        {
            KtBrowserItemView *t = (KtBrowserItemView *)v;
            [t deselect];
        }
        
    }
    }
}



- (void) refreshPositions
{
    int line = 0;
    int column = 0;  
    float column_count = self.controller.scrollView.bounds.size.width/ 240;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if([prefs dataForKey:@"auto_organize"] == nil ) {
            [prefs setBool:TRUE forKey:@"auto_organize"];
    }
    
    BOOL auto_organize = [prefs boolForKey:@"auto_organize"];
    
    for(UIView* uiitem in self.subviews) 
    {
        if([uiitem  class] == [KtBrowserItemView class]) {
            KtBrowserItemView* item = (KtBrowserItemView*)uiitem;
            CGRect r = [self buildItemRect:line :column :item];
            
            if(!auto_organize) {
                NSString *x_key = [NSString stringWithFormat:@"%@_X", [item.wireframe fileName]];
                NSString *y_key = [NSString stringWithFormat:@"%@_Y", [item.wireframe fileName]];
                
                CGFloat x = [prefs floatForKey:x_key];
                CGFloat y = [prefs floatForKey:y_key];
                
                r = CGRectMake(x, y, r.size.width, r.size.height);
                                
            }
        
            [UIView animateWithDuration:KT_ANIMATION_DURATION animations:^{
                [item setFrame:r];
                [item setTransform:CGAffineTransformMakeRotation(4*M_PI)];
  
            }];  
        
            column++;
            if (column >= column_count-1) {
                line++;
                column = 0;
            }
        }
    }
    CGRect r = CGRectMake(self.frame.origin.x, self.frame.origin.y, 
                          line+1 * (200+30), line * 500);
    
    
   /* if (self.controller.scrollView.bounds.size.width < 1000) {
        CGRect infoR =  CGRectMake( 0, 0, 768, 200); 
     //   [self.infoPanel setFrame:infoR];
    }
    else {
        CGRect infoR =  CGRectMake( 0, 0, 250, 768); 
    //    [self.infoPanel setFrame:infoR];
    }*/

 //   [self.infoPanel setNeedsDisplay];
    [self.controller.scrollView setContentSize:r.size];
    [self.controller.scrollView setNeedsDisplay];
    [self setNeedsDisplay];
    
}

- (void) rebuildViews
{
    if (wireframes == nil) {
        [NSException raise:@"No wireframes" format:@"wireframes are invalid"];
        return;
    }
    
    if(views == nil) {
        views = [[NSMutableArray alloc] initWithCapacity:wireframes.count]; // count wont matter
    } else {
        for(KtBrowserItemView* v in self.views) {
            [v removeFromSuperview];
        }
        [views removeAllObjects];
    }
    
    for(Wireframe* w in self.wireframes ) {

        KtBrowserItemView* item = [[[NSBundle mainBundle] loadNibNamed:@"KtBrowserItem" owner:self options:nil] objectAtIndex:0];
        
        NSDate *date = w.timestamp;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        NSString *dateString = [dateFormatter stringFromDate:date];
        
        [item setController:self.controller];
        [item setBrowserView:self];
        [item.label setText:w.name];
        [item.subLabel setText:dateString];
        [item setWireframe:w];
        [self addSubview:item];
        [views addObject:item];   
        
        [item refreshThumb];

        [[item viewWithTag:666] addGestureRecognizer:item.labelTap]; // FUCKED
        
    

        
     
    }
    [self refreshPositions];
    
}

- (void) findSize
{
    float add_x = 240;
    float add_y = 240;
    float max_x = 0;
    float max_y = 0;
    for(UIView* v in self.subviews) {
        float cur_x = v.frame.origin.x;
        float cur_y = v.frame.origin.y;
        if(cur_x > max_x) {
            max_x = cur_x;
        }
        if(cur_y > max_y) {
            max_y = cur_y;
        }
    }
    
    CGRect r = CGRectMake(0, 0, max_x+add_x, max_y+add_y);
    [self setFrame:r];
    [self setNeedsDisplay];
}

-(void)shakeGallery:(id)sender
{
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
   // [anim setToValue:[NSNumber numberWithFloat:0.0f]];
    [anim setToValue:[NSNumber numberWithDouble:-M_PI/84]];
    [anim setFromValue:[NSNumber numberWithDouble:M_PI/84]];
    [anim setDuration:0.1];
    [anim setRepeatCount:NSUIntegerMax];
    [anim setAutoreverses:YES];
    for (UIView* v in self.subviews)
    {
        if ([v isKindOfClass:[KtBrowserItemView class]])
        {
            [v.layer addAnimation:anim forKey:@"SpringboardShake"];
        }
        
    }
}

- (void)unshakeGallery:(id)sender
{
    for (UIView* v in self.subviews)
    {
        if ([v isKindOfClass:[KtBrowserItemView class]])
        {
            [v.layer removeAnimationForKey:@"SpringboardShake"];
        }
        
    } 
}

@end
