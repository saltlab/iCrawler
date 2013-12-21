//
//  SharedViewController.m
//
//  Created by Mona.
//

#import "SharedViewController.h"
#import "DetailsViewController1.h"
#import "ListingTableViewCell.h"

@implementation SharedViewController

@synthesize nibLoadedTableCell;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	
}

-(void) goBack {
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)doCancel:(id)sender {	
	[self.navigationController dismissModalViewControllerAnimated:YES]; 
}


#pragma mark -
#pragma mark UITableCells 
- (UITableViewCell*)createListingCell:(UITableView*)tableView {
    
	static NSString *CellIdentifier = @"ListingTableViewCell";
    
    ListingTableViewCell *cell = (ListingTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"ListingTableViewCell" owner:self options:NULL];
        cell = (ListingTableViewCell*)nibLoadedTableCell;
        //Styling now in awakeFromNib        
    }
    // Set up the cell...
    cell.titleLabel.text = [NSString stringWithFormat:@"%@ %@", @"First Name", @"Last Name"];
    cell.subtitle1Label.text = @"Subtitle1";
    cell.subtitle2Label.text = @"Subtitle2";
    
 	return cell;
}

- (UITableViewCell*)createListingCell2:(UITableView*)tableView {
    
	static NSString *CellIdentifier = @"ListingTableViewCell";
    
    ListingTableViewCell *cell = (ListingTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"ListingTableViewCell" owner:self options:NULL];
        cell = (ListingTableViewCell*)nibLoadedTableCell;
        //Styling now in awakeFromNib        
    }
    // Set up the cell...
    cell.titleLabel.text = @"test";
    cell.subtitle1Label.hidden = YES;
    cell.subtitle2Label.hidden = YES;
    
 	return cell;
}

#pragma mark -
#pragma mark UITableViewCell Heights
- (CGFloat)heightForListingCell {
    return 90.0f;
}

- (CGFloat)heightForListingCell2 {
    return 50.0f;
}

#pragma mark -
#pragma mark Load View Controller Helpers
- (void)loadDetailsView {
    DetailsViewController1 *viewController = [[DetailsViewController1 alloc] initWithNibName:@"DetailsViewController1" bundle:nil];
	viewController.title = @"Details";
	viewController.queryArgument = @"push";
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release]; 
}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
