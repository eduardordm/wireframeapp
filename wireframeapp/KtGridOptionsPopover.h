//
//  KtGridOptionsPopover.h
//  WireframeApp
//
//  Created by [eduardo] on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KtViewController;
@class KtGridView;

@interface KtGridOptionsPopover : UIViewController


@property (weak, nonatomic) IBOutlet UISwitch *switchDisplayGrid;
@property (weak, nonatomic) IBOutlet UISwitch *switchSnapGrid;
@property (weak, nonatomic) IBOutlet UISlider *gridSlider;
@property (weak, nonatomic) IBOutlet UILabel *labelGridSize;

@property (retain, nonatomic) KtViewController* controller;
@property (retain, nonatomic) KtGridView* grid;

@property (nonatomic) int lastQuestionStep;
@property (nonatomic) int stepValue;

- (IBAction)gridSlided:(id)sender;
- (IBAction)snapGridSwitched:(id)sender;
- (IBAction)displayGridSwitched:(id)sender;

@end
