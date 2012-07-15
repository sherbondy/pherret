//
//  PHTaskViewController.m
//  pherret
//
//  Created by Ethan Sherbondy on 7/15/12.
//  Copyright (c) 2012 Ethan Sherbondy. All rights reserved.
//

#import "PHTaskViewController.h"
#import "PHAppDelegate.h"

#import <ObjectiveFlickr.h>
#import "AFPhotoEditorController.h"
#import <AFNetworking/AFNetworking.h>

#define FLICKR_API_KEY @"8c6dee3864f3b801f49c0976fbfb76a7"

static NSString *kUploadImageStep                = @"kUploadImageStep";
static NSString *kAddImageToPoolStep             = @"kAddImageToPoolStep";
static NSString *kSetImageGeotagsStep            = @"kSetImageGeotagsStep";
static NSString *kSetImagePropertiesStep         = @"kSetImagePropertiesStep";

@interface PHTaskViewController ()

@end

@implementation PHTaskViewController
@synthesize titleProgressView = _titleProgressView;

@synthesize task = _task;
@synthesize flickrRequest = _flickrRequest;

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

- (OFFlickrAPIRequest *)flickrRequest
{
    if (!_flickrRequest) {
		_flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:[PHAppDelegate sharedDelegate].flickrContext];
		_flickrRequest.delegate = self;
	}
	return _flickrRequest;
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
    NSString *taskName = [_task objectForKey:@"name"];
    self.taskNameView.text = taskName;
    self.title = taskName;
    _currentPhotoID = nil;
    
    for (NSDictionary *photo in [_task objectForKey:@"photos"]){
        if ([[photo objectForKey:@"ownerFlickrID"] isEqual:[PHAppDelegate sharedDelegate].flickrUserNSID]){
            NSLog(@"User ids match for photo.");
            _currentPhotoID = [photo objectForKey:@"id"];
        }
    }
    
    if (_currentPhotoID){
        NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest?method=flickr.photos.getSizes&api_key=%@&photo_id=%@&format=json&nojsoncallback=1", FLICKR_API_KEY, _currentPhotoID];
        NSURL *photoURL = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:photoURL];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSArray *sizes = [JSON valueForKeyPath:@"sizes.size"];
            NSDictionary *largest = [sizes objectAtIndex:(sizes.count -1)];
            NSString *largestSource = [largest objectForKey:@"source"];
            [self.photoImageView setImageWithURL:[NSURL URLWithString:largestSource]];
            [self.photoImageView setHidden:NO];
        } failure:nil];
        [operation start];
    } else {
        [self.photoImageView setImage:nil];
        [self.photoImageView setHidden:YES];
    }
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

- (void)_startUpload:(UIImage *)image
{
    self.navigationItem.titleView = self.titleProgressView;
    self.progressLabel.text = @"Uploading...";
    NSData *JPEGData = UIImageJPEGRepresentation(image, 0.8);

    self.flickrRequest.sessionInfo = kUploadImageStep;
    [self.flickrRequest uploadImageStream:[NSInputStream inputStreamWithData:JPEGData] suggestedFilename:[self.task objectForKey:@"name"] MIMEType:@"image/jpeg" arguments:@{
        @"is_public": @"1",
        @"tags"     : @"testing"}];
    
	[UIApplication sharedApplication].idleTimerDisabled = YES;
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
    self.photoImageView.image = image;
    [self.photoImageView setHidden: NO];
    [self _startUpload:image];
}

- (void)photoEditorCanceled:(AFPhotoEditorController *)editor
{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark OFFlickrAPIRequest delegate methods
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    if (kUploadImageStep == inRequest.sessionInfo){
        self.progressLabel.text = @"Adding Geo...";
        _lastPhotoID = [inResponseDictionary valueForKeyPath:@"photoid._text"];
        // finished uploading. Set the geo tags
        inRequest.sessionInfo = kSetImageGeotagsStep;
        [inRequest callAPIMethodWithPOST:@"flickr.photos.geo.setLocation" arguments:@{
            @"photo_id" : _lastPhotoID,
            @"lat"      : @"37.7764",
            @"lon"      : @"-122.3944"
         }];
        
    } else if (kSetImageGeotagsStep == inRequest.sessionInfo){
        // time to add to the group pool.
        self.progressLabel.text = @"Finishing...";
        inRequest.sessionInfo = kAddImageToPoolStep;
        [inRequest callAPIMethodWithPOST:@"flickr.groups.pools.add" arguments:@{
         @"photo_id" : _lastPhotoID,
         @"group_id" : kFlickrGroupID
         }];
    } else {
        [self updateUI];
    }
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest imageUploadSentBytes:(NSUInteger)inSentBytes totalBytes:(NSUInteger)inTotalBytes
{
    CGFloat percent = inSentBytes/inTotalBytes;
    [self.progressView setProgress:percent animated:YES];
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
    NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inError);
}

- (void)viewDidUnload {
    [self setTitleProgressView:nil];
    [super viewDidUnload];
}
@end
