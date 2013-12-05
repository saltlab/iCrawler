//
//  UIElement.m
//
//  Created by Mona on 12-04-07. All rights reserved.
//

#import "UIElement.h"
#import "State.h"
#import "ICrawlerController.h"
#import "ICConstants.h"
#import "UIView-KIFAdditions.h"
#import "CGGeometry-KIFAdditions.h"
#import "KIFTestStep.h"
#import "OutputComponent.h"
#import "UIViewController+Additions.h"
#import "UINavigationController+Additions.h"

@implementation UIElement

@synthesize className, objectClass, object, action, target, visited, monkeyId, monkeyCommand;


#pragma mark -
#pragma mark Tap Methods
- (void)tapUIElement {
    UIView * view = (UIView *)self.object;
	if (!view.hidden && view.userInteractionEnabled){
        
        if ([view.superview isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scroll = (UIScrollView*)view.superview;
            CGPoint bottomOffset = CGPointMake(0, view.frame.origin.y);
            [scroll setContentOffset:bottomOffset animated:YES];
            [self performSelector:@selector(tapView:) withObject:view afterDelay:INTER_ACTION_SHORT_DELAY];
        }
        else
            [self tapView:view];
    }
}

- (void)tapView:(UIView*)view {
    UIViewController *currentViewController = [[ICrawlerController sharedICrawler] currentViewController];
	UINavigationController *thisNav = currentViewController.navigationController;
	
    [view tap];
    
    if ([thisNav isViewPoped])
        [self performSelector:@selector(runAutoTestingApp:) withObject:BACK_BUTTON_CLICKED afterDelay:INTER_ACTION_SHORT_DELAY];
    else if ([currentViewController isViewDismissed])
        [[ICrawlerController sharedICrawler] performSelector:@selector(runAutoTestingApp:) withObject:BACK_BUTTON_CLICKED afterDelay:INTER_ACTION_SHORT_DELAY];
    else
        [[ICrawlerController sharedICrawler] performSelector:@selector(runAutoTestingApp:) withObject:NEXT_ACTION_CLICKED afterDelay:INTER_ACTION_SHORT_DELAY];
}

- (void)tapBarButton {
	UIViewController *currentViewController = [[ICrawlerController sharedICrawler] currentViewController];
	UINavigationController *thisNav = currentViewController.navigationController;
	UITabBarController *thisTabBarController = (UITabBarController*)currentViewController.tabBarController;
	UIBarButtonItem *barItem = (UIBarButtonItem *)self.object;
	
	if ([thisNav.viewControllers count]==1 && [thisNav.viewControllers objectAtIndex:0]==currentViewController && thisTabBarController!=nil) {
		UITabBarItem *thisTabBarItem = (UITabBarItem*)currentViewController.tabBarItem;
		if (thisTabBarItem) {
			if (thisTabBarController.selectedIndex < ([thisTabBarController.viewControllers count] - 1)) {
				thisTabBarController.selectedIndex = thisTabBarController.selectedIndex + 1;
				[[ICrawlerController sharedICrawler] getPreviousStateAndViewController];
				UIElement *element = [[ICrawlerController sharedICrawler].currentState returnUITabBarElementForState];
				if (element){
					[element tapTabBarItem];
                    return;
                }
			}
			[[ICrawlerController sharedICrawler] getPreviousStateAndViewController];
		}
	}
	
	if (barItem.customView) {
		UIView * view = (UIView *)barItem.customView;
		[view tap];
	}
	else if (barItem.target && barItem.action)
		[barItem.target performSelector:barItem.action];
	
	if ([thisNav isViewPoped])
		[[ICrawlerController sharedICrawler] performSelector:@selector(runAutoTestingApp:) withObject:BACK_BUTTON_CLICKED afterDelay:INTER_ACTION_SHORT_DELAY];
	else if ([currentViewController isViewDismissed])
		[[ICrawlerController sharedICrawler] performSelector:@selector(runAutoTestingApp:) withObject:BACK_BUTTON_CLICKED afterDelay:INTER_ACTION_SHORT_DELAY];
	
    else
		[[ICrawlerController sharedICrawler] performSelector:@selector(runAutoTestingApp:) withObject:NEXT_ACTION_CLICKED afterDelay:INTER_ACTION_SHORT_DELAY];
}

- (void)tapUndefinedBarButton {
    UIViewController *currentViewController = [[ICrawlerController sharedICrawler] currentViewController];
	UINavigationController *thisNav = currentViewController.navigationController;
	UITabBarController *thisTabBarController = (UITabBarController*)currentViewController.tabBarController;
	UIView * view = (UIView *)self.object;
    
    if ([thisNav.viewControllers count]==1 && [thisNav.viewControllers objectAtIndex:0]==currentViewController && thisTabBarController!=nil) {
		UITabBarItem *thisTabBarItem = (UITabBarItem*)currentViewController.tabBarItem;
		if (thisTabBarItem) {
			if (thisTabBarController.selectedIndex < ([thisTabBarController.viewControllers count] - 1)) {
				thisTabBarController.selectedIndex = thisTabBarController.selectedIndex + 1;
				[[ICrawlerController sharedICrawler] getPreviousStateAndViewController];
				UIElement *element = [[ICrawlerController sharedICrawler].currentState returnUITabBarElementForState];
				if (element){
					[element tapTabBarItem];
                    return;
                }
			}
			[[ICrawlerController sharedICrawler] getPreviousStateAndViewController];
		}
	}
	
	if (!view.hidden){
		[view tap];
		
		if ([thisNav isViewPoped])
			[[ICrawlerController sharedICrawler] performSelector:@selector(runAutoTestingApp:) withObject:BACK_BUTTON_CLICKED afterDelay:INTER_ACTION_SHORT_DELAY];
		else if ([currentViewController isViewDismissed])
			[[ICrawlerController sharedICrawler] performSelector:@selector(runAutoTestingApp:) withObject:BACK_BUTTON_CLICKED afterDelay:INTER_ACTION_SHORT_DELAY];
		else
			[[ICrawlerController sharedICrawler] performSelector:@selector(runAutoTestingApp:) withObject:NEXT_ACTION_CLICKED afterDelay:INTER_ACTION_SHORT_DELAY];
	}
}

- (void)tapTabBarItem {
	UITabBar *tabBar = (UITabBar*)self.object;
	
	if (!tabBar.hidden && tabBar.userInteractionEnabled) {
		UITabBarItem *item = tabBar.selectedItem;
		UIView *itemView = [item valueForKey:@"_view"];
		if (itemView) {
			[itemView tap];
            [[ICrawlerController sharedICrawler] performSelector:@selector(runAutoTestingApp:) withObject:NEXT_ACTION_CLICKED afterDelay:INTER_ACTION_SHORT_DELAY];
		}
	}
}

- (void)scrollDownInTable {
	UITableView *tableView = (UITableView*)self.object;
	if (!tableView.hidden && tableView.userInteractionEnabled) {
        if ([tableView numberOfSections]>0 && [tableView numberOfRowsInSection:[tableView numberOfSections]-1]>0) {
            if ([tableView.superview isKindOfClass:[UIScrollView class]]){
                UIScrollView* scroll = (UIScrollView*)tableView.superview;
                CGPoint bottomOffset = CGPointMake(0, tableView.frame.origin.y);
                [scroll setContentOffset:bottomOffset animated:YES];
                [self performSelector:@selector(tapTableView:) withObject:tableView afterDelay:INTER_ACTION_SHORT_DELAY];
            }
            else
                [self tapTableView:tableView];
        }
        else
            [[ICrawlerController sharedICrawler] performSelector:@selector(runAutoTestingApp:) withObject:NO_ACTION_CLICKED afterDelay:INTER_ACTION_SHORT_DELAY];
	}
	else
		[[ICrawlerController sharedICrawler] performSelector:@selector(runAutoTestingApp:) withObject:NO_ACTION_CLICKED afterDelay:INTER_ACTION_SHORT_DELAY];
}

- (void)tapTableView:(UITableView*)tableView {
	NSIndexPath* indexPath = [NSIndexPath indexPathForRow: [tableView numberOfRowsInSection:[tableView numberOfSections]-1]-1 inSection: [tableView numberOfSections]-1];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition: UITableViewScrollPositionTop animated: YES];
    [self performSelector:@selector(scrollUpInTable) withObject:nil afterDelay:INTER_ACTION_SHORT_DELAY];
}

