//
//  DetailsViewController1.m
//
//  Created by Mona.
//

#import "DetailsViewController1.h"
#import "WebViewController.h"
#import "HTMLPageViewController.h"

@implementation DetailsViewController1

@synthesize Label0, value1, value4, Label4, value5, Label3, Label2, Label1, value2, value3, queryArgument, dummyWebView, scrollView, websiteButton, htmlButton;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self styleViews];
    Label0.text = @"Value 0";
    value1.text = @"Value 1";
    dummyWebView.delegate = self;
	dummyWebView.backgroundColor = [UIColor clearColor];
    [dummyWebView loadHTMLString:[NSString stringWithFormat:@"<html><head><style>body {font-family: helvetica,arial,sans-serif; font-size:14px; line-height:1.4em; color:%@; text-decoration: none;}</style></head><body>%@</body></html>",[UIColor blackColor], @"Content"] baseURL:nil];
    
    value2.text = @"Value 2";
    value3.text = @"Value 3";
    value4.text = @"Value 4";
    value5.text = @"Value 5";
    websiteButton.hidden = NO;
	
	if ([self.queryArgument isEqual:@"push"]) {
		UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
		button1.frame = CGRectMake(0, 0, 60, 34.0);
        button1.accessibilityLabel = @"button back";
		[button1 setImage:[UIImage imageNamed:@"button_back.png"] forState:UIControlStateNormal];
		[button1 addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *buttonAdd1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
		self.navigationItem.leftBarButtonItem = buttonAdd1;
	} 

	if ([self.title isEqualToString:@"Detail"]) {
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(0, 0, 60, 34.0);
        button.accessibilityLabel = @"button up";
		[button setImage:[UIImage imageNamed:@"button_up.png"] forState:UIControlStateNormal];
		[button addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *buttonAdd = [[UIBarButtonItem alloc] initWithCustomView:button];
		self.navigationItem.rightBarButtonItem = buttonAdd;
	}
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];	
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	
}

- (void)styleViews {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)rightButtonClicked {
	HTMLPageViewController *viewController = [[HTMLPageViewController alloc] initWithNibName:@"HTMLPageViewController" bundle:nil];
	viewController.htmlString = @"Test HTML content";
	viewController.title =  @"HTML Page"; 
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

- (IBAction)viewWebsite {
    WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
	webViewController.title = @"Detail Website";
    webViewController.loadURL = [NSURL URLWithString:@"http://www.google.com"];
    [self.navigationController pushViewController:webViewController animated:YES];	
	[webViewController release];
}

- (IBAction)viewHtml {
	HTMLPageViewController *viewController = [[HTMLPageViewController alloc] initWithNibName:@"HTMLPageViewController" bundle:nil];
	viewController.htmlString = @"Test HTML content";
	viewController.title =  @"HTML Page"; 
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

#pragma mark -
#pragma mark UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [webView sizeToFit];
    CGRect frame = webView.frame;
    
    [scrollView setContentSize:CGSizeMake(frame.size.width,  frame.origin.y + frame.size.height + 110)];
    Label4.frame =  CGRectMake(frame.origin.x, frame.origin.y + frame.size.height + 5, 300, 20);
    value4.frame = CGRectMake(Label4.frame.origin.x, Label4.frame.origin.y + Label4.frame.size.height, 300, 20);
    value5.frame = CGRectMake(value4.frame.origin.x, value4.frame.origin.y + value4.frame.size.height, 300, 20);
}

#pragma mark -
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

