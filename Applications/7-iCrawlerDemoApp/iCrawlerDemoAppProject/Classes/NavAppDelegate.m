//
//  NavAppDelegate.m
// 
//  Created by Mona.
//

#import "NavAppDelegate.h"
#import "ICrawlerController.h"


@implementation NavAppDelegate

@synthesize window;
@synthesize navController; 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {  
	
    [window addSubview:[navController view]];
	[window makeKeyAndVisible];
	
    int startTime = [[NSDate date] timeIntervalSince1970];
	NSLog(@"start Time: %i", startTime);
	[[ICrawlerController sharedICrawler] start];

	 return YES;
}

- (void)dealloc {
    [window release];
    [navController release];
	
    [super dealloc];
}
@end