- (void)scrollUpInTable {
	UITableView *tableView = (UITableView*)self.object;
	
	if (!tableView.hidden && tableView.userInteractionEnabled && tableView.scrollEnabled) {
		NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
		[tableView scrollToRowAtIndexPath:indexPath atScrollPosition: UITableViewScrollPositionTop animated: YES];
		[self performSelector:@selector(tapTableCell) withObject:nil afterDelay:INTER_ACTION_SHORT_DELAY];
	}
	else
		[self tapTableCell];
}

- (void)tapTableCell {
	UITableView *tableView = (UITableView*)self.object;
	
	if (tableView.allowsSelection) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		if ([[[ICrawlerController sharedICrawler] currentViewController] respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
			CGRect cellFrame = [cell.contentView convertRect:[cell.contentView frame] toView:tableView];
			[tableView tapAtPoint:CGPointCenteredInRect(cellFrame)];
            [[ICrawlerController sharedICrawler] performSelector:@selector(runAutoTestingApp:) withObject:NEXT_ACTION_CLICKED afterDelay:INTER_ACTION_LONG_DELAY];
		}
		else if ([[[ICrawlerController sharedICrawler] currentViewController] respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)]) {
			UIView  *accessoryView = [cell valueForKey:@"_accessoryView"];
			[accessoryView tap];
            [[ICrawlerController sharedICrawler] performSelector:@selector(runAutoTestingApp:) withObject:NEXT_ACTION_CLICKED afterDelay:INTER_ACTION_LONG_DELAY];
		}
		else
            [[ICrawlerController sharedICrawler] performSelector:@selector(runAutoTestingApp:) withObject:NO_ACTION_CLICKED afterDelay:INTER_ACTION_SHORT_DELAY];
	}
}

