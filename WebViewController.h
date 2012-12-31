//
//  WebViewController.h
//
//  Created by Mona on 12-03-21.
//


#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface WebViewController : UIViewController <UIWebViewDelegate, MFMailComposeViewControllerDelegate>{
	NSURL *loadURL;
    NSString *url;

	UIWebView *webView;
    UIView *activityIndicatorView;
    
    bool disableFailedLoadError;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIView *activityIndicatorView;

@property (nonatomic, retain) NSURL *loadURL;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, assign) bool disableFailedLoadError;

@end
