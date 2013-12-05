//
//  UDecideAppDelegate.m
//  UDecide
//
//  Created by acs on 10/12/08.
//  Copyright ACS Technologies 2008. All rights reserved.
//

#import "UDecideAppDelegate.h"
#import "RootViewController.h"

//#if RUN_ICRAWL_TEST
#import "ICrawlerController.h"
//#endif

@implementation UDecideAppDelegate

@synthesize window;
@synthesize rootViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	[window addSubview:[rootViewController view]];
	[window makeKeyAndVisible];
	
//#if RUN_ICRAWL_TEST
	int startTime = [[NSDate date] timeIntervalSince1970];
	NSLog(@"start Time: %i", startTime);
	
	[[ICrawlerController sharedICrawler] start];
//#endif
}


- (void)dealloc {
	[rootViewController release];
	[window release];
	[super dealloc];
}

@end
