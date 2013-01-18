//
//  UIImage+PDFSupport.h
//
//  Created by Niels Gabel on 1/11/11.
//  Copyright 2011 PlacePop Inc. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.


#import <Foundation/Foundation.h>

// This option adds support for using PDFs in UIImageView's in NIB files.
// (You can specify PDF files for image views and they will load in your app,
// but interface builder won't display them)
// Use this option at your own risk; you could potentially fall afoul
// of Apple's SPI rules, but I think it's unlikely.
#define UIImage_PDFSupport_SupportNIBLoading 0

// n.b.: including this category in your project will patch +[ UIImage imageNamed: ] to also support PDF files automagically, like this:
//
//	UIImage * image = [ UIImage imageNamed:@"test.pdf" ] ;
//

@interface UIImage ( PDFSupport )

// returns an array containing images of the pages in a PDF
+(NSArray*)imagesWithPDFNamed:(NSString*)name scale:(CGFloat)scale ;

// returns an array containing images of the pages in a PDF, scaled by 'transform'
+(NSArray*)imagesWithPDFNamed:(NSString*)name scale:(CGFloat)scale transform:(CGAffineTransform)t ;

// returns an image of the first page in a PDF
+(UIImage*)imageWithPDFNamed:(NSString*)name scale:(CGFloat)scale ;

// returns an image of the first page in a PDF, scaled by 'transform'
+(UIImage*)imageWithPDFNamed:(NSString*)name scale:(CGFloat)scale transform:(CGAffineTransform)t ;

@end
