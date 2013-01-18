//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPoint : NSObject {
    CGPoint point;
    CGPoint controlPoint;
}

@property (readwrite) CGPoint point;
@property (readwrite) CGPoint controlPoint;

- (NSDictionary*) toJson;

@end
