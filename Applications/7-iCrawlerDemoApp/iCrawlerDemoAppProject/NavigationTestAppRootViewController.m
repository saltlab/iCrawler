//
//  NavigationTestAppRootViewController.m
//
//  Created by Mona.
//

#import "NavigationTestAppRootViewController.h"
#import "ListingViewController1.h" 
#import "WebViewController.h"
#import "HTMLPageViewController.h"
#import "DynamicViewController.h"
#import "DetailsViewController1.h"
#import "TextViewViewController.h"

@implementation NavigationTestAppRootViewController

@synthesize tableButton, websiteButton, htmlButton, tabBarButton, dynamicButton, detailButton, modalButton, textViewButton;

- (void)viewDidLoad {
	[super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
	self.title = @"Home";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	//hide nav bar on the main screen
	[self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	
}

#pragma mark -
#pragma mark IBActions
- (IBAction)tableButtonClicked {
	ListingViewController1 *viewController = [[ListingViewController1 alloc] initWithNibName:@"ListingViewController1" bundle:nil];
	viewController.title = @"Table";
	viewController.queryArgument = @"Table";
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

- (IBAction)detailButtonClicked {
	DetailsViewController1 *viewController = [[DetailsViewController1 alloc] initWithNibName:@"DetailsViewController1" bundle:nil];
	viewController.title = @"Detail";
	viewController.queryArgument = @"push";
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

- (IBAction)websiteButtonClicked {
	WebViewController *viewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
	viewController.title = @"Website";
	viewController.loadURL = [NSURL URLWithString:@"http://www.google.com"];	
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

- (IBAction)htmlButtonClicked {
	HTMLPageViewController *viewController = [[HTMLPageViewController alloc] initWithNibName:@"HTMLPageViewController" bundle:nil];
	viewController.htmlString = @"Test HTML content";
	viewController.title =  @"HTML Page"; 
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

- (IBAction)tabBarButtonClicked {
	UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    ListingViewController1 *listingViewController1 = [[ListingViewController1 alloc] initWithNibName:@"ListingViewController1" bundle:nil];
    listingViewController1.title = @"1st Tab";
	listingViewController1.queryArgument = @"Tab";
    listingViewController1.tabBarItem.image = [UIImage imageNamed:@"tab_icon_sun.png"];
	UINavigationController *listingViewController1NavController = [[[UINavigationController alloc ] initWithRootViewController:listingViewController1] autorelease];
    
    ListingViewController1 *listingViewController2 = [[ListingViewController1 alloc] initWithNibName:@"ListingViewController1" bundle:nil];
    listingViewController2.title = @"2nd Tab";
	listingViewController2.queryArgument = @"Tab";
    listingViewController2.tabBarItem.image = [UIImage imageNamed:@"tab_icon_sun.png"];
	UINavigationController *listingViewController2NavController = [[[UINavigationController alloc ] initWithRootViewController:listingViewController2] autorelease];
    
	ListingViewController1 *listingViewController3 = [[ListingViewController1 alloc] initWithNibName:@"ListingViewController1" bundle:nil];
    listingViewController3.title = @"3rd Tab";
	listingViewController3.queryArgument = @"Tab";
    listingViewController3.tabBarItem.image = [UIImage imageNamed:@"tab_icon_sun.png"];
	UINavigationController *listingViewController3NavController = [[[UINavigationController alloc ] initWithRootViewController:listingViewController3] autorelease];
    
	tabBarController.viewControllers = [NSArray arrayWithObjects:   listingViewController1NavController,
                                        listingViewController2NavController, listingViewController3NavController, nil];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:tabBarController animated:YES];
    tabBarController.selectedIndex = 0;
    
    [listingViewController1 release];
    [listingViewController2 release];
    [listingViewController3 release];
}

- (IBAction)dynamicButtonClicked {
	DynamicViewController *viewController = [[DynamicViewController alloc] initWithNibName:@"DynamicViewController" bundle:nil];
	viewController.title = @"Dynamic View";
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

- (IBAction)modalButtonClicked {
	DetailsViewController1 *viewController = [[DetailsViewController1 alloc] initWithNibName:@"DetailsViewController1" bundle:nil];
	viewController.title =  @"Modal Detail"; 
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.navigationController presentModalViewController:navController animated:YES];
    
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.bounds = CGRectMake(0, 0, 60.0, 30.0);
    button.accessibilityLabel = @"button close";
	[button setImage:[UIImage imageNamed:@"button_close.png"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(dismissModalViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *buttonHome = [[UIBarButtonItem alloc] initWithCustomView:button];
	viewController.navigationItem.leftBarButtonItem = buttonHome;
	
	[navController release];
	[viewController release];
}


- (IBAction)textViewButtonClicked {
	TextViewViewController* viewController = [[TextViewViewController alloc] initWithNibName:@"TextViewViewController" bundle:nil];
	viewController.title = @"TextView";
    [self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}


#pragma mark Memory Management
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    //clear out all ImageCache
}

- (void)viewDidUnload {
    // Release anything that can be recreated in viewDidLoad or on demand.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}

@end

