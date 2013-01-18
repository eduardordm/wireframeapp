//
//  KtBoxRenderer.h
//  WireframeApp
//
//  Created by Eduardo Mourao on 11/28/12.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class KtStencilView;

@interface KtBoxRenderer : NSObject

+ (void) render:(KtStencilView*)view withRect: (CGRect) rect;

@end
