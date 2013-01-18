//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import "KtBrowserItemView.h"
#import "KtBrowserController.h"
#import "KtBrowserThumb.h"
#import "KtBrowserView.h"
#import "Wireframe.h"
#import "Documents.h"

#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>


@implementation KtBrowserItemView

@synthesize wireframe;
@synthesize label;
@synthesize thumb;
@synthesize selected;
@synthesize browserView;
@synthesize subLabel;
@synthesize labelTap;
@synthesize controller;


-(void) initialize
{
    longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [self addGestureRecognizer: longPress];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer: tap];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner setCenter:self.center]; // I do this because I'm in landscape mode
    [self addSubview:spinner]; // spinner is not visible until started
    
    
    labelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped:)];
    
    UIView* v = [self viewWithTag:666]; 
    

    
    
  //  if ( [[NSFileManager defaultManager] fileExistsAtPath:thumbPath] ) {
  //      v.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:thumbPath]]; 
  //  } else {
        v.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"thumb_v_bg.png"]];
 //   }
    
    
}


-(void) refreshThumb {
    UIView* sview = [self.subviews objectAtIndex:0];
    
    NSString* thumbPath = [[Documents thumbsPath] stringByAppendingPathComponent:[wireframe pngFileName]];
    if ( [[NSFileManager defaultManager] fileExistsAtPath:thumbPath] ) {
        
        sview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:thumbPath]]; 
    } else {
        sview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"thumb_background.png"]];
    }
    
    [thumb setNeedsDisplay];   
}

- (id) init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;   
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

-(void) openWireframe
{
     [self.controller openWireframe:[self wireframe]];
}

- (IBAction)tapped:(id)sender {
    
   switch (self.controller.headerState) {
        case BROWSING:
           [spinner startAnimating];
           
           [self performSelector:@selector(openWireframe) withObject:nil afterDelay:1];
   
            break;
        case EDITING:
            if(selected) {
                [self deselect];
            } else
            {
                [self select];
            }
            break;
            
        default:
            break;
    }
    
}

-(void) select 
{
    [self.browserView deselectAll];
    selected = YES;
    [self setNeedsDisplay];
    [self.thumb setNeedsDisplay];  
    self.controller.currentSelection = self;
}

-(void) deselect
{
    selected = NO;
    [self setNeedsDisplay];
    [self.thumb setNeedsDisplay]; 
    self.controller.currentSelection = nil;
}

- (IBAction)labelTapped:(id)sender {
    [controller rename:self];
}

- (IBAction)longPressed:(id)sender {
    
    [self.browserView.controller btnEditClicked:sender];
    [self select];
}



- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.superview];
    
    // Set the correct center when touched 
    touchPoint.x -= deltaX;
    touchPoint.y -= deltaY;
    
    self.center = touchPoint;
    

    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint beginCenter = self.center;
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.superview];
    
    deltaX = touchPoint.x - beginCenter.x;
    deltaY = touchPoint.y - beginCenter.y;
    
    UIScrollView* scroll = [[self controller] scrollView];
    
    scroll.scrollEnabled = false;
    
    [browserView bringSubviewToFront:self];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [browserView findSize];
    UIScrollView* scroll = [[self controller] scrollView];
    
    scroll.scrollEnabled = true;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    for(UIView* v in browserView.subviews) {
        if([v class] == [KtBrowserItemView class]) {
            KtBrowserItemView* item_v = (KtBrowserItemView*)v;
            
            NSString *x_key = [NSString stringWithFormat:@"%@_X", [item_v.wireframe fileName]];
            NSString *y_key = [NSString stringWithFormat:@"%@_Y", [item_v.wireframe fileName]];
            
            [prefs removeObjectForKey:x_key];
            [prefs removeObjectForKey:y_key];
            
            [prefs setFloat:item_v.frame.origin.x forKey:x_key];
            [prefs setFloat:item_v.frame.origin.y forKey:y_key];
        }
    }

    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation. */
- (void)drawRect:(CGRect)rect
{
    if(selected) {
        if(controller.headerState == EDITING) {
            self.thumb.layer.borderColor = [UIColor redColor].CGColor;
            self.thumb.layer.borderWidth = 3.0f;
        }
    } else {
        self.thumb.layer.borderColor = [UIColor redColor].CGColor;
        self.thumb.layer.borderWidth = 0.0f;
    }
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.8f;
    self.layer.shadowOffset = CGSizeMake(0.0f, 4.0f);
    self.layer.shadowRadius = 4.5f;
    self.layer.masksToBounds = NO;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.shadowPath = path.CGPath;

}


@end
