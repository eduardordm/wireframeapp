//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+PDF.h"

@interface KtSidebar : NSObject {
    NSMutableArray* cells;
}

- (id)init;

- (void) addStencil:(NSDictionary*) stencil;
- (void) buildViews;

@property (strong) NSMutableArray* cells;

@end
