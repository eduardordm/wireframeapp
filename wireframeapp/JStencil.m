//
//  JStencil.m
//  WireframeApp
//
//  Created by [eduardo] on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JStencil.h"
#import "JPoint.h"

@implementation JStencil

@synthesize x;
@synthesize y;
@synthesize width;
@synthesize height;
@synthesize title;
@synthesize data;
@synthesize points;

- (id) init 
{
    self = [super init];
    if (self) {
        points = [[NSMutableArray alloc] init];
    }
    return self;    
}

- (NSDictionary*) toJson
{
    
    NSMutableArray* pointArray = [[NSMutableArray alloc] init];
    
    for(JPoint* j in points) {
        
        [pointArray addObject:[j toJson]];
        
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys: 
            x, @"x",
            y, @"y",
            width, @"width",
            height, @"height",
            title, @"title",
                        pointArray, @"points",
            data, @"data",

            nil]; 

}

@end
