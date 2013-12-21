//
//  HTMLPageViewController.h
//
//  Created by Mona.
//

#import <UIKit/UIKit.h>

@interface HTMLPageViewController : UIViewController <UIWebViewDelegate>{
	UIWebView *infoWebView;
	UIScrollView *scrollView;
	NSString *filename;
	NSString *filetype;
	NSString *htmlString;
	BOOL leaveRoomForNavBar;
	BOOL leaveRoomForTabBar;
}

@property(nonatomic,retain) IBOutlet UIWebView *infoWebView;
@property(nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain) NSString *filename;
@property(nonatomic,retain) NSString *filetype;
@property(nonatomic, retain) NSString *htmlString;
@property(nonatomic, assign) BOOL leaveRoomForNavBar;
@property(nonatomic, assign) BOOL leaveRoomForTabBar;
 
- (NSString *)formatHTMLStringFor:(NSString *)thisArticle withContent:(NSString *)content;

@end
