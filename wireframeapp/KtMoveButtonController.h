//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KtStencilView;

@interface KtMoveButtonController : UIViewController {
    KtStencilView* stencil;
}

@property (retain, nonatomic) KtStencilView* stencil;

- (IBAction)btnClicked:(id)sender;

@end
