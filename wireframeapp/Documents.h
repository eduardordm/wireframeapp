//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Documents : NSObject

+ (NSString*) documentsPath;

+ (NSString*) thumbsPath;

+ (void)listWireframes:(NSMutableArray*)array;

+ (void)listFilenames:(NSMutableArray*)array;

+ (void) listWireframesSorted:(NSMutableArray *)array;

@end
