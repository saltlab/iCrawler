
#import "UIViewController+Additions.h"
#import "ICrawlerController.h"

// =======================================
// = Implementation for UIViewController+Additions =
// =======================================
@implementation UIViewController (additions)

+ (void)load {
    if (self == [UIViewController class]) {
        
        Method originalMethod = 
			class_getInstanceMethod(self, @selector(dismissModalViewControllerAnimated:));
        Method replacedMethod = 
			class_getInstanceMethod(self, @selector(icDismissModalViewControllerAnimated:));
        method_exchangeImplementations(originalMethod, replacedMethod);
        
        originalMethod =
        class_getInstanceMethod(self, @selector(presentModalViewController:animated:));
        replacedMethod =
        class_getInstanceMethod(self, @selector(icPresentModalViewController:animated:));
        method_exchangeImplementations(originalMethod, replacedMethod);
	}
}

- (void)icDismissModalViewControllerAnimated:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IC_isDismissed"];
    // Call the original (now renamed) dismissModalViewControllerAnimated:
    [self icDismissModalViewControllerAnimated:animated];
}

- (void)icPresentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IC_isPresented"];
    // Call the original (now renamed) presentModalViewController:
    [self icPresentModalViewController:modalViewController animated:animated];
}

- (BOOL)isViewDismissed {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IC_isDismissed"]) {
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IC_isDismissed"];
		return TRUE;
	}
	return FALSE;
}

- (BOOL)isViewPresented {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IC_isPresented"]) {
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IC_isPresented"];
		return TRUE;
	}
	return FALSE;
}


@end