//
//  HTMLPageViewController.m
//
//  Created by Mona on 12-03-21.
//

#import "HTMLPageViewController.h"
#import "WebViewController.h"

@implementation HTMLPageViewController

@synthesize infoWebView, scrollView, filename,  filetype, leaveRoomForTabBar, leaveRoomForNavBar, htmlString;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
        //initialization
        leaveRoomForTabBar = NO;
        leaveRoomForNavBar = YES;
        self.htmlString = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
    
	//check if we're passed an argument 
    if ([self.filetype length] == 0) 
		self.filetype = @"html";
        
	if ([self.htmlString  length] != 0) {	
		self.htmlString  = [self.htmlString  stringByReplacingOccurrencesOfString:@"\\" withString:@""];
		[infoWebView loadHTMLString:self.htmlString  baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
	}
	else if (self.filename) {
		[infoWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:self.filename ofType:filetype]isDirectory:NO]]];
	}
    
    infoWebView.delegate = self;
    infoWebView.scalesPageToFit = YES;
    
	if (leaveRoomForNavBar) {
		CGRect _frame = scrollView.frame;
		[scrollView setFrame:CGRectMake(_frame.origin.x, 48, _frame.size.width, _frame.size.height)];
	}
    
    if (leaveRoomForTabBar) {
		CGRect _frame = scrollView.frame;
	 	[scrollView setFrame:CGRectMake(_frame.origin.x, _frame.origin.y, _frame.size.width, _frame.size.height - 40)];
	}
    
	//  Add back button to navigation bar
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.bounds = CGRectMake(0, 0, 60.0, 30.0);
	button.accessibilityLabel = @"button back";
	[button setImage:[UIImage imageNamed:@"button_back.png"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *buttonHome = [[UIBarButtonItem alloc] initWithCustomView:button];
	self.navigationItem.leftBarButtonItem = buttonHome;
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //	[webView sizeToFit];
 	webView.hidden = NO;
    //  [scrollView setContentSize: CGSizeMake(320,  webView.frame.origin.y + webView.frame.size.height) ];
}

-(void) goBack {
	[self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
	NSString *urlString = request.URL.absoluteString;
	
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		if([urlString isEqualToString: @"about:blank"]){
			return YES;
		}
		else{
            WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];	
			webViewController.loadURL = [NSURL URLWithString:urlString]; 
			webViewController.title = self.title;
			[self.navigationController pushViewController:webViewController animated:YES];
			[webViewController release];
            
            return NO;
        }
	}	
	return YES;
}


- (NSString *)formatHTMLStringFor:(NSString *)thisArticle withContent:(NSString *)content{
	NSString *htmlStr= [NSString stringWithFormat:@"<html> "
                        "<head> "
                        "<style type=\"text/css\"> "
                        "body,p {font-size: 14px; line-height:20px; font-family: Verdana, Arial, sans-serif; color: #6c6b63; width: 300px; padding: 0 6px; background-color: #F2F2EC;} "
                        "body, table, td, tr, img { margin:0; padding:0; border: 0;} "
                        "td {margin:0; padding:0; border: 0;} "
                        "h2 {font-family: Tahoma,Geneva,sans-serif; margin: 10px 0 0 0; padding: 0 0 0 5px; font-size: 18px; line-height: 12px; font-weight: normal; } "
                        "h3 { margin: 10px 0 0 0; padding: 0 0 0 5px;  color:#BD0029; font-size: 14px; line-height: 12px; } "
                        "a { color: #BD0029;} "
                        "ul {margin-left: 0px;} "
                        ".join a { background: #df1d71; color: #fff; padding: 5px; margin: 5px 5px 20px 5px; width: 130px; float: left;} "
                        ".join a {color: #fff; text-decoration: none; font-weight: bold;} "
                        ".clear {  "
                        "clear: both; "
                        "} "
                        "</style> "
                        "</head> "
                        "<body> "
                        "<h3>%@</h3> "
                        "%@"
                        "</body> "
                        "</html> "
                        , thisArticle, content];
	
	return htmlStr;
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
	[infoWebView stopLoading];
	infoWebView.delegate = nil;
	[infoWebView release];
	infoWebView = nil;
	[scrollView release];
	[filename release];
	[filetype release];
    
    [super dealloc];
}


@end