- (void)scrollDownView {
	UIScrollView *scrollView = (UIScrollView*)self.object;
	
	if (!scrollView.hidden && scrollView.userInteractionEnabled && scrollView.scrollEnabled) {
		CGPoint bottomOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.bounds.size.height);
		[scrollView setContentOffset:bottomOffset animated:YES];
		[self performSelector:@selector(scrollUpView) withObject:nil afterDelay:(INTER_ACTION_SHORT_DELAY)];
	}
	else
		[[ICrawlerController sharedICrawler] performSelector:@selector(runAutoTestingApp:) withObject:NO_ACTION_CLICKED afterDelay:(INTER_ACTION_SHORT_DELAY)];
}

- (void)scrollUpView {
	UIScrollView *scrollView = (UIScrollView*)self.object;
	
	if (!scrollView.hidden && scrollView.userInteractionEnabled && scrollView.scrollEnabled) {
		CGPoint topOffset = CGPointMake(0,0);
		[scrollView setContentOffset:topOffset animated:YES];
		[[ICrawlerController sharedICrawler] performSelector:@selector(runAutoTestingApp:) withObject:NO_ACTION_CLICKED afterDelay:(INTER_ACTION_SHORT_DELAY)];
	}
	else
		[[ICrawlerController sharedICrawler] performSelector:@selector(runAutoTestingApp:) withObject:NO_ACTION_CLICKED afterDelay:(INTER_ACTION_SHORT_DELAY)];
}

