//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Wireframe;

@interface Stencil : NSObject {
    Wireframe * wireframe;
    NSString* title;
    CGRect rect;
    NSString* data;
    
}

@property (retain, nonatomic) NSString* data;

@property (nonatomic, assign) CGRect rect;

@property (retain, nonatomic) NSString* title;

@property (retain, nonatomic) Wireframe * wireframe;

@end
