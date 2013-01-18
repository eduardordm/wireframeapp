//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JStencil : NSObject {
    NSNumber* x;
    NSNumber* y;
    NSNumber* width;
    NSNumber* height;
    NSString* title;
    NSString* data;
    NSMutableArray* points;
    
}

- (id) init ;

@property (retain, nonatomic) NSNumber* x;

@property (retain, nonatomic) NSNumber* y;

@property (retain, nonatomic) NSNumber* width;

@property (retain, nonatomic) NSNumber* height;

@property (retain, nonatomic) NSString* title;

@property (retain, nonatomic) NSString* data;

@property (retain, nonatomic) NSMutableArray* points;

- (NSDictionary*) toJson;

@end
