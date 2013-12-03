//
//  State.h
//
//  Created by Mona on 12-04-07. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLNode.h"
#import "UIElement.h"

@interface State : NSObject

@property(nonatomic, retain) NSMutableArray *uiElementsArray;
@property(nonatomic, retain) UIViewController *selfViewController;
@property(nonatomic, assign) int stateIndex;
@property(nonatomic, assign) int visitedStateIndex;


+ (NSMutableArray*)setInitialState:(State*)state;
- (XMLNode*)setEdgeForStateWithElement:(UIElement*)element;
- (void)setNextState;
- (UIViewController*)initializeRootState;
- (BOOL)isNewDynamicUIElementAdded:(NSMutableArray*)elements;
- (UIElement*)isElementWithActionLeftForState;
- (void)setAllUIElementsForState;
- (void)addAllSubviewsOfView:(UIView*)thisView toArray:(NSMutableArray*)elements;
- (State*)getVisitedStateHeuristicallyForState;
- (State*)getVisitedStateForState;
- (BOOL)isAllUIElementsEqualForState:(State*)state;
- (UIAlertView*)doesAlertViewExist;
- (UIActionSheet*)doesActionSheetExist;
- (UIElement*)returnUITabBarElementForState;
- (void)setAllUIElementsVisitedTrue;

@end
