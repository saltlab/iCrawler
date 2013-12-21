//
//  State.m
//
//  Created by Mona on 12-04-07. All rights reserved.
//

#import "State.h"
#import "OutputComponent.h"
#import "ICrawlerController.h"
#import "ICConstants.h"

@implementation State

@synthesize uiElementsArray, selfViewController, stateIndex, visitedStateIndex;


+ (NSMutableArray*)setInitialState:(State*)state {
	
	NSMutableArray *nodes = [[[NSMutableArray alloc] init] autorelease];
	XMLNode* thisNode = [[[XMLNode alloc] init] autorelease];
	thisNode.currentStateIndex = state.visitedStateIndex;
	thisNode.edge = @"";
	thisNode.preStateIndex = 0;
    thisNode.currentElement = nil;
	[nodes addObject:thisNode];
	
	[OutputComponent createScreenshotsDirectory];
	[OutputComponent takeScreenshotOfState:thisNode];
    
    return nodes;
}

- (XMLNode*)setEdgeForStateWithElement:(UIElement*)element {
    
	XMLNode* thisNode = [[[XMLNode alloc] init] autorelease];
	
    thisNode.currentElement = element;
    
	if ([element.action isEqualToString:@"LeftBarButtonItem"] || [element.action isEqualToString:@"BackBarButtonItem"] || [element.action isEqualToString:@"UndefinedBackButtonItem"])
	{
		thisNode.preStateIndex = self.visitedStateIndex;
		thisNode.edge = element.action;
		thisNode.currentStateIndex = (self.stateIndex - 1);
	}
	else {
		NSArray *t= [[Globals sharedInstance] xmlNodesArray];
		//thisNode.preStateIndex = currentState.visitedStateIndex;
		XMLNode *node = [t lastObject];
		thisNode.preStateIndex = node.currentStateIndex;
		thisNode.currentStateIndex = thisNode.preStateIndex;
        
		if ([element.object isKindOfClass:[UITableView class]])
			thisNode.edge = @"TableCellClicked";
		else if ([element.object isKindOfClass:[UITextView class]])
			thisNode.edge = @"WriteInUITextView";
		else if ([element.object isKindOfClass:[UITextField class]]) 
			thisNode.edge = @"WriteInUITextField";
		else if ([element.object isKindOfClass:[UITabBar class]])
			thisNode.edge = @"TabBarItemclicked";
		else if ([element.object isKindOfClass:[UIScrollView class]]) 
			thisNode.edge = @"ScrollViewclicked";
		else
			thisNode.edge = element.action;
	}
	
	return thisNode;
}

- (void)setNextState {
    XMLNode* thisNode = [[[Globals sharedInstance] xmlNodesArray] lastObject];
	thisNode.currentStateIndex = self.visitedStateIndex;
}


- (UIViewController*)initializeRootState {
	
    UIViewController *currentViewController = [[ICrawlerController sharedICrawler] currentViewController];
	
	id mainController;
	NSObject <UIApplicationDelegate> *appDelegate = (NSObject <UIApplicationDelegate> *)[[UIApplication sharedApplication] delegate];
	Class appDelegateClass = object_getClass(appDelegate);
    Class appDelegateSuperClass = [appDelegateClass superclass];
    
	unsigned int outCount, i;
	objc_property_t *properties = class_copyPropertyList([appDelegateClass class], &outCount);
    if (!properties && appDelegateSuperClass) 
        properties = class_copyPropertyList(appDelegateSuperClass, &outCount);
    
	for(i = 0; i < outCount; i++) {
		objc_property_t property = properties[i];
		const char *propName = property_getName(property);
		if(propName) {
			NSString *propertyName = [NSString stringWithUTF8String:propName];
			mainController = [appDelegate valueForKey:propertyName];
			
			if ([mainController isKindOfClass:[UINavigationController class]]) {
				//the app starts with NavigationController
				UINavigationController *newNav = (UINavigationController*)mainController;
				currentViewController = newNav.topViewController;
				break;
			}
			else if ([mainController isKindOfClass:[UITabBarController class]]) {
				//the app starts with TabBarController
				UITabBarController *thisTabBarController = (UITabBarController*)mainController;
				thisTabBarController.selectedIndex = 0;
				currentViewController = thisTabBarController;
				break;
			}
			else if ([mainController isKindOfClass:[UIViewController class]]) {
				//the app starts with a UIViewController
				UIViewController *mainViewController = [appDelegate valueForKey:propertyName];
				currentViewController = mainViewController;
				break;
			}
            //else if ([mainController isKindOfClass:[UIWindow class]]) {
            //	UIWindow *window = [appDelegate valueForKey:propertyName];
            //	UIViewController *mainViewController = window.rootViewController;
            //	self.currentViewController = mainViewController;
            //	break;
            //}
		}
	}
	
    free(properties);
    return currentViewController;
}

