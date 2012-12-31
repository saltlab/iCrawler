//
//  UIElement.m
//
//  Created by Mona on 12-04-07. All rights reserved.
//

#import "UIElement.h"

@implementation UIElement

@synthesize className, objectClass, object, action, target, visited;

-(void)dealloc {
    [className release];
    [objectClass release];
	[object release];
	[action release];
	[target release];
    
    [super dealloc];
}

@end
