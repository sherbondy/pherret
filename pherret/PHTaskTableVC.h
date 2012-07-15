//
//  PHTaskTableVC.h
//  pherret
//
//  Created by Ethan Sherbondy on 7/14/12.
//  Copyright (c) 2012 Ethan Sherbondy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHMapView;

@interface PHTaskTableVC : UITableViewController {
    UIView *_joinHuntView;
    PHMapView *_mapView;
    BOOL    _isTableViewHidden;
}

- (IBAction)joinHunt:(id)sender;

@property (nonatomic, strong) NSDictionary *huntInfo;

@end
