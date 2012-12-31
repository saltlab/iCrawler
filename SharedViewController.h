//
//  SharedViewController.h
//
//  Created by Mona on 12-03-21.
//

#import <UIKit/UIKit.h>
//#import "QMUITableViewCellDefault.h"
//#import "Model.h"

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
