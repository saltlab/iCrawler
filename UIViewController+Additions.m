#import "UIViewController+Additions.h"
#import "ICrawlTestController.h"

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
		
	}
}

- (void)icDismissModalViewControllerAnimated:(BOOL)animated {
#if RUN_ICRAWL_TEST	
	ICrawlTestController *testControl = [[ICrawlTestController alloc] init];
	[testControl viewDismissed];
    [testControl release];
#endif
    // Call the original (now renamed) dismissModalViewControllerAnimated:
    [self icDismissModalViewControllerAnimated:animated];
	
}

@end