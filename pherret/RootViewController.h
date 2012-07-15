//
//  RootViewController.h
//  pherret
//
//  Created by Ethan Sherbondy on 7/14/12.
//  Copyright (c) 2012 Ethan Sherbondy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OFFlickrAPIRequest;
@class PHLoginViewController;
@class PHHuntTableVC;
@protocol OFFlickrAPIRequestDelegate;
@protocol FlickrLoginProtocol;

@interface RootViewController : UIViewController <OFFlickrAPIRequestDelegate, FlickrLoginProtocol> {
    PHLoginViewController *_loginVC;
}

- (void)authorize;

@property (nonatomic, readonly) OFFlickrAPIRequest *flickrRequest;
@property (nonatomic, strong) PHHuntTableVC *huntTableVC;

@end