- (void)writeIntoTextView {
	NSString *text = @"This is a test!";
	UIView * view = (UIView *)self.object;
	if ([view isKindOfClass:[UITextView class]]) {
		CGRect elementFrame = [view.window convertRect:self.accessibilityFrame toView:view];
		CGPoint tappablePointInElement = [view tappablePointInRect:elementFrame];
		[view tapAtPoint:tappablePointInElement];
	}
	else if ([view isKindOfClass:[UITextField class]]) {
		UITextField *thisTextField = (UITextField *)view;
		if (thisTextField.keyboardType == UIKeyboardTypeNumbersAndPunctuation || thisTextField.keyboardType == UIKeyboardTypeNumberPad || thisTextField.keyboardType == UIKeyboardTypePhonePad)
			text = @"12345";
		else if (thisTextField.keyboardType == UIKeyboardTypeEmailAddress)
			text = @"mona@ece.com";
		else if (thisTextField.keyboardType == UIKeyboardTypeURL)
			text = @"http://ece.ubc.com";
		
		CGRect elementFrame = view.frame;
		CGPoint tappablePointInElement = CGPointCenteredInRect(elementFrame);
		[view tapAtPoint:tappablePointInElement];
	}
	
	// Wait for the keyboard
	CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.5, false);
	
	for (NSUInteger characterIndex = 0; characterIndex < [text length]; characterIndex++) {
		NSString *characterString = [text substringWithRange:NSMakeRange(characterIndex, 1)];
		
		if (![KIFTestStep _enterCharacter:characterString]) {
			// Attempt to cheat if we couldn't find the character
			if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]]) {
				[(UITextField *)view setText:[[(UITextField *)view text] stringByAppendingString:characterString]];
			}
		}
	}
	
    UIViewController *currentViewController = [[ICrawlerController sharedICrawler] currentViewController];
	UINavigationController *thisNav = currentViewController.navigationController;
	
    // tap enter or done button on keyboard
	if ([currentViewController respondsToSelector:@selector(textFieldShouldReturn:)])
		[currentViewController performSelector:@selector(textFieldShouldReturn:) withObject:view afterDelay:INTER_ACTION_SHORT_DELAY];
	
	if ([thisNav isViewPoped])
		[[ICrawlerController sharedICrawler] performSelector:@selector(runAutoTestingApp:) withObject:BACK_BUTTON_CLICKED afterDelay:INTER_ACTION_SHORT_DELAY];
	else if ([currentViewController isViewDismissed])
		[[ICrawlerController sharedICrawler] performSelector:@selector(runAutoTestingApp:) withObject:BACK_BUTTON_CLICKED afterDelay:INTER_ACTION_SHORT_DELAY];
	else
        [[ICrawlerController sharedICrawler] performSelector:@selector(runAutoTestingApp:) withObject:NEXT_ACTION_CLICKED afterDelay:INTER_ACTION_SHORT_DELAY];
}

+ (void)tapUIAlertView:(UIAlertView*)view {
    [view dismissWithClickedButtonIndex:view.cancelButtonIndex animated:NO];
    [[ICrawlerController sharedICrawler] performSelector:@selector(runAutoTestingApp:) withObject:@"" afterDelay:INTER_ACTION_SHORT_DELAY];
}

#pragma mark -
#pragma mark Monkey Methods

