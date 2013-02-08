//
//  WireframeApp
//
//  Created by J Eduardo Mourao
//  Copyright (c) 2012 J Eduardo Mourao. All rights reserved.
//

#import "KtSidebar.h"
#import "KtSidebarViewCell.h"
#import "SBJson.h"


@implementation KtSidebar

@synthesize cells;

- (id)init
{
    self = [super init];
    if (self) {
        cells = [[NSMutableArray alloc] init];
        [self buildViews];
    }
    return self;
}

- (void) addStencil:(NSDictionary*) stencil
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"KtSidebarViewCell" owner:nil options:nil];
    
    KtSidebarViewCell *cell;
    
    for(id currentObject in topLevelObjects)
    {
        if([currentObject isKindOfClass:[KtSidebarViewCell class]])
        {
            cell = (KtSidebarViewCell *)currentObject;
            [cells addObject:cell];
            break;
        }
    }
    
    NSString * title = [[stencil objectForKey:@"stencil"] objectForKey:@"title"];
    NSString * thumb = [[stencil objectForKey:@"stencil"] objectForKey:@"thumb"];
    NSString * pdf = [[stencil objectForKey:@"stencil"] objectForKey:@"pdf"];
    NSString * fwidth = [[stencil objectForKey:@"stencil"] objectForKey:@"width"];
    NSString * fheight = [[stencil objectForKey:@"stencil"] objectForKey:@"height"];
    
    [cell setPdf:pdf];
    [cell setThumb:thumb];
    [cell setTitle:title];
    [cell setFheight:fheight];
    [cell setFwidth:fwidth];
    [cell setIndentationWidth:3];
    [cell setIndentationLevel:2];

    // UIImage *img = [ UIImage imageWithPDFNamed:pdf atSize:CGSizeMake( 30, 30 ) ];
    
    // [cell.imageView setImage:img];
    [cell.label setText:title];
    


}

- (void) buildViews
{
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"stencils" ofType:@"json"];
    NSData *stencil_json = [NSData dataWithContentsOfFile:filePath];
    
    NSString * t = [[NSString alloc] initWithData:stencil_json encoding:NSUTF8StringEncoding];
    
    NSArray *stencils = [parser objectWithString:t];

    
    for (NSDictionary *stencil in stencils)
    {
        [self addStencil:stencil];
    }
    
}

@end
