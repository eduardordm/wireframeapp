//
//  KtLabelRenderer.h
//  WireframeApp
//
//  Created by [eduardo] on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KtStencilView;

@interface KtLabelRenderer : NSObject

+ (void) render:(KtStencilView*)view withRect: (CGRect) rect;

@end