- (void)setMonkeyIdForView:(UIView*)subview {
    
    self.monkeyCommand = @"ERROR";
    //If the button has a label, it is used as the monkeyId.
    if ([subview isKindOfClass:[UIButton class]]) {
        
        UIButton* btnView = (UIButton*)subview;
        
        if (btnView.currentTitle && ![btnView.currentTitle isEqualToString:@""])
            self.monkeyId = btnView.currentTitle;
        
        else if (btnView.titleLabel.text && ![btnView.titleLabel.text isEqualToString:@""])
            self.monkeyId = btnView.titleLabel.text;
        
        else if (subview.accessibilityLabel && ![subview.accessibilityLabel isEqualToString:@""])
            self.monkeyId = subview.accessibilityLabel;
        
        else
            self.monkeyId = [self getMonkeyIndexForButton:btnView];
        
        self.monkeyCommand = [NSString stringWithFormat:@"Button \"%@\" Tap", self.monkeyId];
    }
    else if ([subview isKindOfClass:[UISegmentedControl class]]) {
        self.monkeyId = [[subview accessibilityLabel] isEqualToString:@""] ? @"ButtonSelector" : [subview accessibilityLabel];
        self.monkeyCommand = [NSString stringWithFormat:@"ButtonSelector \"%@\" Tap", self.monkeyId];
    }
    else if ([subview isKindOfClass:[UIDatePicker class]]) {
        self.monkeyId = @"DatePicker";
        self.monkeyCommand = self.monkeyId;
    }
    else if ([subview isKindOfClass:[UICollectionView class]]) {
        self.monkeyId = @"Grid";
        self.monkeyCommand = self.monkeyId;
    }
    else if ([subview isKindOfClass:[UIImage class]]) {
        self.monkeyId = @"Image";
        self.monkeyCommand = self.monkeyId;
    }
    else if ([subview isKindOfClass:[UITextField class]]) {
        self.monkeyId = @"*";
        if (subview.accessibilityLabel && ![subview.accessibilityLabel isEqualToString:@""])
            self.monkeyId = subview.accessibilityLabel;
        self.monkeyCommand = [NSString stringWithFormat:@"Input \"%@\" EnterText abc", self.monkeyId];
    }
    else if ([subview isKindOfClass:[UIPickerView class]]) {
        self.monkeyId = @"ItemSelector";
        self.monkeyCommand = self.monkeyId;
    }
    else if ([subview isKindOfClass:[UILabel class]]) {
        self.monkeyId = @"Label";
        self.monkeyCommand = self.monkeyId;
    }
    else if ([subview isKindOfClass:[UITabBar class]]) {
        self.monkeyId = @"*";
        if (subview.accessibilityLabel && ![subview.accessibilityLabel isEqualToString:@""])
            self.monkeyId = subview.accessibilityLabel;
        self.monkeyCommand = [NSString stringWithFormat:@"TabBar \"%@\" Select \"1st Tab\"", self.monkeyId];;
    }
    else if ([subview isKindOfClass:[UISlider class]]) {
        self.monkeyId = @"Slider";
        self.monkeyCommand = self.monkeyId;
    }
    else if ([subview isKindOfClass:[UITableView class]]) {
        self.monkeyId = @"table";
        if (subview.accessibilityLabel && ![subview.accessibilityLabel isEqualToString:@""])
            self.monkeyId = subview.accessibilityLabel;
        self.monkeyCommand = [NSString stringWithFormat:@"Table \"%@\" SelectIndex 1", self.monkeyId];
    }
    else if ([subview isKindOfClass:[UITextView class]]) {
        self.monkeyId = @"*";
        if (subview.accessibilityLabel && ![subview.accessibilityLabel isEqualToString:@""])
            self.monkeyId = subview.accessibilityLabel;
        self.monkeyCommand = [NSString stringWithFormat:@"TextArea \"%@\" EnterText abc", self.monkeyId];
    }
    else if ([subview isKindOfClass:[UISwitch class]]) {
        self.monkeyId = @"Toggle";
        self.monkeyCommand = self.monkeyId;
    }
    else if ([subview isKindOfClass:[UIToolbar class]]) {
        self.monkeyId = @"ToolBar";
        self.monkeyCommand = self.monkeyId;
    }
    else if ([subview isKindOfClass:[UIWebView class]]) {
        self.monkeyId = @"WebView";
        self.monkeyCommand = self.monkeyId;
    }
    else if ([subview isKindOfClass:[UIScrollView class]]) {
        self.monkeyId = @"Scroller";
        self.monkeyCommand = self.monkeyId;
    }
    else if ([subview isKindOfClass:[UIStepper class]]) {
        self.monkeyId = @"Stepper";
        self.monkeyCommand = self.monkeyId;
    }
    else if ([subview isKindOfClass:[UIView class]]) {
        self.monkeyId = @"View";
        self.monkeyCommand = self.monkeyId;
    }
    //		([subview isKindOfClass:[UISearchBar class]])
    //		([subview isKindOfClass:[UIAlertView class]])
    //		([subview isKindOfClass:[UIActionSheet class]])
    //      ([subview isKindOfClass:[UITableViewCell class]])
    //		([subview isKindOfClass:[UINavigationBar class]])
    //		([subview isKindOfClass:[UIImageView class]])
    //		([subview isKindOfClass:[UIProgressView class]])
    //		([subview isKindOfClass:[UIActivityIndicatorView class]])

}

- (NSString*)getMonkeyIndexForButton:(UIButton*)btnView {
    
    State *currentState = [[ICrawlerController sharedICrawler] currentState];
    NSMutableArray *elements = [NSMutableArray arrayWithArray:currentState.uiElementsArray];
    int count= 0;
    NSString *monkeyIndex = [NSString stringWithFormat:@"%d", count];
    
    for (UIElement* e in elements) {
        if ([e.object isEqual:btnView]) {
            for (UIElement* b in elements){
                if ([b.object isKindOfClass:[UIButton class]])
                    count++;
            }
            monkeyIndex = [NSString stringWithFormat:@"%d", count];
            break;
        }
    }
	
	return monkeyIndex;
}

#pragma mark -
#pragma mark Helper Methods

