//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import "JPoint.h"

@implementation JPoint

@synthesize point;
@synthesize controlPoint;

- (NSDictionary*) toJson
{

    return [NSDictionary dictionaryWithObjectsAndKeys: 
            [NSNumber numberWithFloat:point.x], @"x",
            [NSNumber numberWithFloat:point.y], @"y",
            [NSNumber numberWithFloat:controlPoint.x], @"cx",
            [NSNumber numberWithFloat:controlPoint.y], @"cy",
            nil]; 
    
}

@end
