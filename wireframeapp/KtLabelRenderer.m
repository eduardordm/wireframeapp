//
//  KtLabelRenderer.m
//  WireframeApp
//
//  Created by [eduardo] on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KtLabelRenderer.h"
#import "KtStencilView.h"

@implementation KtLabelRenderer

+ (void) render:(KtStencilView*)view withRect: (CGRect) rect {
    
    NSString* txt = view.data;
    
    CGRect textFrame = rect;
    
    [[UIColor blackColor] setFill];
    
    if ((view.data == nil) || ([view.data length] <= 0 )) {
         [[UIColor lightGrayColor] setFill];
         txt = @"Label";
        
    }
    
    CGFloat font_size = 6;
    for(font_size = 6; font_size < 372; font_size++) {
        CGSize s = [txt sizeWithFont:[UIFont fontWithName: @"Helvetica" size: font_size] constrainedToSize:rect.size lineBreakMode:UILineBreakModeWordWrap];

//        CGSize s = [txt sizeWithFont:[UIFont fontWithName: @"Helvetica" size: font_size] ];
        if ((s.width+6 >= rect.size.width) || (s.height+6 >= rect.size.height)) {
            break;
        }
    }
    
   [txt drawInRect: textFrame withFont: [UIFont fontWithName: @"Helvetica" size: font_size] lineBreakMode: UILineBreakModeCharacterWrap alignment: UITextAlignmentLeft];
    

}

@end