- (UIElement*)isElementWithActionLeftForState {
    for (UIElement *element in self.uiElementsArray) {
		
		if ([element.action length]>0 && !(element.visited)) {
			if ([element.action	hasSuffix:@"BarButtonItem"]) {
				UIBarButtonItem *barItem = (UIBarButtonItem *)element.object;
				if (barItem.enabled) {
					if (barItem.customView) {
						UIView * view = (UIView *)barItem.customView;
						if (!view.hidden)
							return element;
					} else
						return element;
				}
			}
			else {
				UIView *view = (UIView *)element.object;
				if (!view.hidden)
					return element;
			}
		}
		else if ([element.object isKindOfClass:[UITextView class]] && !(element.visited)) {
			UITextView *textView = (UITextView *)element.object;
			if(textView.editable)
				return element;
		}
		else if (([element.object isKindOfClass:[UITableView class]] || [element.object isKindOfClass:[UIScrollView class]] || [element.object isKindOfClass:[UITextField class]]) && !(element.visited))
			return element;
		else if ([element.object isKindOfClass:[UITabBar class]])
			return element;
	}
	
	return nil;
}

- (void)setAllUIElementsVisitedTrue {
	for(UIElement* e in self.uiElementsArray) {
        if ([e.action	hasSuffix:@"UndefinedBackButtonItem"] ||
            [e.action	hasSuffix:@"BackBarButtonItem"] ||
            [e.action	hasSuffix:@"LeftBarButtonItem"])
            e.visited = FALSE;
        else
            e.visited = TRUE;
    }
}

- (BOOL)isNewDynamicUIElementAdded:(NSMutableArray*)elements {
	BOOL isAdded = FALSE;
    [self setAllUIElementsForState];
    
    for(UIElement* e in self.uiElementsArray) {
        if ([e.action	hasSuffix:@"UndefinedBackButtonItem"]){
            for(UIElement* e2 in elements)
                if ([e2.action	hasSuffix:@"UndefinedBackButtonItem"]){
                    e.visited = TRUE;
                    break;
                }
        }
        if ([e.action	hasSuffix:@"BackBarButtonItem"]){
            for(UIElement* e2 in elements)
                if ([e2.action	hasSuffix:@"BackBarButtonItem"]){
                    e.visited = TRUE;
                    break;
                }
        }
    }
    
    if ([self.uiElementsArray count]>[elements count] || [self.uiElementsArray count]<[elements count]) {
        isAdded = TRUE;
        for(UIElement* e in self.uiElementsArray){
            if ([self.uiElementsArray indexOfObject:e] < [elements count] &&
                [e isEqualToUIElement:[elements objectAtIndex:[self.uiElementsArray indexOfObject:e]]]) {
                e.visited = TRUE;
            }
        }
    }
    else {
        BOOL returnVal = TRUE;
        for(UIElement* e in self.uiElementsArray){
            if (![e isEqualToUIElement:[elements objectAtIndex:[self.uiElementsArray indexOfObject:e]]]) {
                returnVal = FALSE;
                break;
            }
        }
        if (returnVal)
            isAdded = FALSE;
        else
            isAdded = TRUE;
    }
    
    return isAdded;
}


- (BOOL)isBarButtonAdded {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IC_barButtonAdded"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IC_barButtonAdded"];
        return TRUE;
    }
    return FALSE;
}


