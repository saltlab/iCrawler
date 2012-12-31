//
//  State.m
//
//  Created by Mona on 12-04-07. All rights reserved.
//

#import "State.h"

@implementation State

@synthesize uiElementsArray, selfViewController, stateIndex, visitedStateIndex;

-(void)dealloc {
	[uiElementsArray release];
	[selfViewController release];
	
	[super dealloc];
}

@end