- (void)addActionForTargetUIElement {
    
	if ([self.object respondsToSelector:@selector(allTargets)]) {
		
		UIControl *control = (UIControl *)self.object;
		UIControlEvents controlEvents = [control allControlEvents];
		NSSet *allTargets = [control allTargets];
		[allTargets enumerateObjectsUsingBlock:^(id _target, BOOL *stop)
		 {
			 self.target = _target;
			 NSArray *actions = [control actionsForTarget:target forControlEvent:controlEvents];
			 [actions enumerateObjectsUsingBlock:^(id _action, NSUInteger idx, BOOL *stop2)
			  {
				  self.action = (NSString *)_action;
			  }];
		 }];
    }
}

+ (UIElement*)addUIElement:(id)_object {

	UIElement *element = [[UIElement alloc] init];
    element.object = _object;
    element.objectClass = [_object class];
	element.className = [NSString stringWithFormat:@"%@", element.objectClass];
	// list targets if there are any
	[element addActionForTargetUIElement];
    [element setMonkeyIdForView:(UIView*)_object];
	
	return element;
}

- (BOOL)isEqualToUIElement:(UIElement*)e {
	
	BOOL returnValue = NO;
	
	if((self.className && e.className && [self.className isEqualToString:e.className]) || (!self.className && !e.className))// &&
		
        
		if(((self.action!=nil && e.action!=nil && [self.action isEqualToString:e.action]) || (self.action==nil && e.action==nil)) ||
		   ([self.action	hasSuffix:@"ButtonItem"] && [e.action hasSuffix:@"ButtonItem"])) {
            
            if ([self.action hasSuffix:@"UndefinedBackButtonItem"] || [e.action hasSuffix:@"UndefinedBackButtonItem"] || [self.action hasSuffix:@"LeftBarButtonItem"] || [e.action hasSuffix:@"LeftBarButtonItem"]) {
                returnValue = TRUE;
            }
            else if ([self.action	hasSuffix:@"BarButtonItem"] && [e.action hasSuffix:@"BarButtonItem"]) {
				
				UIBarButtonItem *barItem1 = (UIBarButtonItem *)self.objectClass;
				UIBarButtonItem *barItem2 = (UIBarButtonItem *)e.objectClass;
				
				if ([barItem1 isEqual:barItem2])
					//if ((barItem1.tag == barItem2.tag) &&
					//	(barItem1.enabled == barItem2.enabled) &&
					//	(barItem1.image == barItem2.image) &&
					//	(barItem1.title == barItem2.title))
					
					returnValue = TRUE;
			}
			//if((self.target && e.target && [self.target isEqual:e.target]) || (!self.target && !e.target)) {
			else if ([self.objectClass isSubclassOfClass:UIView.class] &&
				[e.objectClass isSubclassOfClass:UIView.class]) {
				
				UIView *view1 = (UIView *)self.objectClass;
				UIView *view2 = (UIView *)e.objectClass;
				
				if ([view1 isEqual:view2])
					//if ((view1.tag && view2.tag) || (view1.tag && view2.tag && view1.tag == view2.tag))
					//if (view1.backgroundColor == view2.backgroundColor) //&&
					//if (view1.hidden == view2.hidden) //&&
					//if (view1.userInteractionEnabled == view2.userInteractionEnabled) //&&
					//if ([[self.object accessibilityLabel] isEqualToString:[e.object accessibilityLabel]])
					
					returnValue = TRUE;
			}
		}
	
	return returnValue;
}

