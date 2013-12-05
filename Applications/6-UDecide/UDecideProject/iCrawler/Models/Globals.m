//
//  Globals.m
//
//  Created by Mona on 12-04-07. All rights reserved.
//

#import "Globals.h"

@implementation Globals

static Globals *sharedInstance = nil;

@synthesize statesArray, xmlNodesArray;

+ (Globals*)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[Globals alloc] init];
    }
    return sharedInstance;
}

+ (void)setSharedInstance:(Globals*)globals {
    sharedInstance = globals;
}

-(void)dealloc {
    [statesArray release];
	[xmlNodesArray release];
	
    [super dealloc];
}

@end
