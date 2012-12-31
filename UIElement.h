//
//  UIElement.h
//
//  Created by Mona on 12-04-07. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIElement : NSObject {
    NSString *className;
	Class objectClass;
	id object;
	NSString *action;
	id target;
	bool visited;
}

@property(nonatomic, retain) NSString *className;
@property(nonatomic, assign) Class objectClass; 
@property(nonatomic, assign) id object;
@property(nonatomic, retain) NSString *action;
@property(nonatomic, assign) id target;
@property(nonatomic, assign) bool visited;

@end
