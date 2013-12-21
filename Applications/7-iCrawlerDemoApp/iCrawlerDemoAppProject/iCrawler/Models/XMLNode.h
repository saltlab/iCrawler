//
//  XMLNode.h
//
//  Created by Mona on 12-04-07. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIElement.h"

@interface XMLNode : NSObject

@property(nonatomic, assign) int preStateIndex;
@property(nonatomic, retain) NSString *edge;
@property(nonatomic, assign) int currentStateIndex;
@property(nonatomic, retain) UIElement* currentElement;

@end
