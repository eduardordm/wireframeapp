//
//  KtArrowRenderer.h
//  WireframeApp
//
//  Created by [eduardo] on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KtStencilView;

@interface KtArrowRenderer : NSObject

+ (void) render:(KtStencilView*)view withRect: (CGRect) rect;

@end
