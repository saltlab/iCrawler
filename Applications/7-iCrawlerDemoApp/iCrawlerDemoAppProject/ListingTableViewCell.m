//
//  ListingTableViewCell.m
//
//  Created by Mona.
//

#import "ListingTableViewCell.h"

@implementation ListingTableViewCell

@synthesize titleLabel, subtitle1Label, subtitle2Label;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
}

- (void)awakeFromNib {
    self.titleLabel.textColor = [UIColor blackColor];
    self.subtitle1Label.textColor = [UIColor blackColor];
    self.subtitle2Label.textColor = [UIColor blackColor];
    self.titleLabel.font =  [UIFont systemFontOfSize:13];
    self.subtitle1Label.font = [UIFont systemFontOfSize:13];
    self.subtitle2Label.font = [UIFont systemFontOfSize:13];

}

- (void)dealloc {
    [super dealloc];
}


@end
