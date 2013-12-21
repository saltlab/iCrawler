//
//  NavigationTestAppRootViewController.h
//
//  Created by Mona.
//

#import <Foundation/Foundation.h>

@interface NavigationTestAppRootViewController : UIViewController  {
	
	UIButton *detailButton;
	UIButton *websiteButton;
	UIButton *htmlButton;
	UIButton *dynamicButton;
	UIButton *modalButton;
	UIButton *tabBarButton;
	UIButton *tableButton;
	UIButton *textViewButton;
}

@property (nonatomic, retain) IBOutlet UIButton *detailButton;
@property (nonatomic, retain) IBOutlet UIButton *websiteButton;
@property (nonatomic, retain) IBOutlet UIButton *htmlButton;
@property (nonatomic, retain) IBOutlet UIButton *dynamicButton;
@property (nonatomic, retain) IBOutlet UIButton *modalButton;
@property (nonatomic, retain) IBOutlet UIButton *tabBarButton;
@property (nonatomic, retain) IBOutlet UIButton *tableButton;
@property (nonatomic, retain) IBOutlet UIButton *textViewButton;

- (IBAction)tableButtonClicked;
- (IBAction)detailButtonClicked;
- (IBAction)websiteButtonClicked;
- (IBAction)htmlButtonClicked;
- (IBAction)tabBarButtonClicked;
- (IBAction)dynamicButtonClicked;
- (IBAction)modalButtonClicked;
- (IBAction)textViewButtonClicked;

@end