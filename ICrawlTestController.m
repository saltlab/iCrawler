//
//  ICrawlTestController.m
//
//  Created by Mona on 12-04-07. All rights reserved.
//

#import "ICrawlTestController.h"
#import "UIViewController+Additions.h"
#import "UIView-KIFAdditions.h"
#include <QuartzCore/QuartzCore.h>
#import "KIFTestStep.h"
#import "CGGeometry-KIFAdditions.h"
#import "ICConstants.h"

const float INTER_ACTION_DELAY = 1.0;

extern id objc_msgSend(id theReceiver, SEL theSelector, ...);

static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T') {
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "@";
}

ICrawlTestController *sharedInstance = nil;

@implementation ICrawlTestController

@synthesize currentViewController, visitedStates;
@synthesize globals, currentState, dynamicState; 

#pragma mark -
#pragma mark SharedInstance Methods

+ (ICrawlTestController *)sharedICrawlTest {
	//#if RUN_ICRAWL_TEST
	if (!sharedInstance)
		sharedInstance = [[ICrawlTestController alloc] init];
	//#endif
	return sharedInstance;
}


#pragma mark -
#pragma mark Setup Methods

- (void)start {	
	
	UIWindow *mainWindow = [self mainWindow];
	if (!mainWindow)
	{
		NSLog(@"ICrawlTestController: Couldn't setup.  No main window?");
		return;
	}
	
	//Setup Method Calls
	[self setupOutputUIElementsFile];
	[self setupOutputStateGraphFile];
	[self removeOldScreenshotsDirectory];
	[self setupGlobals];
	
	//Start application testing
	[self performSelector:@selector(runAutoTestingApp:) withObject:START_AUTO_CLICKED afterDelay:INTER_ACTION_DELAY];
}

- (void)setupGlobals {
	//Setup Globals
	self.globals = [[Globals alloc] init];
	self.dynamicState = 0;
}

- (UIWindow *)mainWindow {
	
	NSArray *windows = [[UIApplication sharedApplication] windows];
	if (windows.count == 0)
		return nil;
	
	return [windows objectAtIndex:0];
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
	
	else if ([actionFlag isEqualToString:FLIP_VIEW_CLICKED]) 
		[self getNewViewForViewController];
	
	[self findClickableElementAndFireAction];
}


#pragma mark -
#pragma mark Root View Controller Methods

- (void)setupRootState {
	
	self.visitedStates = [[NSMutableArray alloc] init];
	NSMutableArray *states = [[[NSMutableArray alloc] init] autorelease];
	
	State* state = [[[State alloc] init] autorelease];
	state.stateIndex = [states count];
	state.visitedStateIndex = [self.visitedStates count];
	
	[self initializeRootState:state];
	[self setAllUIElementsForState:state];
	[self setInitialState:state];
	[states addObject:state];
	
	self.currentState = state;
	self.currentViewController = state.selfViewController;
	
	self.globals.statesArray = states;
	[self.visitedStates addObject:state];
	[Globals setSharedInstance:self.globals];
}

- (void)initializeRootState:(State *)state {
	
	id mainController;
	NSObject <UIApplicationDelegate> *appDelegate = (NSObject <UIApplicationDelegate> *)[[UIApplication sharedApplication] delegate];
	Class appDelegateClass = object_getClass(appDelegate);
	
	unsigned int outCount, i;
	objc_property_t *properties = class_copyPropertyList([appDelegateClass class], &outCount);
	for(i = 0; i < outCount; i++) {
		objc_property_t property = properties[i];
		const char *propName = property_getName(property);
		if(propName) {
			NSString *propertyName = [NSString stringWithUTF8String:propName];
			mainController = [appDelegate valueForKey:propertyName];
			
			if ([mainController isKindOfClass:[UINavigationController class]]) {
				//the app starts with NavigationController
				UINavigationController *newNav = (UINavigationController*)mainController;
				self.currentViewController = newNav.topViewController;
				break;
			}
			else if ([mainController isKindOfClass:[UITabBarController class]]) {
				//the app starts with TabBarController
				UITabBarController *thisTabBarController = (UITabBarController*)mainController;
				thisTabBarController.selectedIndex = 0;
				self.currentViewController = thisTabBarController;
				break;
			}
			else if ([mainController isKindOfClass:[UIViewController class]]) {
				//the app starts with a UIViewController
				UIViewController *mainViewController = [appDelegate valueForKey:propertyName];
				self.currentViewController = mainViewController;
				break;
			}
			else if ([mainController isKindOfClass:[UIWindow class]]) {
				//UIWindow *window = [appDelegate valueForKey:propertyName];
				//UIViewController *mainViewController = window.rootViewController;
				//self.currentViewController = mainViewController;
				//break;
			}
		}
	}
	
	free(properties);
	state.selfViewController = currentViewController;
}


#pragma mark -
#pragma mark Next And Pre View Controller Methods

