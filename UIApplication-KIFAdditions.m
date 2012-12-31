//
//  UIApplication-KIFAdditions.m
//  KIF
//
//  Created by Eric Firestone on 5/20/11.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "UIApplication-KIFAdditions.h"
//#import "LoadableCategory.h"
#import "UIView-KIFAdditions.h"


//MAKE_CATEGORIES_LOADABLE(UIApplication_KIFAdditions)


@implementation UIApplication (KIFAdditions)

- (UIWindow *)keyboardWindow
{
    for (UIWindow *window in self.windows) {
        if ([NSStringFromClass([window class]) isEqual:@"UITextEffectsWindow"]) {
            return window;
        }
    }
    
    return nil;
}

- (UIWindow *)pickerViewWindow
{
    for (UIWindow *window in [self windows]) {
        NSArray *pickerViews = [window subviewsWithClassNameOrSuperClassNamePrefix:@"UIPickerView"];
        if (pickerViews.count > 0) {
            return window;
        }
    }
    
    return nil;
}

@end
