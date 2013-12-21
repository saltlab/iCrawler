//
//  WebViewController.m
//
//  Created by Mona.
//

#import "WebViewController.h"

@implementation WebViewController

@synthesize webView, loadURL, activityIndicatorView, url, disableFailedLoadError;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	webView.delegate = self;
	self.webView.scalesPageToFit = YES;
	
	//  Add back button to navigation bar
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.bounds = CGRectMake(0, 0, 60.0, 30.0);
	button.accessibilityLabel = @"button back";
	[button setImage:[UIImage imageNamed:@"button_back.png"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *buttonHome = [[UIBarButtonItem alloc] initWithCustomView:button];
	self.navigationItem.leftBarButtonItem = buttonHome;
}

//hide nav bar on the main screen
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	
}

//hide nav bar on the main screen
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    if (self.loadURL){
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		NSURLRequest *requestObj = [NSURLRequest requestWithURL:self.loadURL];
		[webView setDelegate:self];
		[webView loadRequest:requestObj];        
	}
}

-(void) goBack {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doCancel:(id)sender {
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UIWebView Delegates 
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	self.webView.hidden = NO;
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
	NSString *urlString = request.URL.absoluteString;
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		if([urlString isEqualToString: @"about:blank"]){
			return YES;
		}
        else {
            if ([urlString rangeOfString:@"mailto"].location != NSNotFound) {
                if ([MFMailComposeViewController canSendMail]) {
                    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
                    controller.mailComposeDelegate = self;
                    NSString *mailAddress = [urlString substringFromIndex:7];
                    NSArray *toRecipients = [NSArray arrayWithObject:mailAddress];
                    [controller setToRecipients:toRecipients];
                    [self presentModalViewController:controller animated:YES];
                    [controller release];
                } else {
                    UIAlertView* noMessaging = [[UIAlertView alloc] initWithTitle:@"Mail Error" message:@"The e-mail client for this device has not been setup." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [noMessaging show];
                    [noMessaging release];
                }
            }
            else if([urlString hasPrefix:@"http"]){
                WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];	
				webViewController.loadURL = [NSURL URLWithString:urlString];
				webViewController.title = self.title;
				[self.navigationController pushViewController:webViewController animated:YES];
				[webViewController release];
                
            }
            else if([urlString hasPrefix:@"tel:"]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Call this number?" message:urlString delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                [alert show];
                [alert release];
            }
			return NO;
		}	}	
	return YES;
}


#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *phoneNumber = alertView.message;
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"." withString:@""];
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
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
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[activityIndicatorView release];
    [webView stopLoading];
	[webView release];
	webView = nil;
    [super dealloc];
}

@end
