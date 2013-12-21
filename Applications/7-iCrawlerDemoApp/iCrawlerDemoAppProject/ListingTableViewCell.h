//
//  ListingTableViewCell.h
//
//  Created by Mona.
//

#import <UIKit/UIKit.h>

@interface ListingTableViewCell : UITableViewCell {
    UILabel *titleLabel;
    UILabel *subtitle1Label;
	UILabel *subtitle2Label;
}

@property(nonatomic, retain) IBOutlet UILabel *titleLabel;
@property(nonatomic, retain) IBOutlet UILabel *subtitle1Label;
@property(nonatomic, retain) IBOutlet UILabel *subtitle2Label;

@end
