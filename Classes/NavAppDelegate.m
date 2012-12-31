//
//  NavAppDelegate.m
// 
//  Created by Mona on 12-03-21.
//

#import "NavAppDelegate.h"

#if RUN_ICRAWL_TEST
#import "ICrawlTestController.h"
#endif

@implementation NavAppDelegate

@synthesize window;
@synthesize navController; 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {  
	
    [window addSubview:[navController view]];
	[window makeKeyAndVisible];
	
#if RUN_ICRAWL_TEST
	[[ICrawlTestController sharedICrawlTest] start];
#endif
	 return YES;
}

- (void)dealloc {
    [window release];
    [navController release];
	
    [super dealloc];
}
@end
