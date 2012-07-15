//
//  PHHuntCellView.h
//  
//
//  Created by Ethan Sherbondy on 7/14/12.
//
//

#import <UIKit/UIKit.h>

@interface PHHuntCell : UITableViewCell {
    UIView *_bgView;
}

- (id)initWithReuseIdentifier;
- (void)refreshTimeLeft;

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLeftLabel;
@property (nonatomic, weak) IBOutlet UILabel *playerCount;
@property (nonatomic, strong) NSDate *endDate;

@end
