//
//  KtGridOptionsPopover.m
//  WireframeApp
//
//  Created by [eduardo] on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KtGridOptionsPopover.h"

#import "KtGridView.h"
#import "KtViewController.h"

@implementation KtGridOptionsPopover
@synthesize switchDisplayGrid;
@synthesize switchSnapGrid;
@synthesize gridSlider;
@synthesize labelGridSize;
@synthesize grid;
@synthesize controller;

@synthesize lastQuestionStep;
@synthesize stepValue;

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
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if([prefs objectForKey:@"display_grid"] == nil) {
        [prefs setBool:TRUE forKey:@"display_grid"];
    }
    if([prefs objectForKey:@"snap_grid"] == nil) {
        [prefs setBool:FALSE forKey:@"snap_grid"];
    }    
    if([prefs objectForKey:@"grid_size"] == nil) {
        [prefs setFloat:8.0 forKey:@"grid_size"];
    }   
    
    [prefs synchronize];
    
    
    [switchDisplayGrid setOn:[prefs boolForKey:@"display_grid"]];
    [switchSnapGrid setOn:[prefs boolForKey:@"snap_grid"]];
    [gridSlider setValue:[prefs floatForKey:@"grid_size"]];
    
    
    [self.grid setShouldSnapToGrid:[switchSnapGrid isOn]];
    [self.grid setShouldDrawGrid:[switchSnapGrid isOn]];
    [self.grid setGridSize:[gridSlider value]];
    
    [labelGridSize setText:[NSString stringWithFormat:@"%.0f", gridSlider.value]];
    
    self.stepValue = 8.0f;
    
    // Set the initial value to prevent any weird inconsistencies.
    self.lastQuestionStep = (self.gridSlider.value) / self.stepValue;
    
    
     [self.grid toggleGrid];
    
}

- (void)viewDidAppear:(BOOL)animated 
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [switchDisplayGrid setOn:[prefs boolForKey:@"display_grid"]];
    [switchSnapGrid setOn:[prefs boolForKey:@"snap_grid"]];
    [gridSlider setValue:[prefs floatForKey:@"grid_size"]];
    
    
    [self.grid setShouldSnapToGrid:[switchSnapGrid isOn]];
    [self.grid setShouldDrawGrid:[switchSnapGrid isOn]];
    [self.grid setGridSize:[gridSlider value]];
    
    [labelGridSize setText:[NSString stringWithFormat:@"%.0f", gridSlider.value]];
    
    self.stepValue = 8.0f;
    
    // Set the initial value to prevent any weird inconsistencies.
    self.lastQuestionStep = (self.gridSlider.value) / self.stepValue;
 
}

- (void)viewDidUnload
{
    [self setSwitchDisplayGrid:nil];
    [self setSwitchSnapGrid:nil];
    [self setGridSlider:nil];
    [self setLabelGridSize:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)gridSlided:(id)sender {
    
    float newStep = roundf((gridSlider.value) / self.stepValue);
    
    self.gridSlider.value = newStep * self.stepValue;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setFloat:[gridSlider value] forKey:@"grid_size"];
    
    [self.grid setGridSize:[gridSlider value]];
    
    [labelGridSize setText:[NSString stringWithFormat:@"%.0f", gridSlider.value]];
    
    [prefs synchronize];
    
}

- (IBAction)snapGridSwitched:(id)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:[switchSnapGrid isOn] forKey:@"snap_grid"];
    
    [self.grid setShouldSnapToGrid:[switchSnapGrid isOn]];
    
    [prefs synchronize];
}

- (IBAction)displayGridSwitched:(id)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:[switchDisplayGrid isOn] forKey:@"display_grid"];
    [self.grid setShouldDrawGrid:[switchDisplayGrid isOn]];
    [self.grid toggleGrid];
    
    [prefs synchronize];
}

@end
