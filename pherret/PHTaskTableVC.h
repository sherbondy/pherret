//
//  PHTaskTableVC.h
//  pherret
//
//  Created by Ethan Sherbondy on 7/14/12.
//  Copyright (c) 2012 Ethan Sherbondy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHTaskTableVC : UITableViewController {
    UIView *_joinHuntView;
}

- (IBAction)joinHunt:(id)sender;

@property (nonatomic, strong) NSDictionary *huntInfo;

@end