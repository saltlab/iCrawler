//
//  DetailsViewController1.m
//
//  Created by Mona on 12-03-21.
//

#import "DetailsViewController1.h"
#import "WebViewController.h"
#import "HTMLPageViewController.h"

@implementation DetailsViewController1

@synthesize companyNameLabel, boothNumberLabel, mainContactNameLabel, mainContactEmailLabel, mainContactPhoneNumberLabel, mainContactLabel;
@synthesize mainContactTitleLabel, zipCodeLabel, infoLabel, addressTitleLabel, boothNumberTitleLabel, addressLabel, cityStateLabel;
@synthesize queryArgument, companyBioWebView, scrollView; 
@synthesize emailButton, phoneNumberButton, websiteButton, htmlButton;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self styleViews];
    
    companyNameLabel.text = @"Company Name Value";
    boothNumberLabel.text = @"Booth Number Value";
    
    companyBioWebView.delegate = self;
	companyBioWebView.backgroundColor = [UIColor clearColor];
    companyBioWebView.opaque = NO;
    [companyBioWebView loadHTMLString:[NSString stringWithFormat:@"<html><head><style>body {font-family: helvetica,arial,sans-serif; font-size:14px; line-height:1.4em; color:%@; text-decoration: none;}</style></head><body>%@</body></html>",[UIColor blackColor], @"Content"] baseURL:nil];
    
    //Company Address
    addressLabel.text = @"Address Value";
    cityStateLabel.text = @"City State Value";
	zipCodeLabel.text = @"Zip Code Value";
      
    //Main Contact views
    mainContactNameLabel.text = [NSString stringWithFormat:@"%@ %@", @"First Name", @"Last Name"];
    mainContactTitleLabel.text = @"Title";
    [phoneNumberButton setHidden:YES];
	[emailButton setHidden:YES];
    websiteButton.hidden = NO;
	
	//add back button if presented
	if ([self.queryArgument isEqual:@"push"]) {
		UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
		button1.frame = CGRectMake(0, 0, 60, 34.0);
		[button1 setImage:[UIImage imageNamed:@"button_back.png"] forState:UIControlStateNormal];
		[button1 addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *buttonAdd1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
		self.navigationItem.leftBarButtonItem = buttonAdd1;
	} 
	//add right button
	if ([self.title isEqualToString:@"Detail"]) {
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(0, 0, 60, 34.0);
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

#pragma mark -
#pragma mark IBAction 

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

- (IBAction)callContact {
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Call this number?" message:@"6047777777" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
	[alert show];
	[alert release];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self callNumber:@"6047777777"];
    }
} 

- (void)callNumber:(NSString*)phoneNumber {
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"." withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    
    NSString *telString = [NSString stringWithFormat:@"tel:%@", phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
}

- (IBAction)emailContact{
    if ([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
		
		controller.mailComposeDelegate = self;
        controller.navigationBar.tintColor = [UIColor blackColor];
		NSArray *recepients = [[NSArray alloc] initWithObjects:@"a@a.com", nil];
        
        [controller setToRecipients:recepients];
        [self presentModalViewController:controller animated:YES];
        [controller release];
        [recepients release];
        
	}
	else {
		[self.navigationController setNavigationBarHidden:NO animated:NO]; 
		UIAlertView* noMessaging = [[UIAlertView alloc] initWithTitle:@"Mail Error" message:@"The e-mail client for this device has not been setup." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[noMessaging show];
		[noMessaging release];
	}
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    // Notifies users about errors associated with the interface
	switch (result) {
		case MFMailComposeResultSent: {
        }
		default: {
        }
			
		break;
	}

	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
	
}

#pragma mark -
#pragma mark UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [webView sizeToFit];
    CGRect frame = webView.frame;
    
    [scrollView setContentSize:CGSizeMake(frame.size.width,  frame.origin.y + frame.size.height + 110)];
    mainContactLabel.frame =  CGRectMake(frame.origin.x, frame.origin.y + frame.size.height + 5, 300, 20);
    mainContactNameLabel.frame = CGRectMake(mainContactLabel.frame.origin.x, mainContactLabel.frame.origin.y + mainContactLabel.frame.size.height, 300, 20);
    mainContactTitleLabel.frame = CGRectMake(mainContactNameLabel.frame.origin.x, mainContactNameLabel.frame.origin.y + mainContactNameLabel.frame.size.height, 300, 20);
    emailButton.frame = CGRectMake(mainContactTitleLabel.frame.origin.x, mainContactTitleLabel.frame.origin.y  + mainContactNameLabel.frame.size.height, 150, 40);
    phoneNumberButton.frame = CGRectMake(emailButton.frame.origin.x + emailButton.frame.size.width + 5, emailButton.frame.origin.y, 150, 40);
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

