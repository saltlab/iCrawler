//
//  UIWindowAdditions.h
//  Three20
//
//  Created by Mike on 10/31/09.
//  Copyright 2009 Prime31 Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIWindow (TTCategory)

- (UIView*)findFirstResponder;

- (UIView*)findFirstResponderInView:(UIView*)topView;

@end
