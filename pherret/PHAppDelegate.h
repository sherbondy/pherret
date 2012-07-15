//
//  PHAppDelegate.h
//  pherret
//
//  Created by Ethan Sherbondy on 7/14/12.
//  Copyright (c) 2012 Ethan Sherbondy. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *PHShouldUpdateAuthInfoNotification = @"PHShouldUpdateAuthInfoNotification";
static NSString *PHCallbackURLBaseString            = @"pherret://auth";

@class OFFlickrAPIContext;
@class OFFlickrAPIRequest;
@protocol OFFlickrAPIRequestDelegate;

@interface PHAppDelegate : UIResponder <UIApplicationDelegate, OFFlickrAPIRequestDelegate> {
    OFFlickrAPIContext *_flickrContext;
	OFFlickrAPIRequest *_flickrRequest;
    UINavigationController *_navController;
}

+ (PHAppDelegate *)sharedDelegate;

- (void)setAndStoreFlickrAuthToken:(NSString *)inAuthToken secret:(NSString *)inSecret;

@property (strong, nonatomic)   UIWindow *window;
@property (nonatomic, readonly) OFFlickrAPIContext *flickrContext;
@property (nonatomic, retain)   NSString *flickrUserName;
@property (nonatomic, readonly) BOOL isLoggedIn;

@end