- (UIActionSheet*)doesActionSheetExist {
    for (UIWindow* window in [UIApplication sharedApplication].windows) {
        NSArray* subviews = window.subviews;
        for (UIView* subview in subviews) {
            BOOL actionSheet = [subview isKindOfClass:[UIActionSheet class]];
            if (actionSheet)
                return (UIActionSheet*)subview;
        }
    }
    return nil;
}

- (UIAlertView*)doesAlertViewExist {
    //UINavigationTransitionView UILayoutContainerView UIViewControllerWrapperView
    for (UIWindow* window in [UIApplication sharedApplication].windows) {
        NSArray* subviews = window.subviews;
        for (UIView* subview in subviews) {
            BOOL alert = [subview isKindOfClass:[UIAlertView class]];
            if (alert)
                return (UIAlertView*)subview;
        }
    }
    return nil;
}

- (void)setAllUIElementsForState {
	
	NSMutableArray *elements = [[NSMutableArray alloc] init];
	if ([self.selfViewController isKindOfClass:[UITableViewController class]]) {
		UITableViewController* thisTableViewController = (UITableViewController*)self.selfViewController;
		[elements addObject:[UIElement addUIElement:thisTableViewController.tableView]];
    }
	else if ([self.selfViewController.view isKindOfClass:[UITableView class]]) 
		[elements addObject:[UIElement addUIElement:self.selfViewController.view]];
    
    else if ([self.selfViewController isKindOfClass:[UITabBarController class]]) {
		UITabBarController* thisTabBarController = (UITabBarController*)self.selfViewController;
		[elements addObject:[UIElement addUIElement:thisTabBarController.tabBar]];
	}
    else 
        [self addAllSubviewsOfView:self.selfViewController.view toArray:elements];
	
    // If this view controller is inside a navigation controller or tab bar controller, or has been presented modally by another view controller, return it.
    if (self.selfViewController.navigationController || ([self.selfViewController.parentViewController isKindOfClass:[UINavigationController class]])) {
        
        UINavigationController* thisNav = (UINavigationController*)self.selfViewController.parentViewController;
        if (!self.selfViewController.navigationController.navigationBar.hidden || !thisNav.navigationBar.hidden) {
            
            if (self.selfViewController.navigationItem.rightBarButtonItem)
                [elements addObject:[UIElement addNavigationItem:self.selfViewController.navigationItem.rightBarButtonItem withAction:@"RightBarButtonItem"]];
            if (self.selfViewController.navigationItem.leftBarButtonItem)
                [elements addObject:[UIElement addNavigationItem:self.selfViewController.navigationItem.leftBarButtonItem withAction:@"LeftBarButtonItem"]];
            else if (self.selfViewController.navigationItem.backBarButtonItem
                     && !self.selfViewController.navigationItem.hidesBackButton
                     && self.selfViewController.navigationItem.backBarButtonItem.width>0)
                [elements addObject:[UIElement addNavigationItem:self.selfViewController.navigationItem.backBarButtonItem withAction:@"BackBarButtonItem"]];
            else if (!thisNav.navigationBar.hidden) {
                NSArray *thisArray = thisNav.navigationBar.items;
                for (UINavigationItem *item in thisArray) {
                    UIView *thisBackButtonView = [item valueForKey:@"_backButtonView"];
                    if (item.backBarButtonItem && !item.hidesBackButton && item.backBarButtonItem.width>0)
                        [elements addObject:[UIElement addNavigationItem:item.backBarButtonItem withAction:@"BackBarButtonItem"]];
                    else if (thisBackButtonView && !(thisBackButtonView.frame.origin.x <0 || thisBackButtonView.frame.origin.y <0))
                        [elements addObject:[UIElement addNavigationItemView:thisBackButtonView withAction:@"UndefinedBackButtonItem"]];
                    else if (item.leftBarButtonItem)
                        [elements addObject:[UIElement addNavigationItem:item.leftBarButtonItem withAction:@"LeftBarButtonItem"]];
                }
            }
        }
    }
    
    //detecting if a UIAlert is open
    UIAlertView* alertView = [self doesAlertViewExist];
    if (alertView)
        [elements addObject:alertView];
    
    //detecting if a UIActionSheet is open
    //UIActionSheet* actionView = [UIElement doesActionSheetExist];
    //if (actionView)
    //    [elements addObject:actionView];
    
	self.uiElementsArray = elements;
}