- (void)setupNextStateAndViewController { 
	
	if (self.currentViewController.navigationController && [self isViewPushed]) { 
		
		self.currentViewController = self.currentViewController.navigationController.topViewController;
		
		if ([self.currentViewController isKindOfClass:[UITabBarController class]]) {
			
			UITabBarController* thisTabBarController = (UITabBarController*)self.currentViewController;
			thisTabBarController.selectedIndex = 0;
			self.currentViewController = thisTabBarController;
		}
		//create a new state
		State* state = [[[State alloc] init] autorelease];
		state.selfViewController = self.currentViewController; 
		state.stateIndex = [[[Globals sharedInstance] statesArray] count]; 
		state.visitedStateIndex = [self.visitedStates count];
		
		[self setAllUIElementsForState:state];
		
		//State* thisState = [self getVisitedStateForState:state];
		State* thisState = [self getVisitedStateHeuristicallyForState:state];
		if (thisState) {
			state.stateIndex = thisState.stateIndex; 
			state.visitedStateIndex = thisState.visitedStateIndex;
		} 
		
		[[[Globals sharedInstance] statesArray] insertObject:state atIndex:[[[Globals sharedInstance] statesArray] count]];
		self.currentState = state;
		[self setNextState];
		
		if (!thisState) {
			[self takeScreenshotOfState:[[[Globals sharedInstance] xmlNodesArray] lastObject]];
			[self.visitedStates insertObject:state atIndex:[self.visitedStates count]];
		}
	}
	//viewcontroller is modally presented, need a new state
	else if (self.currentViewController.modalViewController) {
		
		if ([self.currentViewController.modalViewController isKindOfClass:[UINavigationController class]]) {
			UINavigationController *newNav = (UINavigationController*)self.currentViewController.modalViewController;
			self.currentViewController = newNav.topViewController;
		}
		else {
			self.currentViewController = self.currentViewController.modalViewController;
		}
		
		//create a new state
		State* state = [[[State alloc] init] autorelease];
		state.selfViewController = self.currentViewController; 
		state.stateIndex = [[[Globals sharedInstance] statesArray] count]; 
		state.visitedStateIndex = [self.visitedStates count];
		
		[self setAllUIElementsForState:state];
		
		//State* thisState = [self getVisitedStateForState:state];
		State* thisState = [self getVisitedStateHeuristicallyForState:state];
		if (thisState) {
			state.stateIndex = thisState.stateIndex; 
			state.visitedStateIndex = thisState.visitedStateIndex;
		} 
		
		[[[Globals sharedInstance] statesArray] insertObject:state atIndex:[[[Globals sharedInstance] statesArray] count]];
		self.currentState = state;
		[self setNextState];
		
		if (!thisState) {
			[self takeScreenshotOfState:[[[Globals sharedInstance] xmlNodesArray] lastObject]];
			[self.visitedStates insertObject:state atIndex:[self.visitedStates count]];
		}
		//self.currentViewController = self.currentState.selfViewController;
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
		State* state = [[[State alloc] init] autorelease];
		state.selfViewController = self.currentViewController; 
		state.stateIndex = [[[Globals sharedInstance] statesArray] count]; 
		state.visitedStateIndex = [self.visitedStates count];
		
		[self setAllUIElementsForState:state];
		
		State* thisState;
		if (thisTabBarController.selectedIndex == 0)
			thisState = [self.visitedStates lastObject];
		else 
			//thisState = [self getVisitedStateForState:state];
			thisState = [self getVisitedStateHeuristicallyForState:state];
		
		if (thisState) {
			state.stateIndex = thisState.stateIndex; 
			state.visitedStateIndex = thisState.visitedStateIndex;
		} 
		
		[[[Globals sharedInstance] statesArray] insertObject:state atIndex:[[[Globals sharedInstance] statesArray] count]];
		self.currentState = state;
		[self setNextState];
		
		if (!thisState) {
			[self takeScreenshotOfState:[[[Globals sharedInstance] xmlNodesArray] lastObject]];
			[self.visitedStates insertObject:state atIndex:[self.visitedStates count]];
		}
	}
	
	//new element(s) dynamically added or nothing changed, viewcontroller is not changed
	else {
		//create a new state
		State* state = [[[State alloc] init] autorelease];
		state.selfViewController = self.currentState.selfViewController; 
		state.uiElementsArray = self.currentState.uiElementsArray;
		state.stateIndex = self.currentState.stateIndex; 
		state.visitedStateIndex = self.currentState.visitedStateIndex;
		
		if ([self isNewDynamicUIElementAddedToState:state]) {
			
			self.dynamicState++;
			
			NSArray *t = [[Globals sharedInstance] statesArray];
			state.stateIndex = [[[Globals sharedInstance] statesArray] count]; 
			state.visitedStateIndex = [self.visitedStates count];
			
			[[[Globals sharedInstance] statesArray] insertObject:state atIndex:[[[Globals sharedInstance] statesArray] count]];
			self.currentState = state;
			[self setNextState];
			
			[self takeScreenshotOfState:[[[Globals sharedInstance] xmlNodesArray] lastObject]];
			[self.visitedStates insertObject:state atIndex:[self.visitedStates count]];
			
		} else
			[self setNextState];
	}
}

//toggleView, viewcontroller is not changed
- (void)getNewViewForViewController { 
	
	//create a new state
	State* state = [[[State alloc] init] autorelease];
	state.selfViewController = self.currentViewController; 
	state.stateIndex = [[[Globals sharedInstance] statesArray] count]; 
	state.visitedStateIndex = [self.visitedStates count];
	
	[self setAllUIElementsForState:state];
	
	//State* thisState = [self getVisitedStateForState:state];
	State* thisState = [self getVisitedStateHeuristicallyForState:state];
	if (thisState) {
		state.stateIndex = thisState.stateIndex; 
		state.visitedStateIndex = thisState.visitedStateIndex;
	} 
	
	[[[Globals sharedInstance] statesArray] insertObject:state atIndex:[[[Globals sharedInstance] statesArray] count]];
	self.currentState = state;
	[self setNextState];
	
	if (!thisState) {
		[self takeScreenshotOfState:[[[Globals sharedInstance] xmlNodesArray] lastObject]];
		[self.visitedStates insertObject:state atIndex:[self.visitedStates count]];
	}
	
}

- (void)getPreviousStateAndViewController {
	
	if ([[[Globals sharedInstance] statesArray] count]>1) {
		[[[Globals sharedInstance] statesArray] removeObject: self.currentState];
		while(dynamicState>0){
			dynamicState--;
			[[[Globals sharedInstance] statesArray] removeObject: [[[Globals sharedInstance] statesArray] lastObject]];
		}
		
		NSArray *t= [[Globals sharedInstance] xmlNodesArray];
		self.currentState = [[[Globals sharedInstance] statesArray] lastObject];
		self.currentViewController = self.currentState.selfViewController;
		[self setNextState];
	}
	/*if ([[[Globals sharedInstance] statesArray] count]>1) {
		[[[Globals sharedInstance] statesArray] removeObject: self.currentState];
		self.currentState = [[[Globals sharedInstance] statesArray] objectAtIndex:([[[Globals sharedInstance] statesArray] count]-1)];
		self.currentViewController = self.currentState.selfViewController;
		[self setNextState];
	}*/
}


#pragma mark -
#pragma mark Fire Action Methods

- (void)findClickableElementAndFireAction {
	
	//if any UI elemnt left in the UIViewController
	UIElement *element = [self isElementWithActionLeftForState:self.currentState];
	if (element) {
		[self setEdgeForStateWithElement:element];
		element.visited = TRUE;
		if ([element.action	hasSuffix:@"BarButtonItem"])
			[self tapBarButton:element];
		
		else if ([element.action isEqualToString:@"UndefinedBackButtonItem"]) 
			[self tapUndefinedBarButton:element];
		
		else if ([element.object isKindOfClass:[UITableView class]])
			[self scrollDownInTable:element];
		
		else if ([element.object isKindOfClass:[UITabBar class]])
			[self tapTabBarItem:element];
		
		else if ([element.object isKindOfClass:[UITextView class]] || [element.object isKindOfClass:[UITextField class]])
			[self writeIntoTextView:element];
		
		else if ([element.object isKindOfClass:[UIScrollView class]])
			[self scrollDownView:element];
		
		else 
			[self tapUIElement:element];
		
	}
	else {
		
		//if any tab icon left in the UITabBarController
		UITabBarItem *thisTabBarItem = (UITabBarItem*)self.currentViewController.tabBarItem;
		if (thisTabBarItem) {
			UITabBarController *thisTabBarController = (UITabBarController*)self.currentViewController.tabBarController;
			if (thisTabBarController) {
				if (thisTabBarController.selectedIndex < ([thisTabBarController.viewControllers count] - 1)) {
					thisTabBarController.selectedIndex = thisTabBarController.selectedIndex + 1;
					[self getPreviousStateAndViewController];
					UIElement *element = [self returnUITabBarElementForState:self.currentState];
					if (element) 
						[self tapTabBarItem:element];
					return;
				}
				[self getPreviousStateAndViewController];
			}
		}
		// Exit the program when complete
		[self writeXMLFile];
		[self release];
		exit(0);
	}
}

