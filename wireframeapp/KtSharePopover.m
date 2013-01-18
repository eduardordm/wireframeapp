//
//  KtSharePopover.m
//  WireframeApp
//
//  Created by [eduardo] on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KtSharePopover.h"
#import "KtGridView.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@implementation KtSharePopover

@synthesize grid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)cloudSync:(id)sender {
}

- (IBAction)emailPng:(id)sender {
  //  UIImage *image = grid.image;
    NSData * data = grid.pngImage; // UIImagePNGRepresentation(image);
    

    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    
    [picker setSubject:@"Wireframe"];
    NSString *emailBody = @"I just made this wireframe, check it out!";
    [picker setMessageBody:emailBody isHTML:NO];
    [picker addAttachmentData:data mimeType:@"image/png" fileName:@"Wireframe.png"];
    
    [self presentModalViewController:picker animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{
    // Called once the email is sent
    // Remove the email view controller	
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)emailPdf:(id)sender {
    //  UIImage *image = grid.image;
    NSData * data = grid.pdfImage; // UIImagePNGRepresentation(image);
    
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"Wireframe"];
    NSString *emailBody = @"I just made this wireframe, check it out!";
    [picker setMessageBody:emailBody isHTML:NO];
    [picker addAttachmentData:data mimeType:@"application/pdf" fileName:@"Wireframe.pdf"];
    
    [self presentModalViewController:picker animated:YES];
}
@end
