//
//  PHHuntCellView.m
//  
//
//  Created by Ethan Sherbondy on 7/14/12.
//
//

#import "PHHuntCell.h"

@implementation PHHuntCell

@synthesize endDate = _endDate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"PHHuntCellView" owner:self options:nil];
        _bgView = [nibs objectAtIndex:0];
        [self.contentView addSubview:_bgView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setEndDate:(NSDate *)endDate
{
    _endDate = endDate;
    NSDate *now = [NSDate date];
    NSInteger seconds = [endDate timeIntervalSinceDate:now];
    int hours = MAX(floor(seconds /  (60 * 60)), 0);
    float minute_divisor = seconds % (60 * 60);
    int minutes = MAX(floor(minute_divisor / 60), 0);
    float seconds_divisor = seconds % 60;
    seconds = MAX(ceil(seconds_divisor), 0);
    
    self.timeLeftLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}

- (void)refreshTimeLeft
{
    if (_endDate){
        [self setEndDate:_endDate];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