- (UIElement *)isElementWithActionLeftForState:(State*)state {
	
	NSMutableArray *elements = state.uiElementsArray;
	for (UIElement *element in elements) {
		
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

#pragma mark -
#pragma mark State Recognition Methods

- (State *)getVisitedStateForState:(State *)state{
	
	for (State* thisState in self.visitedStates){
		
		if([thisState.selfViewController isKindOfClass:[state.selfViewController class]]){
			if (((thisState.selfViewController.nibName==nil && state.selfViewController.nibName==nil) || (thisState.selfViewController.nibName!=nil && state.selfViewController.nibName!=nil && [thisState.selfViewController.nibName isEqualToString:state.selfViewController.nibName])) &&
				((thisState.selfViewController.title==nil && state.selfViewController.title==nil) || (thisState.selfViewController.title!=nil && state.selfViewController.title!=nil && [thisState.selfViewController.title isEqualToString:state.selfViewController.title])) &&
				
				[thisState.uiElementsArray count] == [state.uiElementsArray count]){
				//compare two uielements
				if ([self isAllUIElementsEqualForState:thisState andState:state]) 
					return thisState;
			}
		}
	}
	return nil;	
}

- (BOOL)isAllUIElementsEqualForState:(State *)state andState:(State *)anotherState {
	
	for(UIElement* e1 in state.uiElementsArray){
		UIElement* e2 = [anotherState.uiElementsArray objectAtIndex:[state.uiElementsArray indexOfObject:e1]];
		if (![self isEqualUIElement:e1 withUIElement:e2]) {
			return FALSE;
		}
	}
	return TRUE;	
}

- (BOOL)isEqualUIElement:(UIElement *)e1 withUIElement:(UIElement *)e2 {
	
	BOOL returnValue = NO;
	
	if((e1.className && e2.className && [e1.className isEqualToString:e2.className]) || (!e1.className && !e2.className))// &&
		
		if(((e1.action!=nil && e2.action!=nil && [e1.action isEqualToString:e2.action]) || (e1.action==nil && e2.action==nil)) ||
		   ([e1.action	hasSuffix:@"UndefinedBackButtonItem"] && [e2.action hasSuffix:@"UndefinedBackButtonItem"])) {
			//if((e1.target && e2.target && [e1.target isEqual:e2.target]) || (!e1.target && !e2.target)) {
			if ([e1.objectClass isSubclassOfClass:UIView.class] && 
				[e2.objectClass isSubclassOfClass:UIView.class]) {
				
				UIView *view1 = (UIView *)e1.objectClass;
				UIView *view2 = (UIView *)e2.objectClass;
				
				if ([view1 isEqual:view2]) 
					//if ((view1.tag && view2.tag) || (view1.tag && view2.tag && view1.tag == view2.tag)) 
					//if (view1.backgroundColor == view2.backgroundColor) //&&
					//if (view1.hidden == view2.hidden) //&&
					//if (view1.userInteractionEnabled == view2.userInteractionEnabled) //&&
					//if ([[e1.object accessibilityLabel] isEqualToString:[e2.object accessibilityLabel]])
					
					returnValue = TRUE;
			}
			else if ([e1.action	hasSuffix:@"BarButtonItem"] && [e2.action hasSuffix:@"BarButtonItem"]) {
				
				UIBarButtonItem *barItem1 = (UIBarButtonItem *)e1.objectClass;
				UIBarButtonItem *barItem2 = (UIBarButtonItem *)e2.objectClass;
				
				if ([barItem1 isEqual:barItem2])
					//if ((barItem1.tag == barItem2.tag) &&
					//	(barItem1.enabled == barItem2.enabled) &&
					//	(barItem1.image == barItem2.image) &&
					//	(barItem1.title == barItem2.title)) 
					
					returnValue = TRUE;
			}	
		}
	
	return returnValue;	
}				

- (State *)getVisitedStateHeuristicallyForState:(State *)state{
	
	int similarity;
	int Threshold;
	
	for (State* thisState in self.visitedStates){
		
		Threshold = WEIGHT_VC_CLASS + WEIGHT_VC_TITLE + WEIGHT_VC_COUNT_GUIS;
		
		similarity = 
		WEIGHT_VC_CLASS*(([thisState.selfViewController class]==[state.selfViewController class]) ? 1 : 0) +
		WEIGHT_VC_TITLE*((thisState.selfViewController.title==state.selfViewController.title) ? 1 : 0) +
		WEIGHT_VC_COUNT_GUIS*(([thisState.uiElementsArray count]==[state.uiElementsArray count]) ? 1 : 0);
	
		//compare two uielements
		for(UIElement* e1 in state.uiElementsArray){
			UIElement* e2 = [thisState.uiElementsArray objectAtIndex:[state.uiElementsArray indexOfObject:e1]];
			
			Threshold = Threshold + WEIGHT_E_CLASS;
			
			similarity = similarity +
			WEIGHT_E_CLASS*(([e1.object class]==[e2.object class]) ? 1 : 0) +
			WEIGHT_E_TARGET*((e1.target==e2.target) ? 1 : 0) +
			WEIGHT_E_ACTION*((e1.action==e2.action) ? 1 : 0);
			
			if ([e1.object class]==[e2.object class]) {
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

		if (similarity >= Threshold) 
			return thisState;
	}
	return nil;
}

#pragma mark -
#pragma mark UI Elements Methods

- (void)setAllUIElementsForState:(State *)state {
	
	DCIntrospect *dcIntrospect = [[DCIntrospect alloc] init];
	NSMutableArray *elements = [[[NSMutableArray alloc] init] autorelease];
	
	if ([state.selfViewController isKindOfClass:[UITableViewController class]]) {
		UITableViewController* thisTableViewController = (UITableViewController*)state.selfViewController;
		[elements addObject:[self addUIElement:thisTableViewController.tableView]];
		[dcIntrospect logPropertiesForObject:thisTableViewController.tableView withViewController:NSStringFromClass([state.selfViewController class]) andStateIndex:state.visitedStateIndex];
	}
	else if ([state.selfViewController.view isKindOfClass:[UITableView class]]) {
		[elements addObject:[self addUIElement:state.selfViewController.view]];
		[dcIntrospect logPropertiesForObject:state.selfViewController.view withViewController:NSStringFromClass([state.selfViewController class]) andStateIndex:state.visitedStateIndex];
	}
	else if ([state.selfViewController isKindOfClass:[UITabBarController class]]) {
		UITabBarController* thisTabBarController = (UITabBarController*)state.selfViewController;
		[elements addObject:[self addUIElement:thisTabBarController.tabBar]];
		[dcIntrospect logPropertiesForObject:thisTabBarController.tabBar withViewController:NSStringFromClass([state.selfViewController class]) andStateIndex:state.visitedStateIndex];
	}
	else {
		[self addAllSubviewsOfView:state.selfViewController.view toArray:elements withState:state withDC:dcIntrospect];
	}
	// If this view controller is inside a navigation controller or tab bar controller, or has been presented modally by another view controller, return it.
	//if ([state.selfViewController.parentViewController isKindOfClass:[UINavigationController class]]) {
	if (state.selfViewController.navigationController) {
			
		if (state.selfViewController.navigationItem.rightBarButtonItem){
			
			[elements addObject:[self addNavigationItem:state.selfViewController.navigationItem.rightBarButtonItem 
											 withAction:@"RightBarButtonItem"]];
			[dcIntrospect logPropertiesForObject:state.selfViewController.navigationItem.rightBarButtonItem 
							  withViewController:NSStringFromClass([state.selfViewController class]) 
								   andStateIndex:state.visitedStateIndex];
		} 
		
		if (state.selfViewController.navigationItem.leftBarButtonItem){	
			
			[elements addObject:[self addNavigationItem:state.selfViewController.navigationItem.leftBarButtonItem 
											 withAction:@"LeftBarButtonItem"]];
			[dcIntrospect logPropertiesForObject:state.selfViewController.navigationItem.leftBarButtonItem 
							  withViewController:NSStringFromClass([state.selfViewController class]) 
								   andStateIndex:state.visitedStateIndex];
		}
		
		else if (state.selfViewController.navigationItem.backBarButtonItem 
			&& !state.selfViewController.navigationItem.hidesBackButton 
			&& state.selfViewController.navigationItem.backBarButtonItem.width>0){
			
			[elements addObject:[self addNavigationItem:state.selfViewController.navigationItem.backBarButtonItem 
											 withAction:@"BackBarButtonItem"]];
			[dcIntrospect logPropertiesForObject:state.selfViewController.navigationItem.backBarButtonItem 
							  withViewController:NSStringFromClass([state.selfViewController class]) 
								   andStateIndex:state.visitedStateIndex];
		}
		else {
			
			UINavigationController* thisNav = (UINavigationController*)state.selfViewController.parentViewController;
			NSArray *thisArray = thisNav.navigationBar.items;
			
			for (UINavigationItem *item in thisArray){
				
				if (item.backBarButtonItem && !item.hidesBackButton && item.backBarButtonItem.width>0) {
					
					[elements addObject:[self addNavigationItem:item.backBarButtonItem withAction:@"BackBarButtonItem"]];
					[dcIntrospect logPropertiesForObject:item.backBarButtonItem 
									  withViewController:NSStringFromClass([state.selfViewController class]) 
										   andStateIndex:state.visitedStateIndex];
					break;
				}
				else if (item.leftBarButtonItem) {
					
					[elements addObject:[self addNavigationItem:item.leftBarButtonItem withAction:@"LeftBarButtonItem"]];
					[dcIntrospect logPropertiesForObject:item.leftBarButtonItem 
									  withViewController:NSStringFromClass([state.selfViewController class]) 
										   andStateIndex:state.visitedStateIndex];
					break;
				}
				else {
					UIView *thisbackButtonView = [item valueForKey:@"_backButtonView"];
					if (thisbackButtonView) {
						[elements addObject:[self addNavigationItemView:thisbackButtonView withAction:@"UndefinedBackButtonItem"]];
						[dcIntrospect logPropertiesForObject:thisbackButtonView 
										  withViewController:NSStringFromClass([state.selfViewController class]) 
											   andStateIndex:state.visitedStateIndex];
						break;
					}
				}
			}
		}
	}
	state.uiElementsArray = elements;
}

- (void)addAllSubviewsOfView:(UIView *)thisView toArray:(NSMutableArray *)elements withState:(State *)state withDC:(DCIntrospect *)dcIntrospect {
	
	NSArray *views = [thisView subviews];
	for(UIView *subview in views) {
		
		if ([subview isKindOfClass:[UINavigationBar class]]) {
			UINavigationBar* thisNavigationBar = (UINavigationBar*)subview;
			NSArray *thisArray = thisNavigationBar.items;
			
			for (UINavigationItem *item in thisArray){
				if (item.backBarButtonItem && !item.hidesBackButton && item.backBarButtonItem.width>0) {
					
					[elements addObject:[self addNavigationItem:item.backBarButtonItem withAction:@"BackBarButtonItem"]];
					[dcIntrospect logPropertiesForObject:item.backBarButtonItem 
									  withViewController:NSStringFromClass([state.selfViewController class]) 
										   andStateIndex:state.visitedStateIndex];
					break;
				}
				else if (item.leftBarButtonItem) {
					[elements addObject:[self addNavigationItem:item.leftBarButtonItem withAction:@"LeftBarButtonItem"]];
					[dcIntrospect logPropertiesForObject:item.leftBarButtonItem 
									  withViewController:NSStringFromClass([state.selfViewController class]) 
										   andStateIndex:state.visitedStateIndex];
					break;
				}
				else {
					UIView *thisBackButtonView = [item valueForKey:@"_backButtonView"];
					//UINavigationItemButtonView 
					if (thisBackButtonView) {
						[elements addObject:[self addNavigationItemView:thisBackButtonView withAction:@"UndefinedBackButtonItem"]];
						[dcIntrospect logPropertiesForObject:thisBackButtonView 
										  withViewController:NSStringFromClass([state.selfViewController class]) 
											   andStateIndex:state.visitedStateIndex];
						break;
					}
				}
			}
		}
		else if (![subview isKindOfClass:[UITableView class]] && [subview isKindOfClass:[UIScrollView class]]) {
			[elements addObject:[self addUIElement:subview]];
			[dcIntrospect logPropertiesForObject:subview withViewController:NSStringFromClass([state.selfViewController class]) andStateIndex:state.visitedStateIndex];
			[self addAllSubviewsOfView:subview toArray:elements withState:state withDC:dcIntrospect];	
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
				   || ([subview isKindOfClass:[UIWindow class]]) 
				   || ([subview isKindOfClass:[UITableView class]]) 
				   || ([subview isKindOfClass:[UIActivityIndicatorView class]]))){
			
			[self addAllSubviewsOfView:subview toArray:elements withState:state withDC:dcIntrospect];	
		} else {
			[elements addObject:[self addUIElement:subview]];
			[dcIntrospect logPropertiesForObject:subview withViewController:NSStringFromClass([state.selfViewController class]) andStateIndex:state.visitedStateIndex];
		}
	}
}		 	

- (UIElement *)addUIElement:(id)object {
	
	Class objectClass = [object class];
	NSString *className = [NSString stringWithFormat:@"%@", objectClass];
	
	UIElement *element = [[UIElement alloc] init];
	element.className = className;
	element.objectClass = objectClass;
	element.object = object;
	// list targets if there are any
	[self addActionForTargetUIElement:element];
	
	return element;
}

- (void)addActionForTargetUIElement:(UIElement *)element {
	
	if ([element.object respondsToSelector:@selector(allTargets)]) {
		
		UIControl *control = (UIControl *)element.object;
		UIControlEvents controlEvents = [control allControlEvents];
		NSSet *allTargets = [control allTargets];
		[allTargets enumerateObjectsUsingBlock:^(id target, BOOL *stop)
		 {
			 element.target = target;
			 NSArray *actions = [control actionsForTarget:target forControlEvent:controlEvents];
			 [actions enumerateObjectsUsingBlock:^(id action, NSUInteger idx, BOOL *stop2)
			  {
				  element.action = (NSString *)action;
			  }];
		 }];
    } 
}

- (UIElement *)addNavigationItem:(UIBarButtonItem *)barButtonItem withAction:(NSString *)action {
	
	UIElement *element = [[UIElement alloc] init];
	element.action = action;
	element.target = barButtonItem.target;
	element.object = (id)barButtonItem;
	element.objectClass = [element.object class];
	return element;
}

- (UIElement *)addNavigationItemView:(UIView *)thisbackButtonView withAction:(NSString *)action {
	
	UIElement *element = [[UIElement alloc] init];
	element.action = action;
	element.target = nil;
	element.object = (id) thisbackButtonView;
	element.objectClass = [element.object class];
	return element;
}

- (BOOL)isNewDynamicUIElementAddedToState:(State *)state {
	BOOL isAdded = FALSE;
	DCIntrospect *dcIntrospect = [[[DCIntrospect alloc] init] autorelease];
	
	if (state.uiElementsArray) {
		//check for new subviews
		NSMutableArray *views = [[[NSMutableArray alloc] init] autorelease];
		[self addAllSubviewsOfView:state.selfViewController.view toArray:views];
		UIElement *e;
		BOOL returnVal = FALSE;
		
		for(UIView *subview in views) {
			
			e = [self addUIElement:subview];
			for(UIElement* e2 in state.uiElementsArray){
				if ([self isEqualUIElement:e withUIElement:e2]) {
					returnVal = TRUE;
					break;
				}
			}
			if (!returnVal) {
				//e is a new element
				isAdded = TRUE;
				[state.uiElementsArray addObject:e];
				[dcIntrospect logPropertiesForObject:subview withViewController:NSStringFromClass([state.selfViewController class]) andStateIndex:state.visitedStateIndex];
			}
			returnVal = FALSE;
		}
		
		//check for new navigation items
		if ([state.selfViewController.parentViewController isKindOfClass:[UINavigationController class]]) { 
			
			if (state.selfViewController.navigationItem.rightBarButtonItem) {
				
				e = [self addNavigationItem:state.selfViewController.navigationItem.rightBarButtonItem withAction:@"RightBarButtonItem"];
				returnVal = FALSE;
				
				for(UIElement* e2 in state.uiElementsArray){
					if ([self isEqualUIElement:e withUIElement:e2]) {
						returnVal = TRUE;
						break;
					}
				}
				if (!returnVal) {
					//e is a new element
					isAdded = TRUE;
					[state.uiElementsArray addObject:e];
					[dcIntrospect logPropertiesForObject:state.selfViewController.navigationItem.rightBarButtonItem withViewController:NSStringFromClass([state.selfViewController class]) andStateIndex:state.visitedStateIndex];
				}
			} 
			if (state.selfViewController.navigationItem.backBarButtonItem && !state.selfViewController.navigationItem.hidesBackButton && state.selfViewController.navigationItem.backBarButtonItem.width>0){
				
				e = [self addNavigationItem:state.selfViewController.navigationItem.backBarButtonItem withAction:@"BackBarButtonItem"];
				returnVal = FALSE;
				
				for(UIElement* e2 in state.uiElementsArray){
					if ([self isEqualUIElement:e withUIElement:e2]) {
						returnVal = TRUE;
						break;
					}
				}
				if (!returnVal) {
					//e is a new element
					isAdded = TRUE;
					[state.uiElementsArray addObject:e];
					[dcIntrospect logPropertiesForObject:state.selfViewController.navigationItem.backBarButtonItem withViewController:NSStringFromClass([state.selfViewController class]) andStateIndex:state.visitedStateIndex];
				}
			}
			else if (state.selfViewController.navigationItem.leftBarButtonItem){	
				
				e = [self addNavigationItem:state.selfViewController.navigationItem.leftBarButtonItem withAction:@"LeftBarButtonItem"];
				returnVal = FALSE;
				
				for(UIElement* e2 in state.uiElementsArray){
					if ([self isEqualUIElement:e withUIElement:e2]) {
						returnVal = TRUE;
						break;
					}
				}
				if (!returnVal) {
					//e is a new element
					isAdded = TRUE;
					[state.uiElementsArray addObject:e];
					[dcIntrospect logPropertiesForObject:state.selfViewController.navigationItem.leftBarButtonItem withViewController:NSStringFromClass([state.selfViewController class]) andStateIndex:state.visitedStateIndex];
				}
			}
			else {
				UINavigationController* thisNavigationController = (UINavigationController*)state.selfViewController.parentViewController;
				NSArray *thisArray = thisNavigationController.navigationBar.items;
				for (UINavigationItem *item in thisArray){
					if (item.backBarButtonItem && !item.hidesBackButton && item.backBarButtonItem.width>0 && ![state.uiElementsArray containsObject:item.backBarButtonItem]) {
						
						e = [self addNavigationItem:item.backBarButtonItem withAction:@"BackBarButtonItem"];
						returnVal = FALSE;
						
						for(UIElement* e2 in state.uiElementsArray){
							if ([self isEqualUIElement:e withUIElement:e2]) {
								returnVal = TRUE;
								break;
							}
						}
						if (!returnVal) {
							//e is a new element
							isAdded = TRUE;
							[state.uiElementsArray addObject:e];
							[dcIntrospect logPropertiesForObject:item.backBarButtonItem withViewController:NSStringFromClass([state.selfViewController class]) andStateIndex:state.visitedStateIndex];
							break;
						}
					}
					else if (item.leftBarButtonItem) {
						
						e = [self addNavigationItem:item.leftBarButtonItem withAction:@"LeftBarButtonItem"];
						returnVal = FALSE;
						
						for(UIElement* e2 in state.uiElementsArray){
							if ([self isEqualUIElement:e withUIElement:e2]) {
								returnVal = TRUE;
								break;
							}
						}
						if (!returnVal) {
							//e is a new element
							isAdded = TRUE;
							[state.uiElementsArray addObject:e];
							[dcIntrospect logPropertiesForObject:item.leftBarButtonItem withViewController:NSStringFromClass([state.selfViewController class]) andStateIndex:state.visitedStateIndex];
							break;
						}
					}
					else {
						UIView *thisBackButtonView = [item valueForKey:@"_backButtonView"];
						//UINavigationItemButtonView 
						if (thisBackButtonView) {
							
							e = [self addNavigationItemView:thisBackButtonView withAction:@"UndefinedBackButtonItem"];
							returnVal = FALSE;
							
							for(UIElement* e2 in state.uiElementsArray){
								if ([self isEqualUIElement:e withUIElement:e2]) {
									returnVal = TRUE;
									break;
								}
							}
							if (!returnVal) {
								//e is a new element
								isAdded = TRUE;
								[state.uiElementsArray addObject:e];
								[dcIntrospect logPropertiesForObject:thisBackButtonView withViewController:NSStringFromClass([state.selfViewController class]) andStateIndex:state.visitedStateIndex];
								break;
							}
						}
					}
				}
			}
		}
	}
	return isAdded;
}

- (void)addAllSubviewsOfView:(UIView *)thisView toArray:(NSMutableArray *)elements {
	
	if ([thisView isKindOfClass:[UITableView class]] ) {
		[elements addObject:thisView];
	}
	else {
		
		NSArray *views = [thisView subviews];
		for(UIView *subview in views) {
			
			if ([subview isKindOfClass:[UINavigationBar class]]) {
				UINavigationBar* thisNavigationBar = (UINavigationBar*)subview;
				NSArray *thisArray = thisNavigationBar.items;
				
				for (UINavigationItem *item in thisArray){
					if (item.backBarButtonItem && !item.hidesBackButton && item.backBarButtonItem.width>0) {
						
						[elements addObject:subview];
						break;
					}
					else if (item.leftBarButtonItem) {
						[elements addObject:subview];
						break;
					}
					else {
						UIView *thisBackButtonView = [item valueForKey:@"_backButtonView"];
						//UINavigationItemButtonView 
						if (thisBackButtonView) {
							[elements addObject:subview];
							break;
						}
					}
				}
			}
			
			else if (![subview isKindOfClass:[UITableView class]] && [subview isKindOfClass:[UIScrollView class]]) {
				[elements addObject:subview];
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
					   || ([subview isKindOfClass:[UIWindow class]]) 
					   || ([subview isKindOfClass:[UITableView class]])
					   || ([subview isKindOfClass:[UIActivityIndicatorView class]]))){
				
				[self addAllSubviewsOfView:subview toArray:elements];	
			} else 
				[elements addObject:subview];
		}
	}
}	



#pragma mark -
#pragma mark State Methods

- (void)setInitialState:(State *)state {
	
	NSMutableArray *nodes = [[[NSMutableArray alloc] init] autorelease];
	XMLNode* thisNode = [[[XMLNode alloc] init] autorelease];
	thisNode.currentStateIndex = state.visitedStateIndex;
	thisNode.edge = @"";
	thisNode.preStateIndex = 0;
	[nodes addObject:thisNode];
	
	[self createScreenshotsDirectory];
	[self takeScreenshotOfState:thisNode];
	self.globals.xmlNodesArray = nodes;
}

- (void)setEdgeForStateWithElement:(UIElement *)element {
	XMLNode* thisNode = [[[XMLNode alloc] init] autorelease];
	
	if ([element.action isEqualToString:@"LeftBarButtonItem"] || [element.action isEqualToString:@"BackBarButtonItem"] || [element.action isEqualToString:@"UndefinedBackButtonItem"]) 
	{
		thisNode.preStateIndex = self.currentState.visitedStateIndex; 
		thisNode.edge = element.action;
		thisNode.currentStateIndex = (self.currentState.stateIndex - 1);
	}
	else {
		NSArray *t= [[Globals sharedInstance] xmlNodesArray];
		//thisNode.preStateIndex = self.currentState.visitedStateIndex;
		XMLNode *node = [t lastObject];
		thisNode.preStateIndex = node.currentStateIndex;
		
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
	
	NSArray *t= [[Globals sharedInstance] xmlNodesArray];
	[[[Globals sharedInstance] xmlNodesArray] insertObject:thisNode atIndex:[[[Globals sharedInstance] xmlNodesArray] count]];
}

- (void)setNextState {
	NSArray *t= [[Globals sharedInstance] xmlNodesArray];
	XMLNode* thisNode = [[[Globals sharedInstance] xmlNodesArray] lastObject];
	thisNode.currentStateIndex = self.currentState.visitedStateIndex;	
}


#pragma mark -
#pragma mark Tap Methods

- (void)tapTabBarItem:(UIElement *)element {
	UITabBar *tabBar = (UITabBar*)element.object;
	
	if (!tabBar.hidden && tabBar.userInteractionEnabled) {
		UITabBarItem *item = tabBar.selectedItem;
		UIView *itemView = [item valueForKey:@"_view"];
		if (itemView) {
			[itemView tap];
			[self performSelector:@selector(runAutoTestingApp:) withObject:NEXT_ACTION_CLICKED afterDelay:INTER_ACTION_DELAY];
		}
	}
}

- (void)scrollDownInTable:(UIElement *)element {
	UITableView *tableView = (UITableView*)element.object;
	
	if (!tableView.hidden && tableView.userInteractionEnabled && tableView.scrollEnabled) {
		NSIndexPath* indexPath = [NSIndexPath indexPathForRow: [tableView numberOfRowsInSection:[tableView numberOfSections]-1]-1 inSection: [tableView numberOfSections]-1];
		[tableView scrollToRowAtIndexPath:indexPath atScrollPosition: UITableViewScrollPositionTop animated: YES];
		[self performSelector:@selector(scrollUpInTable:) withObject:element afterDelay:INTER_ACTION_DELAY];
	}
	else
		[self tapTableCell:element];
	
}

- (void)scrollUpInTable:(UIElement *)element {
	UITableView *tableView = (UITableView*)element.object;
	
	if (!tableView.hidden && tableView.userInteractionEnabled && tableView.scrollEnabled) {
		NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
		[tableView scrollToRowAtIndexPath:indexPath atScrollPosition: UITableViewScrollPositionTop animated: YES];
		[self performSelector:@selector(tapTableCell:) withObject:element afterDelay:INTER_ACTION_DELAY];
	}
	else
		[self tapTableCell:element];
}

- (void)tapTableCell:(UIElement *)element {
	UITableView *tableView = (UITableView*)element.object;
	
	if (tableView.allowsSelection) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		if ([currentViewController respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
			CGRect cellFrame = [cell.contentView convertRect:[cell.contentView frame] toView:tableView];
			[tableView tapAtPoint:CGPointCenteredInRect(cellFrame)];
		} 
		else if ([currentViewController respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)]) {
			UIView  *accessoryView = [cell valueForKey:@"_accessoryView"];
			[accessoryView tap];
		}
		
		[self performSelector:@selector(runAutoTestingApp:) withObject:NEXT_ACTION_CLICKED afterDelay:INTER_ACTION_DELAY];
	}
}

- (void)scrollDownView:(UIElement *)element {
	UIScrollView *scrollView = (UIScrollView*)element.object;
	
	if (!scrollView.hidden && scrollView.userInteractionEnabled && scrollView.scrollEnabled) {
		CGPoint bottomOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.bounds.size.height);
		[scrollView setContentOffset:bottomOffset animated:YES];
		[self performSelector:@selector(scrollUpView:) withObject:element afterDelay:(INTER_ACTION_DELAY/2)];
	}
	else
		[self performSelector:@selector(runAutoTestingApp:) withObject:NO_ACTION_CLICKED afterDelay:(INTER_ACTION_DELAY/2)];	
}

- (void)scrollUpView:(UIElement *)element {
	UIScrollView *scrollView = (UIScrollView*)element.object;
	
	if (!scrollView.hidden && scrollView.userInteractionEnabled && scrollView.scrollEnabled) {
		CGPoint topOffset = CGPointMake(0,0);
		[scrollView setContentOffset:topOffset animated:YES];
		[self performSelector:@selector(runAutoTestingApp:) withObject:NO_ACTION_CLICKED afterDelay:(INTER_ACTION_DELAY/2)];
	}
	else
		[self performSelector:@selector(runAutoTestingApp:) withObject:NO_ACTION_CLICKED afterDelay:(INTER_ACTION_DELAY/2)];	
}

- (void)writeIntoTextView:(UIElement *)element {
	
	NSString *text = @"This is a test!";
	UIView * view = (UIView *)element.object;
	if ([view isKindOfClass:[UITextView class]]) {
		CGRect elementFrame = [view.window convertRect:element.accessibilityFrame toView:view];
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
	
	// tap enter or done button on keyboard
	if ([self.currentViewController respondsToSelector:@selector(textFieldShouldReturn:)]) 
		[self.currentViewController performSelector:@selector(textFieldShouldReturn:) withObject:view afterDelay:INTER_ACTION_DELAY];
	
	//[self performSelector:@selector(runAutoTestingApp:) withObject:NEXT_ACTION_CLICKED afterDelay:INTER_ACTION_DELAY];
	
	UINavigationController *thisNav = self.currentViewController.navigationController;
	
	if ([self isViewPopedFromNavigationController:thisNav]) 
		[self performSelector:@selector(runAutoTestingApp:) withObject:BACK_BUTTON_CLICKED afterDelay:INTER_ACTION_DELAY];
	else if ([self isViewDismissed]) 
		[self performSelector:@selector(runAutoTestingApp:) withObject:BACK_BUTTON_CLICKED afterDelay:INTER_ACTION_DELAY];
	else
		[self performSelector:@selector(runAutoTestingApp:) withObject:NEXT_ACTION_CLICKED afterDelay:INTER_ACTION_DELAY];
}

- (void)tapUIElement:(UIElement *)element {
	UINavigationController *thisNav = self.currentViewController.navigationController;
	UIView * view = (UIView *)element.object;
	if (!view.hidden && view.userInteractionEnabled){
		[view tap];
		
		if ([self isViewPopedFromNavigationController:thisNav]) 
			[self performSelector:@selector(runAutoTestingApp:) withObject:BACK_BUTTON_CLICKED afterDelay:INTER_ACTION_DELAY];
		else if ([self isViewDismissed]) 
			[self performSelector:@selector(runAutoTestingApp:) withObject:BACK_BUTTON_CLICKED afterDelay:INTER_ACTION_DELAY];
		else
			[self performSelector:@selector(runAutoTestingApp:) withObject:NEXT_ACTION_CLICKED afterDelay:INTER_ACTION_DELAY];
		//[self performSelector:@selector(runAutoTestingApp:) withObject:NEXT_ACTION_CLICKED afterDelay:INTER_ACTION_DELAY];
	}
}

- (void)tapUndefinedBarButton:(UIElement *)element {
	
	UITabBarController *thisTabBarController = (UITabBarController*)self.currentViewController.tabBarController;
	UINavigationController *thisNavigationController = (UINavigationController*)self.currentViewController.navigationController;
	if ([thisNavigationController.viewControllers count]==1 && [thisNavigationController.viewControllers objectAtIndex:0]==self.currentViewController && thisTabBarController!=nil) {
		UITabBarItem *thisTabBarItem = (UITabBarItem*)self.currentViewController.tabBarItem;
		if (thisTabBarItem) {
			if (thisTabBarController.selectedIndex < ([thisTabBarController.viewControllers count] - 1)) {
				thisTabBarController.selectedIndex = thisTabBarController.selectedIndex + 1;
				[self getPreviousStateAndViewController];
				UIElement *element = [self returnUITabBarElementForState:self.currentState];
				if (element) 
					[self tapTabBarItem:element];
				return;
			}
			[self getPreviousStateAndViewController];
		}
	}
	
	UINavigationController *thisNav = self.currentViewController.navigationController;
	UIView * view = (UIView *)element.object;
	if (!view.hidden){ 
		[view tap];
		
		if ([self isViewPopedFromNavigationController:thisNav]) 
			[self performSelector:@selector(runAutoTestingApp:) withObject:BACK_BUTTON_CLICKED afterDelay:INTER_ACTION_DELAY];
		else if ([self isViewDismissed]) 
			[self performSelector:@selector(runAutoTestingApp:) withObject:BACK_BUTTON_CLICKED afterDelay:INTER_ACTION_DELAY];
		else
			[self performSelector:@selector(runAutoTestingApp:) withObject:NEXT_ACTION_CLICKED afterDelay:INTER_ACTION_DELAY];
	}
}

- (void)tapBarButton:(UIElement *)element {
	
	UITabBarController *thisTabBarController = (UITabBarController*)self.currentViewController.tabBarController;
	UINavigationController *thisNavigationController = (UINavigationController*)self.currentViewController.navigationController;
	
	if ([thisNavigationController.viewControllers count]==1 && [thisNavigationController.viewControllers objectAtIndex:0]==self.currentViewController && thisTabBarController!=nil) {
		UITabBarItem *thisTabBarItem = (UITabBarItem*)self.currentViewController.tabBarItem;
		if (thisTabBarItem) {
			if (thisTabBarController.selectedIndex < ([thisTabBarController.viewControllers count] - 1)) {
				thisTabBarController.selectedIndex = thisTabBarController.selectedIndex + 1;
				[self getPreviousStateAndViewController];
				UIElement *element = [self returnUITabBarElementForState:self.currentState];
				if (element) 
					[self tapTabBarItem:element];
				return;
			}
			[self getPreviousStateAndViewController];
		}
	}
	
	UIBarButtonItem *barItem = (UIBarButtonItem *)element.object;
	UINavigationController *thisNav = self.currentViewController.navigationController;
	
	if (barItem.customView) {
		UIView * view = (UIView *)barItem.customView;
		[view tap];
	}
	else if (barItem.target && barItem.action) 
		[barItem.target performSelector:barItem.action];
	
	if ([self isViewPopedFromNavigationController:thisNav]) 
		[self performSelector:@selector(runAutoTestingApp:) withObject:BACK_BUTTON_CLICKED afterDelay:INTER_ACTION_DELAY];
	else if ([self isViewDismissed]) 
		[self performSelector:@selector(runAutoTestingApp:) withObject:BACK_BUTTON_CLICKED afterDelay:INTER_ACTION_DELAY];
	else
		[self performSelector:@selector(runAutoTestingApp:) withObject:NEXT_ACTION_CLICKED afterDelay:INTER_ACTION_DELAY];
}

- (UIElement *)returnUITabBarElementForState:(State*)state {
	
	NSMutableArray *elements = state.uiElementsArray;
	for (UIElement *element in elements) {
		if ([element.object isKindOfClass:[UITabBar class]])
			return element;
	}
	return nil;
}	

#pragma mark -
#pragma mark View Related Helper Methods

- (BOOL)isViewPushed {
	UINavigationController *thisNav = self.currentViewController.navigationController;
	NSArray *viewControllers = thisNav.viewControllers;
	// View is disappearing because a new view controller was pushed onto the stack, need a new state
	if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self.currentViewController)
		return TRUE;
	
	return FALSE;
}

- (BOOL)isViewPopedFromNavigationController:(UINavigationController *)thisNav {
	UIViewController *disappearingViewController = [thisNav valueForKey:@"_disappearingViewController"];
	NSArray *viewControllers = thisNav.viewControllers;
	// View is disappearing because it was popped from the stack
	if ((disappearingViewController == self.currentViewController) && ([viewControllers indexOfObject:self.currentViewController] == NSNotFound)) 
		return TRUE;
	
	return FALSE;
}

- (BOOL)isViewDismissed {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IC_isDismissed"]) {
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IC_isDismissed"];
		return TRUE;
	}
	return FALSE;
}

