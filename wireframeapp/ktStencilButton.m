//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import "ktStencilButton.h"
#import "KtStencilView.h"
#import "KtGridView.h"

@implementation KtStencilButton

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


- (void) initialize
{
    [self setClipsToBounds:false];
    [self buildButton];
    [self setFrame:CGRectMake(0, 0, 30, 30)];
    [self setBackgroundColor:[UIColor blackColor]];
}


- (void) buildButton
{
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(0, 0, 30, 30);
    btn.backgroundColor = [UIColor blackColor];
    btn.alpha = 1.0;
    [btn setImage:[UIImage imageNamed:@"256Px - 059.png"] forState:UIControlStateNormal];
    //   [btnMove addTarget:self action:@selector(btnMoveClick:)forControlEvents:UIControlEvent];
    
    // [btn addTarget:self action:@selector(draggedOut:withEvent: ) forControlEvents: UIControlEventTouchDragOutside | UIControlEventTouchDragInside];
    
    btn.center = self.center;
 //   [self addSubview:btn];
    
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    KtStencilView* v = (KtStencilView*)[self superview];
    // KtGridView* grid = (KtGridView*)[v superview];
    // UIScrollView* scroll = (UIScrollView*)[grid superview];
    
    [v touchesMoved:touches withEvent:event];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    KtStencilView* v = (KtStencilView*)[self superview];
    KtGridView* grid = (KtGridView*)[v superview];
    UIScrollView* scroll = (UIScrollView*)[grid superview];
    
    scroll.directionalLockEnabled = TRUE;
    [v touchesBegan:touches withEvent:event];
    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    KtStencilView* v = (KtStencilView*)[self superview];
    KtGridView* grid = (KtGridView*)[v superview];
    UIScrollView* scroll = (UIScrollView*)[grid superview];
    
    scroll.directionalLockEnabled = FALSE; 
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
