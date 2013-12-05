
#import "UINavigationBar+Additions.h"
#import "ICrawlerController.h"

// =======================================
// = Implementation for UINavigationBar+Additions =
// =======================================
@implementation UINavigationBar (additions)

+ (void)load {
    if (self == [UINavigationBar class]) {
        Method originalMethod = 
			class_getInstanceMethod(self, @selector(pushNavigationItem:animated:));
        Method replacedMethod = 
			class_getInstanceMethod(self, @selector(icPushNavigationItem:animated:));
        method_exchangeImplementations(originalMethod, replacedMethod);
	}
}

- (void)icPushNavigationItem:(UINavigationItem *)item animated:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IC_barButtonAdded"];
    [ICrawlerController sharedICrawler].navItem = item;

    // Call the original (now renamed) pushNavigationItem:animated:
    [self icPushNavigationItem:item animated:animated];
}


@end