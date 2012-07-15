//
//  PHTaskViewController.m
//  pherret
//
//  Created by Ethan Sherbondy on 7/15/12.
//  Copyright (c) 2012 Ethan Sherbondy. All rights reserved.
//

#import "PHTaskViewController.h"

@interface PHTaskViewController ()

@end

@implementation PHTaskViewController

@synthesize task = _task;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSArray *nextPrevItems = @[[UIImage imageNamed:@"prev"], [UIImage imageNamed:@"next"]];
        UISegmentedControl *nextPrevControl = [[UISegmentedControl alloc] initWithItems:nextPrevItems];
        nextPrevControl.segmentedControlStyle = UISegmentedControlStyleBar;
        nextPrevControl.momentary = YES;
        [nextPrevControl addTarget:self action:@selector(nextPrevAction:) forControlEvents:UIControlEventValueChanged];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nextPrevControl];
    }
    return self;
}

- (id)initWithDelegate:(id<PHTaskDelegate>)delegate
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (IBAction)takePhoto:(id)sender
{
    NSLog(@"Send to camera...");
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateUI];
}

- (void)updateUI
{
    self.taskNameView.text = [_task objectForKey:@"name"];
}

- (void)nextPrevAction:(id)sender {
    if ([sender isKindOfClass:[UISegmentedControl class]]) {
        int action = [(UISegmentedControl *)sender selectedSegmentIndex];
        switch (action) {
            case 0:
                [self.delegate moveToPrevTask];
                break;
            case 1:
                [self.delegate moveToNextTask];
                break;
            default:
                break;
        }
    }
}

- (void)setTask:(NSDictionary *)task
{
    _task = task;
    [self updateUI];
    // check for upload
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
