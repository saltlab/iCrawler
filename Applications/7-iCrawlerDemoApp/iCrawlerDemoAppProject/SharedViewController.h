//
//  SharedViewController.h
//
//  Created by Mona.
//

#import <UIKit/UIKit.h>

@interface SharedViewController : UIViewController {
   	UITableViewCell *nibLoadedTableCell;
}

@property (nonatomic, retain) IBOutlet UITableViewCell *nibLoadedTableCell;

- (void)loadDetailsView;
- (UITableViewCell*)createListingCell:(UITableView*)tableView;
- (UITableViewCell*)createListingCell2:(UITableView*)tableView;
- (CGFloat)heightForListingCell;
- (CGFloat)heightForListingCell2;

@end
