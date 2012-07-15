//
//  PHTaskViewController.m
//  pherret
//
//  Created by Ethan Sherbondy on 7/15/12.
//  Copyright (c) 2012 Ethan Sherbondy. All rights reserved.
//

#import "PHTaskViewController.h"
#import "AFPhotoEditorController.h"

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
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.cameraCaptureMode = (UIImagePickerControllerCameraCaptureModePhoto|UIImagePickerControllerCameraDeviceRear|UIImagePickerControllerCameraFlashModeAuto);
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; // only for debug purposes
    }
    imagePicker.delegate = self;
    [self presentModalViewController:imagePicker animated:YES];
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissModalViewControllerAnimated:NO];
    UIImage *result = [info objectForKey:UIImagePickerControllerOriginalImage];
    AFPhotoEditorController *editorController = [[AFPhotoEditorController alloc] initWithImage:result];
    editorController.delegate = self;
    [self presentModalViewController:editorController animated:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)photoEditorCanceled:(AFPhotoEditorController *)editor
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
