//
//  ICrawlTestController.h
//
//  Created by Mona on 12-04-07. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "State.h"
#import "UIElement.h"
#import "Globals.h"
#import "XMLNode.h"
#import "XMLWriter.h"
#import "DCIntrospect.h"
#import <objc/runtime.h>

@interface ICrawlTestController : NSObject {
	
	UIViewController *currentViewController;
	Globals *globals;
	State *currentState;
	NSMutableArray *visitedStates;
	int dynamicState;
}

@property(nonatomic, retain) UIViewController *currentViewController;
@property(nonatomic, retain) Globals *globals;
@property(nonatomic, retain) State *currentState;
@property(nonatomic, retain) NSMutableArray *visitedStates;
@property(nonatomic, assign) int dynamicState;


//pragma mark SharedInstance
+ (ICrawlTestController *)sharedICrawlTest;		// this returns nil when NOT in DEGBUG mode


//pragma mark Setup Methods
- (void)start;		
- (void)setupGlobals;
- (UIWindow *)mainWindow;


//pragma mark Main Methods
- (void)runAutoTestingApp:(NSString *)tag;


//pragma mark Root View Controller Methods
- (void)setupRootState;
- (void)initializeRootState:(State *)state;


//pragma mark Next And Pre View Controller Methods
- (void)setupNextStateAndViewController;
- (void)getPreviousStateAndViewController;
- (void)getNewViewForViewController;


//pragma mark State Recognition Methods
- (State *)getVisitedStateHeuristicallyForState:(State *)state;
- (State *)getVisitedStateForState:(State *)state;
- (BOOL)isAllUIElementsEqualForState:(State *)state andState:(State *)anotherState;
- (BOOL)isEqualUIElement:(UIElement *)e1 withUIElement:(UIElement *)e2;


//pragma mark Fire Action Methods
- (void)findClickableElementAndFireAction;


//pragma mark UI Elements Methods
- (void)setAllUIElementsForState:(State *)state;
- (UIElement *)addUIElement:(id)object;
- (void)addActionForTargetUIElement:(UIElement *)element;
- (UIElement *)addNavigationItem:(UIBarButtonItem *)barButtonItem withAction:(NSString *)action;
- (UIElement *)addNavigationItemView:(UIView *)thisbackButtonView withAction:(NSString *)action;
- (BOOL)isNewDynamicUIElementAddedToState:(State *)state;
- (void)addAllSubviewsOfView:(UIView *)thisView toArray:(NSMutableArray *)elements withState:(State *)state withDC:(DCIntrospect *)dcIntrospect;
- (void)addAllSubviewsOfView:(UIView *)thisView toArray:(NSMutableArray *)elements;


//pragma mark Tap Methods
- (void)tapUIElement:(UIElement *)element;
- (void)tapBarButton:(UIElement *)element;
- (void)tapUndefinedBarButton:(UIElement *)element;
- (void)scrollDownInTable:(UIElement *)element;
- (void)scrollUpInTable:(UIElement *)element;
- (void)tapTableCell:(UIElement *)element;
- (void)writeIntoTextView:(UIElement *)element;
- (void)tapTabBarItem:(UIElement *)element;
- (void)scrollDownView:(UIElement *)element;
- (void)scrollUpView:(UIElement *)element;


//pragma mark View Related Helper Methods
- (BOOL)isViewPushed;
- (BOOL)isViewPopedFromNavigationController:(UINavigationController *)thisNav;
- (BOOL)isViewDismissed;
- (void)viewDismissed;

//pragma mark XMLNode Methods
- (void)setInitialState:(State *)state;
- (void)setEdgeForStateWithElement:(UIElement *)element;
- (void)setNextState;


//pragma mark State Helper Methods
- (UIElement *)isElementWithActionLeftForState:(State*)state;
- (UIElement *)returnUITabBarElementForState:(State*)state;


//pragma mark Directory Related Methods
- (void)setupOutputUIElementsFile;
- (void)setupOutputStateGraphFile;
- (void)outputUIElementsFile: (NSMutableString *)outputString;
- (void)outputStateGraphFile: (NSMutableString *)outputString;
- (void)createScreenshotsDirectory;
- (void)removeOldScreenshotsDirectory;
- (void)takeScreenshotOfState:(XMLNode *)node;
- (void)logPropertiesForState:(XMLNode *)node inTo:(XMLWriter*) xmlWriter;
- (void)writeXMLFile;



@end
