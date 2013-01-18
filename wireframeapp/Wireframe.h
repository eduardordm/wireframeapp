//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KtGridView;

@interface Wireframe : NSObject {
    NSString* name;
    NSDate* timestamp;    
    BOOL loaded;
    NSMutableArray* stencils;
    NSString* originalFilename;
    KtGridView* gridView;
    
}

- (id)initWithGrid:(KtGridView*)grid;
- (id)initWithName:(NSString*)s;
- (void)initialize;


- (void) renameFile:(NSString*)newName;
- (BOOL)createNewFile;
- (BOOL)mergeExistingFile;
- (BOOL)loadFromFile;
- (void) deleteFile;

- (NSString*) fileName;
- (NSString*) pdfFileName;
- (NSString*) filePath;
- (NSString*) pdfFilePath;
- (NSString*) pngFileName;
- (NSString*) originalFilePath;

- (NSString*)toJson;

@property (retain, nonatomic) NSString* name;
@property (retain, nonatomic) NSDate* timestamp;
@property BOOL loaded;
@property (retain, nonatomic) NSMutableArray* stencils;
@property (retain, nonatomic) KtGridView* gridView;





@end
