#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class KtStencilView;

@interface KtPdfRenderer : NSObject

+ (void) render:(KtStencilView*)view withRectAndPdf: (CGRect) rect: (NSString*) pdfFilename;

@end
