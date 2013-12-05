// =======================================
// = Interface for UINavigationController+Additions =
// =======================================
@interface UINavigationController (additions)

+ (void)load;
- (void)icPushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (UIViewController *)icPopViewControllerAnimated:(BOOL)animated;
- (id)icInitWithRootViewController:(UIViewController *)rootViewController; // Convenience method pushes the root view controller without animation.
- (NSArray *)icPopToRootViewControllerAnimated:(BOOL)animated; // Pops until there's only a single view controller left on the stack. Returns the popped controllers.
- (BOOL)isViewPushed;
- (BOOL)isViewPoped;

@end