- (void)addAllSubviewsOfView:(UIView*)thisView toArray:(NSMutableArray*)elements {
	
	NSArray *views = [thisView subviews];
	for(UIView *subview in views) {
		if (!subview.hidden) {
            
		if ([subview isKindOfClass:[UINavigationBar class]]) {
			UINavigationBar* thisNavigationBar = (UINavigationBar*)subview;
			NSArray *thisArray = thisNavigationBar.items;
			
			for (UINavigationItem *item in thisArray) {
                UIView *thisBackButtonView = [item valueForKey:@"_backButtonView"];
				if (item.backBarButtonItem && !item.hidesBackButton && item.backBarButtonItem.width>0) 
					[elements addObject:[UIElement addNavigationItem:(UIBarButtonItem*)item.backBarButtonItem withAction:@"BackBarButtonItem"]];
                else if (thisBackButtonView && !(thisBackButtonView.frame.origin.x <0 || thisBackButtonView.frame.origin.y <0)) 
                    [elements addObject:[UIElement addNavigationItemView:thisBackButtonView withAction:@"UndefinedBackButtonItem"]];
                else if (item.leftBarButtonItem) 
					[elements addObject:[UIElement addNavigationItem:(UIBarButtonItem*)item.leftBarButtonItem withAction:@"LeftBarButtonItem"]];
                else if (item.rightBarButtonItem) 
                    [elements addObject:[UIElement addNavigationItem:(UIBarButtonItem*)item.rightBarButtonItem withAction:@"RightBarButtonItem"]];
                else if ([self isBarButtonAdded]) {
                    UINavigationItem *item = [ICrawlerController sharedICrawler].navItem;
                    if (item) {
                        if (item.leftBarButtonItem) 
                            [elements addObject:[UIElement addNavigationItem:(UIBarButtonItem*)item.leftBarButtonItem withAction:@"LeftBarButtonItem"]];
                        else if (item.rightBarButtonItem) 
                            [elements addObject:[UIElement addNavigationItem:(UIBarButtonItem*)item.rightBarButtonItem withAction:@"RightBarButtonItem"]];
                    }
                }
			}
		}
		else if (![subview isKindOfClass:[UITableView class]] && [subview isKindOfClass:[UIScrollView class]]) {
			[elements addObject:[UIElement addUIElement:subview]];
            [self addAllSubviewsOfView:subview toArray:elements];
		}
		else if (!(([subview isKindOfClass:[UIControl class]])
				   || ([subview isKindOfClass:[UIWebView class]])
				   || ([subview isKindOfClass:[UISearchBar class]])
				   || ([subview isKindOfClass:[UIAlertView class]])
				   || ([subview isKindOfClass:[UIActionSheet class]])
				   || ([subview isKindOfClass:[UITableViewCell class]])
				   || ([subview isKindOfClass:[UINavigationBar class]])
				   || ([subview isKindOfClass:[UIToolbar class]])
				   || ([subview isKindOfClass:[UITabBar class]])
				   || ([subview isKindOfClass:[UIImageView class]])
				   || ([subview isKindOfClass:[UIProgressView class]])
				   || ([subview isKindOfClass:[UIPickerView class]])
				   || ([subview isKindOfClass:[UILabel class]])
                   || ([subview isKindOfClass:[UIButton class]])
				   || ([subview isKindOfClass:[UIWindow class]])
				   || ([subview isKindOfClass:[UITableView class]])
				   || ([subview isKindOfClass:[UIActivityIndicatorView class]]))){
			
			[self addAllSubviewsOfView:subview toArray:elements];
		} else 
			[elements addObject:[UIElement addUIElement:subview]];
        }
	}
}

