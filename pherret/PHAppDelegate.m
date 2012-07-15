//
//  PHAppDelegate.m
//  pherret
//
//  Created by Ethan Sherbondy on 7/14/12.
//  Copyright (c) 2012 Ethan Sherbondy. All rights reserved.
//

#import "PHAppDelegate.h"
#import "AFPhotoEditorController.h"
#import "RootViewController.h"
#import <ObjectiveFlickr.h>

#define FLICKR_API_KEY @"8c6dee3864f3b801f49c0976fbfb76a7"
#define FLICKR_API_SHARED_SECRET @"81b7cff625c1ab29"

static NSString *kStoredAuthTokenKeyName            = @"FlickrOAuthToken";
static NSString *kStoredAuthTokenSecretKeyName      = @"FlickrOAuthTokenSecret";

static NSString *kGetAccessTokenStep                = @"kGetAccessTokenStep";
static NSString *kCheckTokenStep                    = @"kCheckTokenStep";


@implementation PHAppDelegate

@synthesize flickrUserName = _flickrUserName;

+ (PHAppDelegate *)sharedDelegate
{
    return (PHAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UIViewController       *rootVC        = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    _navController = [[UINavigationController alloc] initWithRootViewController:rootVC];

    self.window.rootViewController = _navController;
    
    _navController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:nil action:nil];
        
    if ([self.flickrContext.OAuthToken length]) {
		[self flickrRequest].sessionInfo = kCheckTokenStep;
		[_flickrRequest callAPIMethodWithGET:@"flickr.test.login" arguments:nil];
	}
    
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([self flickrRequest].sessionInfo) {
        // already running some other request
        NSLog(@"Already running some other request");
    }
    else {
        NSString *token = nil;
        NSString *verifier = nil;
        BOOL result = OFExtractOAuthCallback(url, [NSURL URLWithString:PHCallbackURLBaseString], &token, &verifier);
        
        if (!result) {
            NSLog(@"Cannot obtain token/secret from URL: %@", [url absoluteString]);
            return NO;
        }
        
        [self flickrRequest].sessionInfo = kGetAccessTokenStep;
        [_flickrRequest fetchOAuthAccessTokenWithRequestToken:token verifier:verifier];
    }
    
    return YES;
}

- (OFFlickrAPIRequest *)flickrRequest
{
	if (!_flickrRequest) {
		_flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:self.flickrContext];
		_flickrRequest.delegate = self;
	}
    
	return _flickrRequest;
}

- (void)setAndStoreFlickrAuthToken:(NSString *)inAuthToken secret:(NSString *)inSecret
{
	if (![inAuthToken length] || ![inSecret length]) {
		self.flickrContext.OAuthToken = nil;
        self.flickrContext.OAuthTokenSecret = nil;
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:kStoredAuthTokenKeyName];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kStoredAuthTokenSecretKeyName];
        
	}
	else {
		self.flickrContext.OAuthToken       = inAuthToken;
        self.flickrContext.OAuthTokenSecret = inSecret;
		[[NSUserDefaults standardUserDefaults] setObject:inAuthToken forKey:kStoredAuthTokenKeyName];
		[[NSUserDefaults standardUserDefaults] setObject:inSecret forKey:kStoredAuthTokenSecretKeyName];
	}
}

- (OFFlickrAPIContext *)flickrContext
{
    if (!_flickrContext) {
        _flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:FLICKR_API_KEY sharedSecret:FLICKR_API_SHARED_SECRET];
        
        NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:kStoredAuthTokenKeyName];
        NSString *authTokenSecret = [[NSUserDefaults standardUserDefaults] objectForKey:kStoredAuthTokenSecretKeyName];
        
        if (([authToken length] > 0) && ([authTokenSecret length] > 0)) {
            _flickrContext.OAuthToken = authToken;
            _flickrContext.OAuthTokenSecret = authTokenSecret;
        }
    }
    
    return _flickrContext;
}

- (void)cancelAction
{
	[_flickrRequest cancel];
	[self setAndStoreFlickrAuthToken:nil secret:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:PHShouldUpdateAuthInfoNotification object:self];
}

- (BOOL)isLoggedIn {
    return [[PHAppDelegate sharedDelegate].flickrContext.OAuthToken length] > 0;
}

#pragma mark OFFlickrAPIRequest delegate methods
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didObtainOAuthAccessToken:(NSString *)inAccessToken secret:(NSString *)inSecret userFullName:(NSString *)inFullName userName:(NSString *)inUserName userNSID:(NSString *)inNSID
{
    [self setAndStoreFlickrAuthToken:inAccessToken secret:inSecret];
    self.flickrUserName = inUserName;
    
	[[NSNotificationCenter defaultCenter] postNotificationName:PHShouldUpdateAuthInfoNotification object:self];
    [self flickrRequest].sessionInfo = nil;
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    if (inRequest.sessionInfo == kCheckTokenStep) {
		self.flickrUserName = [inResponseDictionary valueForKeyPath:@"user.username._text"];
	}
    
	[[NSNotificationCenter defaultCenter] postNotificationName:PHShouldUpdateAuthInfoNotification object:self];
    [self flickrRequest].sessionInfo = nil;
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
	if (inRequest.sessionInfo == kGetAccessTokenStep) {
	}
	else if (inRequest.sessionInfo == kCheckTokenStep) {
		[self setAndStoreFlickrAuthToken:nil secret:nil];
	}

	[[[UIAlertView alloc] initWithTitle:@"Could not connect to Flickr" message:[inError description]
                               delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
	[[NSNotificationCenter defaultCenter] postNotificationName:PHShouldUpdateAuthInfoNotification object:self];
}

@end
