//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KtStencilView;

@interface KtMoveButtonView : UIView {
    @private float deltaX;
    @private float deltaY;
    
    KtStencilView* stencil;
}

- (void) initialize;

@property (retain, nonatomic) KtStencilView* stencil;

@end
