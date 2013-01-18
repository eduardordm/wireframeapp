//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWireframe : NSObject {
    NSMutableArray* stencils;
    NSString* version;
    NSString* base64Image;
}

@property (retain, nonatomic) NSString* version;

@property (retain, nonatomic) NSMutableArray* stencils;



- (id)initWithData:(NSData*)data;

- (NSDictionary*) toJson;

@end
