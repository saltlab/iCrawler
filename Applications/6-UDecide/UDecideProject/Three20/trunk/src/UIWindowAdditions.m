//
//  UIWindowAdditions.m
//  Three20
//
//  Created by Mike on 10/31/09.
//  Copyright 2009 Prime31 Studios. All rights reserved.
//

#import "UIWindowAdditions.h"


@implementation UIWindow (TTCategory)

- (UIView*)findFirstResponder
{
	return [self findFirstResponderInView:self];
}


- (UIView*)findFirstResponderInView:(UIView*)topView
{
	if( [topView isFirstResponder] )
		return topView;
	
	for( UIView *subView in topView.subviews )
	{
		if( [subView isFirstResponder] )
			return subView;
		
		UIView *firstResponderCheck = [self findFirstResponderInView:subView];
		if( firstResponderCheck != nil )
			return firstResponderCheck;
	}
	return nil;
}

@end
