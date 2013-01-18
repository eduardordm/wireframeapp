

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class KtStencilView;

@interface KtWindowRenderer : NSObject


+ (void) render:(KtStencilView*)view withRect: (CGRect) rect;

@end
