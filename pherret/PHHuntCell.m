//
//  PHHuntCellView.m
//  
//
//  Created by Ethan Sherbondy on 7/14/12.
//
//

#import "PHHuntCell.h"

@implementation PHHuntCell

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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
