//
//  ListingTableViewCell.m
//
//  Created by Mona on 12-03-21.
//

#import "ListingTableViewCell.h"

@implementation ListingTableViewCell

@synthesize titleLabel, subtitle1Label, subtitle2Label;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)awakeFromNib {
	//colors
    self.titleLabel.textColor = [UIColor blackColor];
    self.subtitle1Label.textColor = [UIColor blackColor];
    self.subtitle2Label.textColor = [UIColor blackColor];
    
	//fonts	
    self.titleLabel.font =  [UIFont systemFontOfSize:13];
    self.subtitle1Label.font = [UIFont systemFontOfSize:13];
    self.subtitle2Label.font = [UIFont systemFontOfSize:13];
    
}

- (void)dealloc {
    [super dealloc];
}


@end
