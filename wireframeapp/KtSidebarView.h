//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KtViewController;

@interface KtSidebarView : UIView

@property (weak) KtViewController *controller;

- (void) hide;
- (void) initialize;


@end
