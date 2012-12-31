//
//  ListingViewController1.m
//
//  Created by Mona on 12-03-21.
//

#import "ListingViewController1.h" 
#import "DetailsViewController1.h"

@implementation ListingViewController1

@synthesize tableView, filteredListContent;
@synthesize listItemsDict, keys, queryArgument;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self styleViews];
    [self refresh];
	
	self.filteredListContent = [NSMutableArray array];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 60.0, 30.0);
	button.accessibilityLabel = @"button back";
    [button setImage:[UIImage imageNamed:@"button_back.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonBack = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = buttonBack;
}

- (void)refresh {
    //get data 
    self.listItemsDict =  [NSMutableDictionary dictionaryWithObjectsAndKeys:
							   [NSArray arrayWithObjects:@"value 11", @"value 12", @"value 13", @"value 14", nil], @"key 1",
							   [NSArray arrayWithObjects:@"value 21", @"value 22", @"value 23", @"value 24", nil], @"key 2",
							   [NSArray arrayWithObjects:@"value 31", @"value 32", @"value 33", @"value 34", nil], @"key 3",
							   [NSArray arrayWithObjects:@"value 41", @"value 42", @"value 43", @"value 44", nil], @"key 4",
							   [NSArray arrayWithObjects:@"value 51", @"value 52", @"value 53", @"value 54", nil], @"key 5",
							   [NSArray arrayWithObjects:@"value 61", @"value 62", @"value 63", @"value 64", nil], @"key 6",
							 nil];

    self.keys  = [[self.listItemsDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
	self.tableView.accessibilityLabel = @"tableView";
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	
}

- (void)styleViews {
    self.tableView.backgroundColor = [UIColor whiteColor];
	self.tableView.separatorColor = [UIColor blackColor];
    //self.searchDisplayController.searchBar.tintColor = [UIColor grayColor];
}

-(void) goBack {
	
	if ([self.queryArgument isEqual:@"Tab"])
		[self.parentViewController.navigationController popViewControllerAnimated:YES];
	else
		[self.navigationController popViewControllerAnimated:YES];
        
}

#pragma mark -
#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)_tableView {
	if (_tableView == self.searchDisplayController.searchResultsTableView)
		return 1;
	else
		return [self.keys count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section {
	if ([self.keys count]) {
		NSString *key = [self.keys objectAtIndex:section];
		
		if (_tableView == self.searchDisplayController.searchResultsTableView)
			return [self.filteredListContent count];
		else {
			NSMutableArray *thisSection = [self.listItemsDict objectForKey:key];
			return [thisSection count];
		}
	}
	return 0;
}


- (UIView *)tableView:(UITableView *)_tableView viewForHeaderInSection:(NSInteger)section {
	if (_tableView == self.searchDisplayController.searchResultsTableView) {
		return nil;	
	}
	
    UIView* headerTitleView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, _tableView.bounds.size.width, 22.0)] autorelease];
    headerTitleView.backgroundColor = [UIColor clearColor]; 
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor blackColor]; 
    headerLabel.textColor = [UIColor whiteColor];   
    headerLabel.font = [UIFont systemFontOfSize:13];	
    headerLabel.opaque = NO;
    headerLabel.frame = CGRectMake(0.0, 0.0, _tableView.bounds.size.width, 22.0);
    
	headerLabel.text = [NSString stringWithFormat:@"  %@", [self.keys objectAtIndex:section]];
	[headerTitleView addSubview:headerLabel];
    [headerLabel release];
	return headerTitleView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.queryArgument isEqual:@"Tab"]) {
		if ([self.title isEqual:@"1st Tab"] || [self.title isEqual:@"3rd Tab"])
			return [self heightForListingCell]; 
		else
			return [self heightForListingCell2]; 
	}
	else
		return [self heightForListingCell]; 
	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Set up the cell...
    id *thisObject; 
    
    if (_tableView == self.searchDisplayController.searchResultsTableView)
        thisObject = (id*) [self.filteredListContent objectAtIndex:indexPath.row];
    else {
        NSUInteger section = [indexPath section];
        NSString *key = [keys objectAtIndex:section];
        NSMutableArray *thisSection = [self.listItemsDict objectForKey:key];
        thisObject = (id*) [thisSection objectAtIndex: indexPath.row];
    }
	
	UITableViewCell *cell;
	if ([self.queryArgument isEqual:@"Tab"]) {
		if ([self.title isEqual:@"1st Tab"] || [self.title isEqual:@"3rd Tab"])
			cell = [self createListingCell:_tableView];
		else
			cell = [self createListingCell2:_tableView];
	}
	else
		cell = [self createListingCell:_tableView];
    
	return cell;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id *thisObject; 
    
    if (_tableView == self.searchDisplayController.searchResultsTableView)
        thisObject = (id*) [self.filteredListContent objectAtIndex:indexPath.row];
    else {
        NSUInteger section = [indexPath section];
        NSString *key = [keys objectAtIndex:section];
        NSMutableArray *thisSection = [self.listItemsDict objectForKey:key];
        thisObject = (id*) [thisSection objectAtIndex: indexPath.row];
    }
	
	[self loadDetailsView];
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSArray*) sectionIndexTitlesForTableView:(UITableView *)_tableView {
	if ((_tableView == self.searchDisplayController.searchResultsTableView)  || (![self.keys count] > 0)) {
		return nil;	
	}
	else {
        NSMutableArray* indexTitles = [NSMutableArray arrayWithObject:UITableViewIndexSearch];  // add magnifying glass
        [indexTitles addObjectsFromArray:self.keys];
        return indexTitles;
	}
}


#pragma mark -
#pragma mark Content Filtering
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    self.searchDisplayController.searchResultsTableView.separatorColor = [UIColor blackColor];  
    
    [self.filteredListContent removeAllObjects]; // First clear the filtered array.
    NSMutableArray *objects = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *array = (NSMutableArray*)[[self.listItemsDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *key in array) {
        NSMutableArray *objs =  [self.listItemsDict objectForKey:key];
        objects = (NSMutableArray*)[objects arrayByAddingObjectsFromArray:objs];
    }
    /*
    for (Exhibitor *exhibitor in objects) {
        if ([scope isEqualToString:@"Company"]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                      @"(SELF contains[cd] %@)", searchText];
            if ([predicate evaluateWithObject:get(exhibitor, company)]) 
                [filteredListContent addObject:exhibitor];
        } else if ([scope isEqualToString:@"Booth"]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                      @"(SELF contains[cd] %@)", searchText];
            if ([predicate evaluateWithObject:get(exhibitor, boothNumber)]) 
                [filteredListContent addObject:exhibitor];
        }
        
    }*/
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
	[self.filteredListContent removeAllObjects];	
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark -
#pragma mark Memory Managment
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end


