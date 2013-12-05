// =======================================
// = Interface for UIViewController+Additions =
// =======================================
@interface UIViewController (additions)

+ (void)load;
- (void)icDismissModalViewControllerAnimated:(BOOL)animated;
- (void)icPresentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated;
- (BOOL)isViewDismissed;
- (BOOL)isViewPresented;

@end
