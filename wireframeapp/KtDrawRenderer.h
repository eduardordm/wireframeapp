//
//  KtDrawRenderer.h
//  WireframeApp
//
//  Created by [eduardo] on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KtStencilView;


@interface KtDrawRenderer : NSObject

+ (void) render:(KtStencilView*)view withRect: (CGRect) rect;

@end
