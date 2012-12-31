//
//  State.h
//
//  Created by Mona on 12-04-07. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface State : NSObject {
	NSMutableArray *uiElementsArray;
	UIViewController *selfViewController;
	int stateIndex;
	int visitedStateIndex;
}

@property(nonatomic, retain) NSMutableArray *uiElementsArray;
@property(nonatomic, retain) UIViewController *selfViewController;
@property(nonatomic, assign) int stateIndex;
@property(nonatomic, assign) int visitedStateIndex;

@end
