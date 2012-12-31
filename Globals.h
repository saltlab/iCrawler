//
//  Globals.h
//
//  Created by Mona on 12-04-07. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Globals : NSObject {
    NSMutableArray *statesArray;
	NSMutableArray *xmlNodesArray;
}

@property (nonatomic, retain) NSMutableArray *statesArray;
@property (nonatomic, retain) NSMutableArray *xmlNodesArray;

+ (Globals*)sharedInstance;
+ (void)setSharedInstance:(Globals*)globals;

@end

