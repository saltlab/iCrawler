//
//  UIElement.h
//
//  Created by Mona on 12-04-07. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIElement : NSObject

@property(nonatomic, assign) id object;
@property(nonatomic, assign) Class objectClass;
@property(nonatomic, retain) NSString *className;
@property(nonatomic, retain) NSString *action;
@property(nonatomic, retain) NSString *monkeyId;
@property(nonatomic, retain) NSString *monkeyCommand;
@property(nonatomic, assign) id target;
@property(nonatomic, assign) bool visited;


- (void)tapUIElement;
- (void)tapView:(UIView*)view;
- (void)tapBarButton;
- (void)tapUndefinedBarButton;
- (void)tapTabBarItem;
- (void)tapTableView:(UITableView*)tableView;
- (void)scrollDownInTable;
- (void)scrollUpInTable;
- (void)tapTableCell;
- (void)scrollDownView;
- (void)scrollUpView;
- (void)writeIntoTextView;
- (void)addActionForTargetUIElement;
- (BOOL)isEqualToUIElement:(UIElement*)e;
+ (void)tapUIAlertView:(UIAlertView*)view;
+ (UIElement*)addUIElement:(id)_object;
+ (UIElement*)addNavigationItem:(UIBarButtonItem*)barButtonItem withAction:(NSString*)action;
+ (UIElement*)addNavigationItemView:(UIView*)thisBackButtonView withAction:(NSString*)action;

@end
