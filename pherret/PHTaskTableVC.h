//
//  PHTaskTableVC.h
//  pherret
//
//  Created by Ethan Sherbondy on 7/14/12.
//  Copyright (c) 2012 Ethan Sherbondy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHMapView;
@class JSONDecoder;
@class PHTaskViewController;
@protocol PHTaskDelegate;

@interface PHTaskTableVC : UITableViewController <PHTaskDelegate> {
    UIView *_joinHuntView;
    PHMapView *_mapView;
    BOOL    _isTableViewHidden;
    BOOL    _isParticipant;
    JSONDecoder *_decoder;
    PHTaskViewController *_taskVC;
    NSUInteger    _selectedTaskIndex;
}

- (IBAction)joinHunt:(id)sender;

@property (nonatomic, strong) NSDictionary *huntInfo;
@property (nonatomic, readonly) NSArray *tasks;

@end
