//
//  ICrawlerController.m
//
//  Created by Mona on 12-04-07. All rights reserved.
//

#import "ICrawlerController.h"
#import "ICConstants.h"
#import "OutputComponent.h"
#import "UIViewController+Additions.h"
#import "UINavigationController+Additions.h"
#include <QuartzCore/QuartzCore.h>

ICrawlerController *sharedInstance = nil;


@implementation ICrawlerController

@synthesize currentViewController, visitedStates;
@synthesize globals, currentState, dynamicState, navItem, monkeyID;


#pragma mark -
#pragma mark SharedInstance Methods
+ (ICrawlerController *)sharedICrawler {
	if (!sharedInstance)
		sharedInstance = [[ICrawlerController alloc] init];

	return sharedInstance;
}


#pragma mark -
#pragma mark Start Methods
- (void)start {
	UIWindow *mainWindow = [self mainWindow];
	if (!mainWindow) {
		NSLog(@"ICrawlerController: Couldn't setup.  No main window?");
		return;
	}
	
    //Setup Method Calls
	[OutputComponent setup];
	[self setupGlobals];
    
	//Start application testing
	[self performSelector:@selector(runAutoTestingApp:) withObject:START_AUTO_CLICKED afterDelay:INTER_ACTION_SHORT_DELAY];
}

- (UIWindow *)mainWindow {
	NSArray *windows = [[UIApplication sharedApplication] windows];
	if (windows.count == 0)
		return nil;
	return [windows objectAtIndex:0];
}

- (void)setupGlobals {
	self.globals = [[Globals alloc] init];
	self.dynamicState = VALUE_ZERO_PARAMETER;
    self.monkeyID = VALUE_ONE_PARAMETER;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IC_barButtonAdded"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IC_isDismissed"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IC_isPresented"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"IC_isPushedPoped"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IC_isPushed"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IC_isPoped"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IC_isInitWithRoot"];
}


#pragma mark -
#pragma mark Main Methods
- (void)runAutoTestingApp:(NSString *)actionFlag {
	
	if ([actionFlag isEqualToString:START_AUTO_CLICKED])
		[self setupRootState];
	
	else if ([actionFlag isEqualToString:NEXT_ACTION_CLICKED])
		[self setupNextStateAndViewController];
	
	else if ([actionFlag isEqualToString:BACK_BUTTON_CLICKED])
		[self getPreviousStateAndViewController];
	
    [self findClickableElementAndFireAction];
}


#pragma mark -
#pragma mark Root View Controller Methods
- (void)setupRootState {
	self.visitedStates = [[NSMutableArray alloc] init];
	NSMutableArray *states = [[NSMutableArray alloc] init];
	
	State* state = [[State alloc] init];
	state.stateIndex = VALUE_ZERO_PARAMETER;
	state.visitedStateIndex = VALUE_ZERO_PARAMETER;
    state.selfViewController = [state initializeRootState];
	self.currentViewController = state.selfViewController;
    
	[state setAllUIElementsForState];
    self.globals.xmlNodesArray = [State setInitialState:state];
	[states addObject:state];
	
	self.currentState = state;
	self.currentViewController = state.selfViewController;
	
	self.globals.statesArray = states;
	[self.visitedStates addObject:state];
	[Globals setSharedInstance:self.globals];
}


