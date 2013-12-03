//
//  ICrawlerController.h
//
//  Created by Mona on 12-04-07. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "State.h"
#import "Globals.h"
#import <objc/runtime.h>

@interface ICrawlerController : NSObject {
    UIViewController *currentViewController;
    Globals *globals;
    State *currentState;
    NSMutableArray *visitedStates;
    int dynamicState;
    int monkeyID;
    UINavigationItem *navItem;
}

@property(nonatomic, retain) UIViewController *currentViewController;
@property(nonatomic, retain) Globals *globals;
@property(nonatomic, retain) State *currentState;
@property(nonatomic, retain) NSMutableArray *visitedStates;
@property(nonatomic, assign) int dynamicState;
@property(nonatomic, assign) int monkeyID;
@property(nonatomic, retain) UINavigationItem *navItem;


+ (ICrawlerController *)sharedICrawler;		// this returns nil when NOT in DEGBUG mode
- (void)start;		
- (void)setupGlobals;
- (UIWindow*)mainWindow;
- (void)runAutoTestingApp:(NSString*)tag;
- (void)setupRootState;
- (void)setupNextStateAndViewController;
- (void)getPreviousStateAndViewController;
- (void)getPreviousStateAndViewControllerWithoutNextState;
- (void)findClickableElementAndFireAction;

@end
