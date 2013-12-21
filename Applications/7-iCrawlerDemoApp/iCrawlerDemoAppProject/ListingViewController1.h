//
//  ListingViewController1.h
//
//  Created by Mona.
//

#import <UIKit/UIKit.h>
#import "SharedViewController.h"

@interface ListingViewController1 : SharedViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView *tableView;
  	NSMutableArray *filteredListContent;
	NSMutableDictionary *listItemsDict;
	NSArray *keys;
	NSString *queryArgument;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic,retain) NSMutableDictionary *listItemsDict;
@property (nonatomic,retain) NSArray *keys;
@property (nonatomic, retain) NSString *queryArgument;

- (void)styleViews;
- (void)refresh;

@end