- (void)viewDismissed {
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IC_isDismissed"];
}


#pragma mark -
#pragma mark Directory Related Methods

- (void)setupOutputUIElementsFile {
	//Grab and empty a reference to the output txt file
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [[NSString alloc] initWithFormat:@"%@",[documentsDirectory stringByAppendingPathComponent:@"logUIElements.txt"]];
	[@"" writeToFile:path atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
}

- (void)setupOutputStateGraphFile {
	//Grab and empty a reference to the output txt file
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [[NSString alloc] initWithFormat:@"%@",[documentsDirectory stringByAppendingPathComponent:@"logStateGraph.xml"]];
	[@"" writeToFile:path atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
}

- (void)removeOldScreenshotsDirectory {
	// Attempt to delete the file at documentsDirectory
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *directory = [documentsDirectory stringByAppendingPathComponent: @"/Screenshots"];   
	
	NSFileManager *fileManager= [NSFileManager defaultManager]; 
	if([fileManager fileExistsAtPath:directory])
		if(![fileManager removeItemAtPath:directory error:NULL])
			NSLog(@"Error: Delete folder failed %@", directory);
}

- (void)createScreenshotsDirectory {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *directory = [documentsDirectory stringByAppendingPathComponent: @"/Screenshots"];   
	
	NSFileManager *fileManager= [NSFileManager defaultManager]; 
	if(![fileManager fileExistsAtPath:directory])
		if(![fileManager createDirectoryAtPath:directory withIntermediateDirectories:NO attributes:nil error:NULL])
			NSLog(@"Error: Create folder failed %@", directory);
} 

- (void)takeScreenshotOfState:(XMLNode *)node {
	
	UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];   
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *directory = [documentsDirectory stringByAppendingPathComponent: @"/Screenshots"];   
	NSString *path = [[NSString alloc] initWithFormat:@"%@",[directory stringByAppendingPathComponent:[NSString stringWithFormat:@"S%d.jpg", node.currentStateIndex]]];
	[UIImageJPEGRepresentation(img, 1.0) writeToFile:path atomically:NO];
} 

- (void)outputUIElementsFile: (NSMutableString *)outputString {
	// Create paths All UIElements to output txt file
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [[NSString alloc] initWithFormat:@"%@",[documentsDirectory stringByAppendingPathComponent:@"logUIElements.txt"]];
	freopen([path cStringUsingEncoding:NSASCIIStringEncoding],"a+",stdout);
	NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:path];
	[fileHandler seekToEndOfFile];
	[fileHandler writeData:[outputString dataUsingEncoding:NSUTF8StringEncoding]];
	[fileHandler closeFile];
}