+ (UIElement*)addNavigationItem:(UIBarButtonItem*)barButtonItem withAction:(NSString*)action {
	
	UIElement *element = [[UIElement alloc] init];
	element.action = action;
	element.target = barButtonItem.target;
	element.object = (id)barButtonItem;
	element.objectClass = [element.object class];
    element.className = [NSString stringWithFormat:@"%@", element.objectClass];
    
    UIView *customView = barButtonItem.customView;
    UIImageView *imageView = ((UIImageView *)(barButtonItem.customView.subviews.lastObject));
    NSNumber *value = [barButtonItem valueForKey:@"systemItem"];
    
    if (barButtonItem.title && ![barButtonItem.title isEqualToString:@""])
        element.monkeyId = barButtonItem.title;
    
    else if (barButtonItem.accessibilityLabel && ![barButtonItem.accessibilityLabel isEqualToString:@""])
        element.monkeyId = barButtonItem.accessibilityLabel;
    
    else if (customView.accessibilityLabel && ![customView.accessibilityLabel isEqualToString:@""])
        element.monkeyId = customView.accessibilityLabel;
    
    else if (imageView.accessibilityLabel && ![imageView.accessibilityLabel isEqualToString:@""]) {
        NSString * newString = [imageView.accessibilityLabel stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        element.monkeyId = [newString stringByReplacingOccurrencesOfString:@".png" withString:@""];
    }
    
    else if (value) {
        UIBarButtonSystemItem systemItemOut = [value integerValue];
        if (systemItemOut == UIBarButtonSystemItemDone) element.monkeyId = @"Done";
        else if (systemItemOut == UIBarButtonSystemItemCancel) element.monkeyId = @"Cancel";
        else if (systemItemOut == UIBarButtonSystemItemEdit) element.monkeyId = @"Edit";
        else if (systemItemOut == UIBarButtonSystemItemSave) element.monkeyId = @"Save";
        else if (systemItemOut == UIBarButtonSystemItemAdd) element.monkeyId = @"Add";
        else if (systemItemOut == UIBarButtonSystemItemFlexibleSpace) element.monkeyId = @"FlexibleSpace";
        else if (systemItemOut == UIBarButtonSystemItemFixedSpace) element.monkeyId = @"FixedSpace";
        else if (systemItemOut == UIBarButtonSystemItemCompose) element.monkeyId = @"Compose";
        else if (systemItemOut == UIBarButtonSystemItemReply) element.monkeyId = @"Reply";
        else if (systemItemOut == UIBarButtonSystemItemAction) element.monkeyId = @"Action";
        else if (systemItemOut == UIBarButtonSystemItemOrganize) element.monkeyId = @"Organize";
        else if (systemItemOut == UIBarButtonSystemItemBookmarks) element.monkeyId = @"Bookmarks";
        else if (systemItemOut == UIBarButtonSystemItemSearch) element.monkeyId = @"Search";
        else if (systemItemOut == UIBarButtonSystemItemRefresh) element.monkeyId = @"Refresh";
        else if (systemItemOut == UIBarButtonSystemItemStop) element.monkeyId = @"Stop";
        else if (systemItemOut == UIBarButtonSystemItemCamera) element.monkeyId = @"Camera";
        else if (systemItemOut == UIBarButtonSystemItemTrash) element.monkeyId = @"Trash";
        else if (systemItemOut == UIBarButtonSystemItemPlay) element.monkeyId = @"Play";
        else if (systemItemOut == UIBarButtonSystemItemPause) element.monkeyId = @"Pause";
        else if (systemItemOut == UIBarButtonSystemItemRewind) element.monkeyId = @"Rewind";
        else if (systemItemOut == UIBarButtonSystemItemFastForward) element.monkeyId = @"Forward";
        else if (systemItemOut == UIBarButtonSystemItemUndo) element.monkeyId = @"Undo";
        else if (systemItemOut == UIBarButtonSystemItemRedo) element.monkeyId = @"Redo)";
        else if (systemItemOut == UIBarButtonSystemItemPageCurl) element.monkeyId = @"Curl";
    }
    else
         element.monkeyId = @"ERROR";

    element.monkeyCommand = [NSString stringWithFormat:@"Button \"%@\" Tap", element.monkeyId];
    
	return element;
}

+ (UIElement*)addNavigationItemView:(UIView*)thisBackButtonView withAction:(NSString*)action {
	
	UIElement *element = [[UIElement alloc] init];
	element.action = action;
	element.target = nil;
	element.object = (UIView*)thisBackButtonView;
	element.objectClass = [element.object class]; 
    element.className = [NSString stringWithFormat:@"%@", element.objectClass];
    
    UINavigationItem *item = (UINavigationItem*)thisBackButtonView;
    
    if (thisBackButtonView.accessibilityLabel && ![thisBackButtonView.accessibilityLabel isEqualToString:@""])
        element.monkeyId = thisBackButtonView.accessibilityLabel;
    
    else if (item.title && ![item.title isEqualToString:@""])
        element.monkeyId = item.title;
    
    else if (item.accessibilityLabel && ![item.accessibilityLabel isEqualToString:@""])
        element.monkeyId = item.accessibilityLabel;
    
    element.monkeyCommand = [NSString stringWithFormat:@"Button \"%@\" Tap", element.monkeyId];
    
	return element;
}

@end
