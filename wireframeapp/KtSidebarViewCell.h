//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KtSidebarViewCell : UITableViewCell {
    NSString * title;
    NSString * thumb;
    NSString * pdf;
    NSString * fwidth;
    NSString * fheight;
}

@property (retain, nonatomic) NSString * title;
@property (retain, nonatomic) NSString * thumb;
@property (retain, nonatomic) NSString * pdf;
@property (retain, nonatomic) NSString * fwidth;
@property (retain, nonatomic) NSString * fheight;

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@end
