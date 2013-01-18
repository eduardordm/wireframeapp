//
//  KtPopoverView.h
//  WireframeApp
//
//  Created by [eduardo] on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KtStencilView;

@interface KtPopoverView : UIView {
    @private float deltaX;
    @private float deltaY;
    KtStencilView* stencil;
}

@property (retain, nonatomic) KtStencilView* stencil;

- (void) initialize;



@end