- (void)outputStateGraphFile: (NSMutableString *)outputString {
	// Create paths to State Graph output txt file
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [[NSString alloc] initWithFormat:@"%@",[documentsDirectory stringByAppendingPathComponent:@"logStateGraph.xml"]];
	freopen([path cStringUsingEncoding:NSASCIIStringEncoding],"a+",stdout);
	NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:path];
	[fileHandler seekToEndOfFile];
	[fileHandler writeData:[outputString dataUsingEncoding:NSUTF8StringEncoding]];
	[fileHandler closeFile];
}

//http://code.google.com/p/xswi/source/browse/trunk/xswi/Classes/?r=122
- (void) writeXMLFile {
	XMLWriter* xmlWriter = [[XMLWriter alloc]init];
	
	//NSString* xsNamespace = @"http://www.w3.org/2001/XMLSchema";
	//[xmlWriter setPrefix:@"xs" namespaceURI:xsNamespace];
	//[xmlWriter writeStartElementWithNamespace:xsNamespace localName:@"schema"];
	//[xmlWriter writeStartElementWithNamespace:xsNamespace localName:@"complexType"];
	
	[xmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
	
	[xmlWriter writeStartElement:@"States"];
	
	NSArray *nodesArray =[[Globals sharedInstance] xmlNodesArray];
	for(XMLNode * node in nodesArray) 
		[self logPropertiesForState:node inTo:xmlWriter];
	
	[xmlWriter writeEndElement];	
	
	// Create paths to output txt file
	[self outputStateGraphFile:[xmlWriter toString]];
	
	[xmlWriter release];
}

- (void)logPropertiesForState:(XMLNode *)node inTo:(XMLWriter*) xmlWriter {
	[xmlWriter writeStartElement:@"State"];
	
	[xmlWriter writeStartElement:@"PreviousState"];
	[xmlWriter writeCharacters:[NSString stringWithFormat:@"State%i", node.preStateIndex]];
	[xmlWriter writeEndElement];
	
	[xmlWriter writeStartElement:@"CurrentState"];
	[xmlWriter writeCharacters:[NSString stringWithFormat:@"State%i", node.currentStateIndex]];
	[xmlWriter writeEndElement];
	
	[xmlWriter writeStartElement:@"Edge"];
	[xmlWriter writeCharacters:node.edge];
	[xmlWriter writeEndElement];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *directory = [documentsDirectory stringByAppendingPathComponent: @"/Screenshots"];   
	NSString *path = [[NSString alloc] initWithFormat:@"%@",[directory stringByAppendingPathComponent:[NSString stringWithFormat:@"S%d.jpg", node.currentStateIndex]]];
	[xmlWriter writeStartElement:@"ScreenshotPath"];
	[xmlWriter writeCharacters:path];
	[xmlWriter writeEndElement];
	
	[xmlWriter writeEndElement];
	
}

	
- (void)dealloc {
    [self.globals release];
	[self.visitedStates release];
	[super dealloc];
}

@end
