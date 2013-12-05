// =======================================
// = Interface for UINavigationBar+Additions =
// =======================================
@interface UINavigationBar (additions)

+ (void)load;
- (void)icPushNavigationItem:(UINavigationItem *)item animated:(BOOL)animated;

@end
