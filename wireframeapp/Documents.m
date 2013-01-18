//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import "Documents.h"
#import "Wireframe.h"

@implementation Documents


+ (NSString*) thumbsPath
{
    NSString* path =  [[self documentsPath] stringByAppendingPathComponent:@"thumbs"];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:true attributes:nil error:nil];
    
    return path;
}

+ (NSString*) documentsPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (void)listFilenames:(NSMutableArray*)array {
    if(array == nil) {
        return;
    }
    
    
    NSError * error;
    
    NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self documentsPath] error:&error];
    
    
    for(NSString* s in directoryContents) {
        [array addObject:s];
    }    
}

+ (void)listWireframes:(NSMutableArray*)array 
{
    if(array == nil) {
        return;
    }


    NSError * error;
    
    NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self documentsPath] error:&error];
    
    
    for(NSString* s in directoryContents) {
        if(![s isEqualToString:[Documents thumbsPath]]) {
            Wireframe* w = [[Wireframe alloc] initWithName:s];
            [array addObject:w];
        }
    }
    
}

+ (void) listWireframesSorted:(NSMutableArray *)array {
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsPath = [searchPaths objectAtIndex: 0]; 
    
    NSError* error = nil;
    NSArray* filesArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:&error];
    if(error != nil) {
        NSLog(@"Error in reading files: %@", [error localizedDescription]);
        return;
    }
    
    // sort by creation date
    NSMutableArray* filesAndProperties = [NSMutableArray arrayWithCapacity:[filesArray count]];
    for(NSString* file in filesArray) {
        NSString* filePath = [[self documentsPath] stringByAppendingPathComponent:file];
        NSDictionary* properties = [[NSFileManager defaultManager]
                                    attributesOfItemAtPath:filePath
                                    error:&error];
        NSDate* modDate = [properties objectForKey:NSFileModificationDate];
        
        if(error == nil)
        {
            [filesAndProperties addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                           file, @"path",
                                           modDate, @"lastModDate",
                                           nil]];                 
        }
    }
    
    // sort using a block
    // order inverted as we want latest date first
    NSArray* sortedFiles = [filesAndProperties sortedArrayUsingComparator:
                            ^(id path1, id path2)
                            {                               
                                // compare 
                                NSComparisonResult comp = [[path1 objectForKey:@"lastModDate"] compare:
                                                           [path2 objectForKey:@"lastModDate"]];
                                // invert ordering
                                if (comp == NSOrderedDescending) {
                                    comp = NSOrderedAscending;
                                }
                                else if(comp == NSOrderedAscending){
                                    comp = NSOrderedDescending;
                                }
                                return comp;                                
                            }];

    for(NSDictionary* ns in sortedFiles) {
        NSString* s = [ns valueForKey:@"path"];
        

        if (![s isEqualToString:@"thumbs"])  {
            Wireframe* w = [[Wireframe alloc] initWithName:s];
            [array addObject:w];
        }
    }
}


@end
