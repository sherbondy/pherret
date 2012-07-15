//
//  PHHuntTableVC.h
//  pherret
//
//  Created by Ethan Sherbondy on 7/14/12.
//  Copyright (c) 2012 Ethan Sherbondy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSONDecoder;

@interface PHHuntTableVC : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
    JSONDecoder *_decoder;
}

@property (nonatomic, strong, readonly) NSArray *content;

@end
