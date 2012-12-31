//
//  DetailsViewController1.h
//
//  Created by Mona on 12-03-21.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "SharedViewController.h"

@interface DetailsViewController1 : SharedViewController <UIWebViewDelegate, MFMailComposeViewControllerDelegate>{
    UILabel *companyNameLabel;
    UILabel *addressLabel;
    UILabel *addressTitleLabel;
    UILabel *cityStateLabel;
    UILabel *zipCodeLabel;
    UIButton *websiteButton;
    UILabel *boothNumberLabel;
    UILabel *boothNumberTitleLabel;
    UILabel *mainContactNameLabel;
    UILabel *mainContactEmailLabel;
    UILabel *mainContactPhoneNumberLabel;
    UILabel *mainContactLabel;
    UILabel *mainContactTitleLabel;
    UILabel *infoLabel;
    UIButton *emailButton;
    UIButton *phoneNumberButton;
    UIWebView *companyBioWebView;
    UIScrollView *scrollView;
	UIButton *htmlButton;
    NSString *queryArgument;
}

@property(nonatomic, retain) IBOutlet UILabel *companyNameLabel;
@property(nonatomic, retain) IBOutlet UILabel *boothNumberLabel;
@property(nonatomic, retain) IBOutlet UILabel *boothNumberTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel *infoLabel;
@property(nonatomic, retain) IBOutlet UIWebView *companyBioWebView;
@property(nonatomic, retain) IBOutlet UILabel *addressLabel;
@property(nonatomic, retain) IBOutlet UILabel *cityStateLabel;
@property(nonatomic, retain) IBOutlet UILabel *mainContactLabel;
@property(nonatomic, retain) IBOutlet UILabel *mainContactNameLabel;
@property(nonatomic, retain) IBOutlet UILabel *mainContactEmailLabel;
@property(nonatomic, retain) IBOutlet UILabel *mainContactPhoneNumberLabel;
@property(nonatomic, retain) IBOutlet UIButton *emailButton;
@property(nonatomic, retain) IBOutlet UIButton *phoneNumberButton;
@property(nonatomic, retain) IBOutlet UILabel *zipCodeLabel;
@property(nonatomic, retain) IBOutlet UIButton *websiteButton;
@property(nonatomic, retain) IBOutlet UILabel *mainContactTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel *addressTitleLabel;
@property(nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic, retain) IBOutlet UIButton *htmlButton;
@property (nonatomic, retain) NSString *queryArgument;

- (IBAction)callContact;
- (IBAction)emailContact;
- (IBAction)viewWebsite;
- (IBAction)viewHtml;

- (void)styleViews;
- (void)callNumber:(NSString*)phoneNumber;
- (void)rightButtonClicked;

@end


