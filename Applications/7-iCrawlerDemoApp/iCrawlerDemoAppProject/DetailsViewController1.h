//
//  DetailsViewController1.h
//
//  Created by Mona.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "SharedViewController.h"

@interface DetailsViewController1 : SharedViewController <UIWebViewDelegate, MFMailComposeViewControllerDelegate>{
    UILabel *Label0;
    UILabel *value2;
    UILabel *Label2;
    UILabel *value3;
    UIButton *websiteButton;
    UILabel *value1;
    UILabel *Label1;
    UILabel *value4;
    UILabel *Label4;
    UILabel *value5;
    UILabel *Label3;
    UIWebView *dummyWebView;
    UIScrollView *scrollView;
	UIButton *htmlButton;
    NSString *queryArgument;
}

@property(nonatomic, retain) IBOutlet UILabel *Label0;
@property(nonatomic, retain) IBOutlet UILabel *value1;
@property(nonatomic, retain) IBOutlet UILabel *Label1;
@property(nonatomic, retain) IBOutlet UILabel *Label3;
@property(nonatomic, retain) IBOutlet UIWebView *dummyWebView;
@property(nonatomic, retain) IBOutlet UILabel *value2;
@property(nonatomic, retain) IBOutlet UILabel *value3;
@property(nonatomic, retain) IBOutlet UILabel *Label4;
@property(nonatomic, retain) IBOutlet UILabel *value4;
@property(nonatomic, retain) IBOutlet UIButton *websiteButton;
@property(nonatomic, retain) IBOutlet UILabel *value5;
@property(nonatomic, retain) IBOutlet UILabel *Label2;
@property(nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic, retain) IBOutlet UIButton *htmlButton;
@property (nonatomic, retain) NSString *queryArgument;

- (IBAction)viewWebsite;
- (IBAction)viewHtml;
- (void)rightButtonClicked;

@end


