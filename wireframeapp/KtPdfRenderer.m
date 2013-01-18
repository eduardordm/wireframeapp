#import "KtPdfRenderer.h"

@implementation KtPdfRenderer

+ (void) render:(KtStencilView*)view withRectAndPdf: (CGRect) rect: (NSString*) pdfFilename
{
    //[[UIColor whiteColor] set];
	//CGContextFillRect(context, rect);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
	// Flip coordinates
	CGContextGetCTM(context);
	CGContextScaleCTM(context, 1, -1);
	CGContextTranslateCTM(context, 0, -rect.size.height);
    
	// url is a file URL
    CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), (__bridge CFStringRef)pdfFilename, NULL, NULL);
	CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
	CGPDFPageRef page1 = CGPDFDocumentGetPage(pdf, 1);
    
	// get the rectangle of the cropped inside
	CGRect mediaRect = CGPDFPageGetBoxRect(page1, kCGPDFCropBox);
	CGContextScaleCTM(context, rect.size.width / mediaRect.size.width,
                      rect.size.height / mediaRect.size.height);
	CGContextTranslateCTM(context, -mediaRect.origin.x, -mediaRect.origin.y);
    
	// draw it
	CGContextDrawPDFPage(context, page1);
	CGPDFDocumentRelease(pdf);
}

@end
