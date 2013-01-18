//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import "JWireframe.h"
#import "JStencil.h"

#import "JStencil.h"
#import "SBJson.h"
#import "KtStencilView.h"
#import "KtGridView.h"
#import "JPoint.h"

@implementation JWireframe

@synthesize stencils;
@synthesize version;

- (id)initWithData:(NSData*)data
{
    self = [super init];
    if (self) {
        self.stencils = [[NSMutableArray alloc] init];
        SBJsonParser* parser = [[SBJsonParser alloc ] init];
        
        
        NSDictionary* dict = [parser objectWithData:data];  
        
        
        for(NSDictionary* dictd in dict) {
            NSString *version_found = [dict objectForKey:@"version"];
            [self setVersion:version_found];
            NSDictionary *d_stencils = [dict objectForKey:@"stencils"];
            for(NSDictionary* d_stencil in d_stencils) {
                JStencil *js = [[JStencil alloc] init];
                
                NSNumber * x = [d_stencil objectForKey:@"x"];
                NSNumber * y = [d_stencil objectForKey:@"y"];
                NSNumber * width = [d_stencil objectForKey:@"width"];
                NSNumber * height = [d_stencil objectForKey:@"height"];
                NSString * title = [d_stencil objectForKey:@"title"];
                NSString * data = [d_stencil objectForKey:@"data"];
                
                [js setX:x];
                [js setY:y];
                [js setWidth:width];
                [js setHeight:height];
                [js setData:data];
                [js setHeight:height];
                [js setTitle:title];
                
                NSDictionary *d_points = [d_stencil objectForKey:@"points"];
                for(NSDictionary* point in d_points) {
                    NSNumber* x = [point objectForKey:@"x"];
                    NSNumber* y = [point objectForKey:@"y"];
                    NSNumber* cx = [point objectForKey:@"cx"];
                    NSNumber* cy = [point objectForKey:@"cy"];
                    
                    JPoint* jp = [[JPoint alloc] init];
                    CGPoint p1 = CGPointMake([x floatValue], [y floatValue]);
                    CGPoint p2 = CGPointMake([cx floatValue], [cy floatValue]);
                    NSLog(@"%.1f", [x floatValue]);
                    [jp setPoint:p1];
                    [jp setControlPoint:p2];
                    [js.points addObject:jp];
                }
                
                [self.stencils addObject:js];
                
            }
            break;
        }
    }
    return self;  
}




- (NSDictionary*) toJson 
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    for(JStencil* j in stencils) {
        
        [array addObject:[j toJson]];
    
    }
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys: 
            version, @"version",
            array, @"stencils",
            nil];  
    
    return dict;
}


@end
