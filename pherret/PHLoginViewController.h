//
//  PHLoginViewController.h
//  pherret
//
//  Created by Ethan Sherbondy on 7/14/12.
//  Copyright (c) 2012 Ethan Sherbondy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FlickrLoginProtocol <NSObject>

- (void)authorize;

@end


@interface PHLoginViewController : UIViewController

- (IBAction)login:(id)sender;
- (void)hide;

@property (nonatomic, weak) id<FlickrLoginProtocol> delegate;
@property (nonatomic, assign) IBOutlet UIButton *loginButton;

@end