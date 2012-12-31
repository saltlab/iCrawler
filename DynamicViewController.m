//
//  DynamicViewController.m
//
//  Created by Mona on 12-03-21.
//

#import "DynamicViewController.h"
#import "WebViewController.h"

@implementation DynamicViewController

@synthesize imageView, phoneNumber, btnSite;

- (void)viewDidLoad {  
	[super viewDidLoad];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
    
	UIButton *btnLoad = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[btnLoad addTarget:self action:@selector(loadDynamicViews) forControlEvents:UIControlEventTouchUpInside];
	[btnLoad setTitle:@"Load!" forState:UIControlStateNormal];
	btnLoad.frame = CGRectMake(25,250,95,45);
	[self.view addSubview:btnLoad];
	
	UIButton *btnUnload = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[btnUnload addTarget:self action:@selector(unloadDynamicViews) forControlEvents:UIControlEventTouchUpInside];
	[btnUnload setTitle:@"Unload!" forState:UIControlStateNormal];
	btnUnload.frame = CGRectMake(200,250,95,45);
	[self.view addSubview:btnUnload];
	
	UIButton *btnHide = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[btnHide addTarget:self action:@selector(hideDynamicViews) forControlEvents:UIControlEventTouchUpInside];
	[btnHide setTitle:@"Hide!" forState:UIControlStateNormal];
	btnHide.frame = CGRectMake(25,350,95,45);
	[self.view addSubview:btnHide];
	
	UIButton *btnUnhide = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[btnUnhide addTarget:self action:@selector(unhideDynamicViews) forControlEvents:UIControlEventTouchUpInside];
	[btnUnhide setTitle:@"Unhide!" forState:UIControlStateNormal];
	btnUnhide.frame = CGRectMake(200,350,95,45);
	[self.view addSubview:btnUnhide];
	
	/*
	//Add back button to navigation bar
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.bounds = CGRectMake(0, 0, 60.0, 30.0);
	button.accessibilityLabel = @"button back";
	[button setImage:[UIImage imageNamed:@"button_back.png"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *buttonHome = [[UIBarButtonItem alloc] initWithCustomView:button];
	self.navigationItem.leftBarButtonItem = buttonHome;*/
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

#pragma mark -
#pragma mark IBAction 

- (IBAction)loadDynamicViews{
	
	if ([self.view.subviews containsObject:imageView])
		[imageView setHidden:NO];
	else {
		CGRect myImageRect = CGRectMake(10,10,300,100);
		imageView = [[UIImageView alloc] initWithFrame:myImageRect];
		[imageView setImage:[UIImage imageNamed:@"checkmarkControllerIcon.png"]];
		[self.view addSubview:imageView];
		[imageView release]; 
	}
	
	if ([self.view.subviews containsObject:phoneNumber])
		[phoneNumber setHidden:NO];
	else {
		CGRect myLabelRect = CGRectMake(112,150,120,22);
		phoneNumber=[[UILabel alloc] initWithFrame:myLabelRect];
		phoneNumber.text=@"937-350-5645";
		phoneNumber.textColor=[UIColor blueColor];
		phoneNumber.font= [UIFont fontWithName:@"ComicSansMsBold" size:18];
		[self.view addSubview:phoneNumber];
	}
	
	if ([self.view.subviews containsObject:btnSite])
	[btnSite setHidden:NO];
	else {
		btnSite = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[btnSite addTarget:self action:@selector(loadUrl) forControlEvents:UIControlEventTouchUpInside];
		[btnSite setTitle:@"http://www.ubc.ca/" forState:UIControlStateNormal];
		btnSite.frame = CGRectMake(10,200,300,22);
		[self.view addSubview:btnSite];
	}
}

- (IBAction)unloadDynamicViews{
	
	if ([self.view.subviews containsObject:imageView])
		[imageView removeFromSuperview];
	
	if ([self.view.subviews containsObject:phoneNumber])
		[phoneNumber removeFromSuperview];
	
	if ([self.view.subviews containsObject:btnSite]) 
		[btnSite removeFromSuperview];
}

- (IBAction)hideDynamicViews{
	
	if ([self.view.subviews containsObject:imageView])
		[imageView setHidden:YES];
	
	if ([self.view.subviews containsObject:phoneNumber])
		[phoneNumber setHidden:YES];
	
	if ([self.view.subviews containsObject:btnSite])
		[btnSite setHidden:YES];
}

- (IBAction)unhideDynamicViews{
	
	if ([self.view.subviews containsObject:imageView])
		[imageView setHidden:NO];
	
	if ([self.view.subviews containsObject:phoneNumber])
		[phoneNumber setHidden:NO];
	
	if ([self.view.subviews containsObject:btnSite])
		[btnSite setHidden:NO];
}

- (IBAction)loadUrl {
    WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
	webViewController.title = @"Website";
    webViewController.loadURL = [NSURL URLWithString:@"http://www.ubc.ca/"];
    [self.navigationController pushViewController:webViewController animated:YES];	
	[webViewController release];
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
