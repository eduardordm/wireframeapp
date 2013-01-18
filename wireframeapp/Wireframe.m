//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import "Wireframe.h"
#import "Documents.h"
#import "JWireframe.h"
#import "JStencil.h"
#import "SBJson.h"
#import "KtStencilView.h"
#import "KtGridView.h"
#import  "KtPenLayer.h"
#import "JPoint.h"

@implementation Wireframe
@synthesize name;
@synthesize timestamp;
@synthesize stencils;
@synthesize loaded;
@synthesize gridView;


- (id)initWithGrid:(KtGridView*)grid // new file
{
    self = [super init];
    if (self) {
        [self setGridView:grid];
        [self initialize];
        [self createNewFile];
    }
    return self;
}

- (id)initWithName:(NSString*)s
{
    self = [super init];
    if (self) {
        [self initialize];
        originalFilename = s;
        self.name = [s stringByReplacingOccurrencesOfString:KT_FILE_EXTENSION
                                                         withString:@""];
        
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[self filePath] error:nil];
        
        NSDate* d = [fileAttributes objectForKey:NSFileModificationDate];
        self.timestamp = d;
    }
    return self;
}

- (void)initialize {
    self.stencils = [[NSMutableArray alloc] init];
    self.name = KT_DEFAULT_NAME;
    self.timestamp = [NSDate date];
    self.loaded = NO;
}

- (NSString*)toJson
{
    
    
    JWireframe* jwire = [[JWireframe alloc] init];
    jwire.version = @"1.0";
    jwire.stencils = [[NSMutableArray alloc] init];
    
    for(UIView* v in gridView.subviews) 
    {
        if([v class] == [KtStencilView class]) {
            KtStencilView* stencil = (KtStencilView*)v;
            JStencil* jstencil = [[JStencil alloc] init];
            jstencil.x = [[NSNumber alloc] initWithFloat:stencil.frame.origin.x];
            jstencil.y = [[NSNumber alloc] initWithFloat:stencil.frame.origin.y];
            jstencil.width = [[NSNumber alloc] initWithFloat:stencil.frame.size.width];
            jstencil.height = [[NSNumber alloc] initWithInt:stencil.frame.size.height];
            jstencil.title = stencil.title;
            jstencil.data = stencil.data;
            jstencil.points = stencil.pointData;
            [jwire.stencils addObject:jstencil];
            
        }
    }
    
    
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    
   // NSLog([writer stringWithObject:jwire.toJson]);
    
    return [writer stringWithObject:jwire.toJson];
    
}


- (BOOL)mergeExistingFile 
{
    
    NSFileHandle* fileWriter = [NSFileHandle fileHandleForWritingAtPath:[self filePath]];
    
    [fileWriter truncateFileAtOffset:0];
    [fileWriter writeData:[[self toJson] dataUsingEncoding:NSUTF8StringEncoding]];
    [fileWriter closeFile];
    
    return TRUE; // FUCKED
}


- (BOOL)createNewFile {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\s\\(\\d\\)"
                                              options:NSRegularExpressionCaseInsensitive
                                                error:NULL];
    
    int count = 1;
    while ( [[NSFileManager defaultManager] fileExistsAtPath:[self filePath]] ) {
         NSString* str = [regex stringByReplacingMatchesInString:self.name
                                                         options:0 
                                                           range:NSMakeRange(0, [self.name length]) 
                                                    withTemplate:@""];
        
        [self setName:[NSString stringWithFormat:@"%@ (%d)", str, count++] ];
    }
        
    NSError* error;
    
    [[self toJson] writeToFile:[self filePath] atomically:YES 
            encoding:NSUTF8StringEncoding error:&error];
    
    return error == NULL;
}

- (BOOL)loadFromFile {
    
    NSData *data = [NSData dataWithContentsOfFile:[self filePath]];
    
    JWireframe* jwire = [[JWireframe alloc] initWithData:data];
    
    for(JStencil* js in jwire.stencils) {
        CGRect frame = CGRectMake([js.x floatValue], [js.y floatValue], [js.width floatValue], [js.height floatValue]);
        KtStencilView* stencil = [[KtStencilView alloc] initWithFrame:frame];
        [stencil setData:[js data]];
        [stencil setTitle:[js title]];
        [stencil setPointData:[js points]];
        
        // converts points to uibezier
        UIBezierPath * path = [KtPenLayer createPath];
        bool first = TRUE;
        for(JPoint *p in [js points]) {
            if(first) {
                [path moveToPoint:p.point];
                first = FALSE;
            } else {
                [path addQuadCurveToPoint:p.point controlPoint:p.controlPoint];
               
            }
        }
        [stencil setPathData:path];
        
        [gridView addSubview:stencil];
    }
    
    
    return YES;
}

- (void) renameFile:(NSString*)newName
{
    NSError* error;
    NSString* oldPath = [self filePath];
    [self setName:newName];
    NSString* newPath = [self filePath];
    
    
    [[NSFileManager defaultManager]  moveItemAtPath:oldPath toPath:newPath error:&error];
}

- (void) deleteFile { 
    NSError* error;
    [[NSFileManager defaultManager] removeItemAtPath:[self filePath] error:&error];
     NSLog(@"%@", [error localizedDescription]);
     NSLog(@"%@", [self filePath]);
    if(error != nil) {
        [[NSFileManager defaultManager] removeItemAtPath:[self originalFilePath] error:&error];
    }
}

- (NSString*) pngFileName
{
    return [NSString stringWithFormat:@"%@.png", self.name];  
}

- (NSString*) pdfFileName
{
    return [NSString stringWithFormat:@"%@.pdf", self.name];  
}

- (NSString*) fileName 
{
    return [NSString stringWithFormat:@"%@%@", self.name, KT_FILE_EXTENSION];
}

- (NSString*) originalFilePath
{
    return [[Documents documentsPath] 
            stringByAppendingPathComponent:originalFilename];    
}

- (NSString*) filePath
{
    return [[Documents documentsPath] 
            stringByAppendingPathComponent:[self fileName]];
}

- (NSString*) pdfFilePath
{
    return [[Documents documentsPath] 
            stringByAppendingPathComponent:[self pdfFileName]];
}


@end
