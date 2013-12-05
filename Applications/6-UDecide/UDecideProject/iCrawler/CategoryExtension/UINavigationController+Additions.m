
#import "UINavigationController+Additions.h"
#import "ICrawlerController.h"

// =======================================
// = Implementation for UINavigationController+Additions =
// =======================================
@implementation UINavigationController (additions)

+ (void)load {
    if (self == [UINavigationController class]) {
        
        Method originalMethod =
        class_getInstanceMethod(self, @selector(pushViewController:animated:));
        Method replacedMethod =
        class_getInstanceMethod(self, @selector(icPushViewController:animated:));
        method_exchangeImplementations(originalMethod, replacedMethod);
        
        originalMethod =
        class_getInstanceMethod(self, @selector(popViewControllerAnimated:));
        replacedMethod =
        class_getInstanceMethod(self, @selector(icPopViewControllerAnimated:));
        method_exchangeImplementations(originalMethod, replacedMethod);
        
        originalMethod =
        class_getInstanceMethod(self, @selector(initWithRootViewController:));
        replacedMethod =
        class_getInstanceMethod(self, @selector(icInitWithRootViewController:));
        method_exchangeImplementations(originalMethod, replacedMethod);
        
        originalMethod =
        class_getInstanceMethod(self, @selector(popToRootViewControllerAnimated:));
        replacedMethod =
        class_getInstanceMethod(self, @selector(icPopToRootViewControllerAnimated:));
        method_exchangeImplementations(originalMethod, replacedMethod);
        
	}
}

- (void)icPushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IC_isInitWithRoot"])
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IC_isInitWithRoot"];
    else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IC_isPushed"];
    }
    // Call the original (now renamed) pushViewController:
    [self icPushViewController:viewController animated:animated];
}

- (UIViewController *)icPopViewControllerAnimated:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IC_isPoped"];
    // Call the original (now renamed) popViewControllerAnimated:
    return [self icPopViewControllerAnimated:animated];
}

- (id)icInitWithRootViewController:(UIViewController *)rootViewController {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IC_isInitWithRoot"];
    // Call the original (now renamed) initWithRootViewController:
    return [self icInitWithRootViewController:rootViewController];
}

- (NSArray *)icPopToRootViewControllerAnimated:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IC_isPopedToRoot"];
   // Call the original (now renamed) popToRootViewControllerAnimated:
    return [self icPopToRootViewControllerAnimated:animated];
}

- (BOOL)isViewPushed {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IC_isPushed"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IC_isPushed"];
		return TRUE;
	}
	return FALSE;
}

- (BOOL)isViewPoped {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IC_isPopedToRoot"])
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IC_isPopedToRoot"];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IC_isPoped"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IC_isPoped"];
		return TRUE;
	}
	return FALSE;
}


@end