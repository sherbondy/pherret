//
//  RootViewController.m
//  pherret
//
//  Created by Ethan Sherbondy on 7/14/12.
//  Copyright (c) 2012 Ethan Sherbondy. All rights reserved.
//

#import "RootViewController.h"
#import "PHAppDelegate.h"
#import "PHLoginViewController.h"
#import "PHHuntTableVC.h"
#import <ObjectiveFlickr.h>

static NSString *kFetchRequestTokenStep  = @"kFetchRequestTokenStep";
static NSString *kGetUserInfoStep        = @"kGetUserInfoStep";
static NSString *kSetImagePropertiesStep = @"kSetImagePropertiesStep";
static NSString *kUploadImageStep        = @"kUploadImageStep";

@interface RootViewController ()

@end

@implementation RootViewController

@synthesize flickrRequest = _flickrRequest;
@synthesize huntTableVC   = _huntTableVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Pick a Hunt!";
        self.huntTableVC = [[PHHuntTableVC alloc] initWithStyle:UITableViewStylePlain];
        self.view = self.huntTableVC.tableView;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChanged:) name:PHShouldUpdateAuthInfoNotification object:nil];
    
    if (!_loginVC){
        _loginVC = [[PHLoginViewController alloc] initWithNibName:nil bundle:nil];
        _loginVC.delegate = self;
    }
    
    [self loginStatusChanged:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (![PHAppDelegate sharedDelegate].isLoggedIn){
        [self.navigationController presentModalViewController:_loginVC animated:YES];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (OFFlickrAPIRequest *)flickrRequest
{
    if (!_flickrRequest) {
        _flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:[PHAppDelegate sharedDelegate].flickrContext];
        _flickrRequest.delegate = self;
		_flickrRequest.requestTimeoutInterval = 60.0;
    }
    
    return _flickrRequest;
}

- (void)logout {
    [[PHAppDelegate sharedDelegate] setAndStoreFlickrAuthToken:nil secret:nil];
    self.navigationController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleBordered target:self action:@selector(authorize)];
}

- (void)authorize
{
    // if there's already OAuthToken, we want to reauthorize
    if ([PHAppDelegate sharedDelegate].isLoggedIn) {
        [self logout];
    }
    
//	authorizeButton.enabled = NO;
//	authorizeDescriptionLabel.text = @"Authenticating...";
    
    self.flickrRequest.sessionInfo = kFetchRequestTokenStep;
    [self.flickrRequest fetchOAuthRequestTokenWithCallbackURL:[NSURL URLWithString:PHCallbackURLBaseString]];
}

- (void)loginStatusChanged:(NSNotification *)aNotification {
    if ([PHAppDelegate sharedDelegate].isLoggedIn){
        NSLog(@"Login status changed: %@", [PHAppDelegate sharedDelegate].flickrUserName);
        [_loginVC hide];
        self.navigationController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)];
    }
}

#pragma mark OFFlickrAPIRequest delegate methods

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didObtainOAuthRequestToken:(NSString *)inRequestToken secret:(NSString *)inSecret
{
    // these two lines are important
    [PHAppDelegate sharedDelegate].flickrContext.OAuthToken = inRequestToken;
    [PHAppDelegate sharedDelegate].flickrContext.OAuthTokenSecret = inSecret;
    
    NSURL *authURL = [[PHAppDelegate sharedDelegate].flickrContext userAuthorizationURLWithRequestToken:inRequestToken
                                                                                    requestedPermission:OFFlickrWritePermission];
    [[UIApplication sharedApplication] openURL:authURL];
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inResponseDictionary);
    
	if (inRequest.sessionInfo == kUploadImageStep) {
//		snapPictureDescriptionLabel.text = @"Setting properties...";
        
        
        NSLog(@"%@", inResponseDictionary);
        NSString *photoID = [[inResponseDictionary valueForKeyPath:@"photoid"] textContent];
        
        _flickrRequest.sessionInfo = kSetImagePropertiesStep;
        [_flickrRequest callAPIMethodWithPOST:@"flickr.photos.setMeta" arguments:[NSDictionary dictionaryWithObjectsAndKeys:photoID, @"photo_id", @"Snap and Run", @"title", @"Uploaded from my iPhone/iPod Touch", @"description", nil]];
	}
    else if (inRequest.sessionInfo == kSetImagePropertiesStep) {
//		[self updateUserInterface:nil];
//		snapPictureDescriptionLabel.text = @"Done";
        
		[UIApplication sharedApplication].idleTimerDisabled = NO;
        
    }
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
    NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inError);
	if (inRequest.sessionInfo == kUploadImageStep) {
//		[self updateUserInterface:nil];
//		snapPictureDescriptionLabel.text = @"Failed";
		[UIApplication sharedApplication].idleTimerDisabled = NO;
        
		[[[UIAlertView alloc] initWithTitle:@"API Failed" message:[inError description] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
        
	}
	else {
		[[[UIAlertView alloc] initWithTitle:@"API Failed" message:[inError description] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
	}
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest imageUploadSentBytes:(NSUInteger)inSentBytes totalBytes:(NSUInteger)inTotalBytes
{
	if (inSentBytes == inTotalBytes) {
//		snapPictureDescriptionLabel.text = @"Waiting for Flickr...";
	}
	else {
//		snapPictureDescriptionLabel.text = [NSString stringWithFormat:@"%u/%u (KB)", inSentBytes / 1024, inTotalBytes / 1024];
	}
}

@end