#pragma mark -
#pragma mark Next And Pre View Controller Methods
- (void)setupNextStateAndViewController {
	//viewcontroller is modally presented, need a new state (presentedViewController)
    if ([self.currentViewController isViewPresented]) {
		
		if ([self.currentViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
			UINavigationController *newNav = (UINavigationController*)self.currentViewController.presentedViewController;
			self.currentViewController = newNav.topViewController;
		}
		else {
			self.currentViewController = self.currentViewController.presentedViewController;
		}
		
		//create a new state
		State* state = [[State alloc] init];
		state.selfViewController = self.currentViewController;
		state.stateIndex = [[[Globals sharedInstance] statesArray] count];
		state.visitedStateIndex = [self.visitedStates count];
		
		[state setAllUIElementsForState];
		
		State* thisState = [state getVisitedStateHeuristicallyForState];
		if (thisState) {
			state.stateIndex = thisState.stateIndex;
			state.visitedStateIndex = thisState.visitedStateIndex;
            [state setAllUIElementsVisitedTrue];
		}
		
		[[[Globals sharedInstance] statesArray] insertObject:state atIndex:[[[Globals sharedInstance] statesArray] count]];
		self.currentState = state;
		[self.currentState setNextState];
		
		if (!thisState) {
			[OutputComponent takeScreenshotOfState:[[[Globals sharedInstance] xmlNodesArray] lastObject]];
			[self.visitedStates insertObject:state atIndex:[self.visitedStates count]];
		}
	}
	else if (self.currentViewController.navigationController && [self.currentViewController.navigationController isViewPushed]) {
		
		self.currentViewController = self.currentViewController.navigationController.topViewController;
		
		if ([self.currentViewController isKindOfClass:[UITabBarController class]]) {
			
			UITabBarController* thisTabBarController = (UITabBarController*)self.currentViewController;
			thisTabBarController.selectedIndex = 0;
			self.currentViewController = thisTabBarController;
		}
		//create a new state
		State* state = [[State alloc] init];
		state.selfViewController = self.currentViewController;
		state.stateIndex = [[[Globals sharedInstance] statesArray] count];
		state.visitedStateIndex = [self.visitedStates count];
		
		[state setAllUIElementsForState];
		
		State* thisState = [state getVisitedStateHeuristicallyForState];
		if (thisState) {
			state.stateIndex = thisState.stateIndex;
			state.visitedStateIndex = thisState.visitedStateIndex;
            [state setAllUIElementsVisitedTrue];
		}
		
		[[[Globals sharedInstance] statesArray] insertObject:state atIndex:[[[Globals sharedInstance] statesArray] count]];
		self.currentState = state;
		[self.currentState setNextState];
        XMLNode* thisNode = [[[Globals sharedInstance] xmlNodesArray] lastObject];
        thisNode.currentStateIndex = self.currentState.visitedStateIndex;
		
		if (!thisState) {
			[OutputComponent takeScreenshotOfState:[[[Globals sharedInstance] xmlNodesArray] lastObject]];
			[self.visitedStates insertObject:state atIndex:[self.visitedStates count]];
		}
	}
	//viewcontroller is the next tab in UITabBarController
	else if ([self.currentViewController isKindOfClass:[UITabBarController class]]) {
		
		UITabBarController* thisTabBarController = (UITabBarController*)self.currentViewController;
		
		if ([[thisTabBarController.viewControllers objectAtIndex:thisTabBarController.selectedIndex] isKindOfClass:[UINavigationController class]]) {
			UINavigationController *newNav = (UINavigationController*)[thisTabBarController.viewControllers objectAtIndex:thisTabBarController.selectedIndex];
			self.currentViewController = newNav.topViewController;
		}
		else {
			self.currentViewController = [thisTabBarController.viewControllers objectAtIndex:thisTabBarController.selectedIndex];
		}
		
		//create a new state
		State* state = [[State alloc] init];
		state.selfViewController = self.currentViewController;
		state.stateIndex = [[[Globals sharedInstance] statesArray] count];
		state.visitedStateIndex = [self.visitedStates count];
		
		[state setAllUIElementsForState];
		
		State* thisState;
		if (thisTabBarController.selectedIndex == 0)
			thisState = [self.visitedStates lastObject];
		else
			thisState = [state getVisitedStateHeuristicallyForState];
		
		if (thisState) {
			state.stateIndex = thisState.stateIndex;
			state.visitedStateIndex = thisState.visitedStateIndex;
            //[state setAllUIElementsVisitedTrue];
		}
		
		[[[Globals sharedInstance] statesArray] insertObject:state atIndex:[[[Globals sharedInstance] statesArray] count]];
		self.currentState = state;
		[self.currentState setNextState];
		
		if (!thisState) {
			[OutputComponent takeScreenshotOfState:[[[Globals sharedInstance] xmlNodesArray] lastObject]];
			[self.visitedStates insertObject:state atIndex:[self.visitedStates count]];
		}
	}
	//new elements dynamically added or nothing changed, viewcontroller is not changed
	else {
        
        if ([[[Globals sharedInstance] statesArray] count]>1) {
			NSArray *t = [[Globals sharedInstance] statesArray];
			NSUInteger i = [t indexOfObject:currentState]-1;
			State *s = [t objectAtIndex:i];
			if ([currentState.selfViewController isKindOfClass:[s.selfViewController class]]){
				UIElement *element = [self.currentState isElementWithActionLeftForState];
				if(!element)
					[self getPreviousStateAndViewControllerWithoutNextState];
				else if ([element.action isEqualToString:@"UndefinedBackButtonItem"] || [element.action isEqualToString:@"BackBarButtonItem"]) {
					[[[Globals sharedInstance] statesArray] removeLastObject];
					return;
				}
			}
		}

        //create a new state
		State* state = [[State alloc] init];
		state.selfViewController = self.currentState.selfViewController;
		state.stateIndex = self.currentState.stateIndex;
		state.visitedStateIndex = self.currentState.visitedStateIndex;
        NSMutableArray *elements = [NSMutableArray arrayWithArray:self.currentState.uiElementsArray];
        
        if ([state isNewDynamicUIElementAdded:elements]) {
			
			state.stateIndex = [[[Globals sharedInstance] statesArray] count];
			state.visitedStateIndex = [self.visitedStates count];
			
			State* thisState = [state getVisitedStateHeuristicallyForState];
			
			if (thisState) {
				state.stateIndex = thisState.stateIndex;
				state.visitedStateIndex = thisState.visitedStateIndex;
                //[state setAllUIElementsVisitedTrue];
			}
			
			[[[Globals sharedInstance] statesArray] insertObject:state atIndex:[[[Globals sharedInstance] statesArray] count]];
			self.currentState = state;
			[self.currentState setNextState];
			
			if (!thisState) {
                //self.dynamicState++;
				[OutputComponent takeScreenshotOfState:[[[Globals sharedInstance] xmlNodesArray] lastObject]];
				[self.visitedStates insertObject:state atIndex:[self.visitedStates count]];
			}
		}
        else 
            [self.currentState setNextState];
	}
}

- (void)getPreviousStateAndViewController {
	
	if ([[[Globals sharedInstance] statesArray] count]>1) {
		[[[Globals sharedInstance] statesArray] removeObject: self.currentState];
		while(dynamicState>0){
			dynamicState--;
			[[[Globals sharedInstance] statesArray] removeObject: [[[Globals sharedInstance] statesArray] lastObject]];
		}
		
		self.currentState = [[[Globals sharedInstance] statesArray] lastObject];
		self.currentViewController = self.currentState.selfViewController;
		[self.currentState setNextState];
	}
}

- (void)getPreviousStateAndViewControllerWithoutNextState {
	
	if ([[[Globals sharedInstance] statesArray] count]>1) {
		[[[Globals sharedInstance] statesArray] removeObject: self.currentState];
		while(dynamicState>0){
			dynamicState--;
			[[[Globals sharedInstance] statesArray] removeObject: [[[Globals sharedInstance] statesArray] lastObject]];
		}
		
		self.currentState = [[[Globals sharedInstance] statesArray] lastObject];
		self.currentViewController = self.currentState.selfViewController;
	}
}


#pragma mark -
#pragma mark Fire Action Methods
- (void)findClickableElementAndFireAction {
    
    //detecting if a UIAlert is open
    UIAlertView* alertView = [self.currentState doesAlertViewExist];
    if (alertView) {
        [UIElement tapUIAlertView:alertView];
        return;
    }
    //detecting if a UIActionSheet is open
    //UIActionSheet* actionView = [self.currentState doesActionSheetExist];
    //if (actionView){
    //   [UIElement tapUIActionSheetView:actionView];
    //    return;
    //}

	//if any UI elemnt left in the current state
	UIElement *element = [self.currentState isElementWithActionLeftForState];
	if (element) {
        
        [[[Globals sharedInstance] xmlNodesArray] insertObject:[self.currentState setEdgeForStateWithElement:element] atIndex:[[[Globals sharedInstance] xmlNodesArray] count]];
		
		element.visited = TRUE;
		if ([element.action	hasSuffix:@"BarButtonItem"])
			[element tapBarButton];
		
		else if ([element.action isEqualToString:@"UndefinedBackButtonItem"])
			[element tapUndefinedBarButton];
		
		else if ([element.object isKindOfClass:[UITableView class]])
			[element scrollDownInTable];
		
		else if ([element.object isKindOfClass:[UITabBar class]])
			[element tapTabBarItem];
		
		else if ([element.object isKindOfClass:[UITextView class]] || [element.object isKindOfClass:[UITextField class]])
			[element writeIntoTextView];
		
		else if ([element.object isKindOfClass:[UIScrollView class]])
			[element scrollDownView];
		
		else
			[element tapUIElement];
	}
	else {
        //if any tab icon left in the UITabBarController
		UITabBarItem *thisTabBarItem = (UITabBarItem*)self.currentViewController.tabBarItem;
		if (thisTabBarItem) {
			UITabBarController *thisTabBarController = (UITabBarController*)self.currentViewController.tabBarController;
			if (thisTabBarController) {
				if (thisTabBarController.selectedIndex < ([thisTabBarController.viewControllers count] - 1)) {
					thisTabBarController.selectedIndex = thisTabBarController.selectedIndex + 1;
					[self getPreviousStateAndViewControllerWithoutNextState];
					UIElement *element = [self.currentState returnUITabBarElementForState];
					if (element) {
                        [[[Globals sharedInstance] xmlNodesArray] insertObject:[self.currentState setEdgeForStateWithElement:element] atIndex:[[[Globals sharedInstance] xmlNodesArray] count]];
						[element tapTabBarItem];
					}
					return;
				}
				[self getPreviousStateAndViewControllerWithoutNextState];
			}
		}
        //[[[Globals sharedInstance] xmlNodesArray] removeObjectAtIndex:0];
		[OutputComponent writeXMLFile];
        [OutputComponent writeAllStatesElements];
        [OutputComponent writeTestScripts];
		[self release];
		
		int finish = [[NSDate date] timeIntervalSince1970];
		NSLog(@"finish Time : %i", finish);
		// Exit the program when complete
		exit(0);
	}
}

- (void)dealloc {
    [self.globals release];
	[self.visitedStates release];
	[super dealloc];
}

@end
