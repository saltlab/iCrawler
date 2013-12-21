//
//  DynamicViewController.h
//
//  Created by Mona on 12-03-21.
//

#import <UIKit/UIKit.h>

@interface DynamicViewController : UIViewController <UIWebViewDelegate>{
	
	UIImageView *imageView;
	UIButton *btnSite; 
	UILabel *phoneNumber;
}

@property(nonatomic,retain) UIImageView *imageView;
@property(nonatomic, retain) UIButton *btnSite;
@property(nonatomic, retain) UILabel *phoneNumber; 

- (IBAction)loadDynamicViews;
- (IBAction)unloadDynamicViews;
- (IBAction)hideDynamicViews;
- (IBAction)unhideDynamicViews;
- (IBAction)loadUrl;

@end
