//
//  TextViewViewController.m
//
//  Created by Mona.
//

#import "TextViewViewController.h"

@implementation TextViewViewController

@synthesize textView, buttonAdd;

-(id) initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder])) {
		
		//set up keyboard notifications
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
		
	}
	
	return self;
}

-(void) viewDidLoad {
    [super viewDidLoad];
	[textView becomeFirstResponder];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.bounds = CGRectMake(0, 0, 60.0, 30.0);
    button.accessibilityLabel = @"button back";
	[button setImage:[UIImage imageNamed:@"button_back.png"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *buttonBack = [[UIBarButtonItem alloc] initWithCustomView:button];
	self.navigationItem.leftBarButtonItem = buttonBack;
	[buttonBack release];
	
	UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
	button2.bounds = CGRectMake(0, 0, 65.0, 30.0);
    button2.accessibilityLabel = @"button done";
	[button2 setImage:[UIImage imageNamed:@"button_done.png"] forState:UIControlStateNormal];
	[button2 addTarget:self action:@selector(saveNote) forControlEvents:UIControlEventTouchUpInside];
	buttonAdd = [[UIBarButtonItem alloc] initWithCustomView:button2];
	self.navigationItem.rightBarButtonItem = buttonAdd;
	
	NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
	NSString* textViewText = [defaults objectForKey:@"textViewText"];
	if([textViewText length])
        [self.textView setText:textViewText];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	
}

- (void)goBack {
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) saveNote {
	NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
	NSString* textView1Text = textView.text;
	[defaults setObject:textView1Text forKey:@"textViewText"];
	[textView resignFirstResponder];
	
}

#pragma mark textView delegate methods

- (void)textViewDidChange:(UITextView *)_textView
{	
}
	
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[textView resignFirstResponder];
}

-(void) keyboardWillShow
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	
	[UIView commitAnimations];
}

-(void) keyboardWillHide
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	
	[UIView commitAnimations];
}


- (void)dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	
	self.textView = nil;
	[super dealloc];
}


@end
