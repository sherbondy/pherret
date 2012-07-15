//
//  PHTaskViewController.h
//  pherret
//
//  Created by Ethan Sherbondy on 7/15/12.
//  Copyright (c) 2012 Ethan Sherbondy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PHTaskDelegate <NSObject>

- (void)moveToNextTask;
- (void)moveToPrevTask;

@end

@class OFFlickrAPIRequest;
@protocol AFPhotoEditorControllerDelegate;
@protocol OFFlickrAPIRequestDelegate;

@interface PHTaskViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, AFPhotoEditorControllerDelegate, OFFlickrAPIRequestDelegate> {
    OFFlickrAPIRequest *_flickrRequest;
    NSString           *_lastPhotoID;
    NSString           *_currentPhotoID;
}

- (id)initWithDelegate:(id<PHTaskDelegate>)delegate;
- (IBAction)takePhoto:(id)sender;

@property (nonatomic, weak) id<PHTaskDelegate> delegate;
@property (nonatomic, strong) NSDictionary    *task;
@property (nonatomic, readonly) OFFlickrAPIRequest *flickrRequest;

@property (nonatomic, weak) IBOutlet UITextView  *taskNameView;
@property (nonatomic, weak) IBOutlet UIButton    *uploadButton;
@property (nonatomic, weak) IBOutlet UIImageView *photoImageView;

@property (strong, nonatomic) IBOutlet UIView         *titleProgressView;
@property (nonatomic, weak)   IBOutlet UIProgressView *progressView;
@property (nonatomic, weak)   IBOutlet UILabel        *progressLabel;

@end
