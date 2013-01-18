//
//  KtPopoverController.h
//  WireframeApp
//
//  Created by [eduardo] on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIPlaceHolderTextView;
@class KtStencilView;

@interface KtPopoverController : UIViewController <UITextViewDelegate>

- (IBAction)sendToBack:(id)sender;
- (IBAction)bringToFront:(id)sender;
- (IBAction)btnDeleteClicker:(id)sender;

- (void)textViewDidChange:(UITextView *)textView;

@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *txtData;
@property (weak, nonatomic) KtStencilView *stencilView;



@end
