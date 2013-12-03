//
//  DCIntrospect.h
//
//  Created by Domestic Cat on 29/04/11.
//

#import <Foundation/Foundation.h>

@interface DCIntrospect : NSObject {
}

/////////////////////////////
// (Somewhat) Experimental //
/////////////////////////////
- (void)logPropertiesForObject:(id)object withViewController:(NSString *)viewControllerName andStateIndex:(int)stateIndex;

/////////////////////////
// Description Methods //
/////////////////////////

- (NSString *)describeProperty:(NSString *)propertyName value:(id)value;
- (NSString *)describeColor:(UIColor *)color;

@end