- (State*)getVisitedStateHeuristicallyForState {
	
	int similarity;
	int Threshold;
	
	for (State* thisState in [ICrawlerController sharedICrawler].visitedStates){
		
		Threshold = WEIGHT_VC_CLASS + WEIGHT_VC_TITLE + WEIGHT_VC_COUNT_GUIS;
		
		similarity =
		WEIGHT_VC_CLASS*(([thisState.selfViewController class]==[self.selfViewController class]) ? 1 : 0) +
		WEIGHT_VC_TITLE*((thisState.selfViewController.title==self.selfViewController.title) ? 1 : 0) +
		WEIGHT_VC_COUNT_GUIS*(([thisState.uiElementsArray count]==[self.uiElementsArray count]) ? 1 : 0);
        
        if ([thisState.uiElementsArray count] == [self.uiElementsArray count]) {
            
            //compare two uielements
            for(UIElement* e1 in self.uiElementsArray){
                UIElement* e2 = [thisState.uiElementsArray objectAtIndex:[self.uiElementsArray indexOfObject:e1]];
                 
                Threshold = Threshold + WEIGHT_E_CLASS;
                
                similarity = similarity + WEIGHT_E_CLASS*((e1.objectClass == e2.objectClass) ? 1 : 0);
                similarity = similarity + WEIGHT_E_TARGET*((e1.target==e2.target) ? 1 : 0);
                
                similarity = similarity + WEIGHT_E_ACTION*((e1.action==e2.action) ? 1 : 0);
                
                if (e1.objectClass==e2.objectClass) {
                    if ([e1.objectClass isSubclassOfClass:UIView.class] &&
                        [e2.objectClass isSubclassOfClass:UIView.class]) {
                        
                        UIView *view1 = (UIView *)e1.objectClass;
                        UIView *view2 = (UIView *)e2.objectClass;
                        
                        similarity = similarity + WEIGHT_E_EQUAL*(([view1 isEqual: view2]) ? 1 : 0);
                        //WEIGHT_E_ENABALED*((view1.userInteractionEnabled==view2.userInteractionEnabled) ? 1 : 0);
                    }
                    else if ([e1.action	hasSuffix:@"BarButtonItem"] && [e2.action hasSuffix:@"BarButtonItem"]) {
                        
                        UIBarButtonItem *barItem1 = (UIBarButtonItem *)e1.objectClass;
                        UIBarButtonItem *barItem2 = (UIBarButtonItem *)e2.objectClass;
                        
                        similarity = similarity + WEIGHT_E_EQUAL*(([barItem1 isEqual:barItem2]) ? 1 : 0);
                        //UIView *view1 = (UIView *)barItem1.customView;
                        //UIView *view2 = (UIView *)barItem2.customView;
                        //WEIGHT_E_HIDDEN*((view1.hidden==view2.hidden) ? 1 : 0);
                    }
                }
                else
                    break;
            }
        }
        
		if (similarity >= Threshold)
			return thisState;
	}
	return nil;
}

- (State*)getVisitedStateForState {
	
	for (State* thisState in [ICrawlerController sharedICrawler].visitedStates){
		
		if([thisState.selfViewController isKindOfClass:[self.selfViewController class]]){
			if (((thisState.selfViewController.nibName==nil && self.selfViewController.nibName==nil) || (thisState.selfViewController.nibName!=nil && self.selfViewController.nibName!=nil && [thisState.selfViewController.nibName isEqualToString:self.selfViewController.nibName])) &&
				((thisState.selfViewController.title==nil && self.selfViewController.title==nil) || (thisState.selfViewController.title!=nil && self.selfViewController.title!=nil && [thisState.selfViewController.title isEqualToString:self.selfViewController.title])) &&
				
				[thisState.uiElementsArray count] == [self.uiElementsArray count]){
				//compare two uielements
				if ([self isAllUIElementsEqualForState:thisState])
					return thisState;
			}
		}
	}
	return nil;
}

- (BOOL)isAllUIElementsEqualForState:(State *)state {
	
	for(UIElement* e1 in state.uiElementsArray){
		UIElement* e2 = [self.uiElementsArray objectAtIndex:[state.uiElementsArray indexOfObject:e1]];
		if (![e1 isEqualToUIElement:e2]) {
			return FALSE;
		}
	}
	return TRUE;
}

- (UIElement*)returnUITabBarElementForState {
    for (UIElement *element in self.uiElementsArray) {
		if ([element.object isKindOfClass:[UITabBar class]])
			return element;
	}
	return nil;
}


@end
