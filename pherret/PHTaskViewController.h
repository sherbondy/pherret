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

@interface PHTaskViewController : UIViewController

- (id)initWithDelegate:(id<PHTaskDelegate>)delegate;
- (IBAction)takePhoto:(id)sender;

@property (nonatomic, weak) id<PHTaskDelegate> delegate;
@property (nonatomic, strong) NSDictionary    *task;

@property (nonatomic, weak) IBOutlet UITextView  *taskNameView;
@property (nonatomic, weak) IBOutlet UIButton    *uploadButton;
@property (nonatomic, weak) IBOutlet UIImageView *photoImageView;

@end
