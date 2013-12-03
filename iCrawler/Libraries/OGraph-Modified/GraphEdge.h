//
//  GraphEdge.h
//  GraphLib
//
//  Created by Matthew McGlincy on 5/2/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GraphEdge : NSObject {
    NSUInteger from;
    NSUInteger to;
    double cost;
    NSString *monkeyCommand;
}

@property (nonatomic) NSUInteger from;
@property (nonatomic) NSUInteger to;
@property (nonatomic) double cost;
@property (nonatomic, retain) NSString *monkeyCommand;

- (id)initWithFrom:(NSUInteger)aFrom to:(NSUInteger)aTo cost:(double)aCost;
- (id)initWithFrom:(NSUInteger)aFrom to:(NSUInteger)aTo;
- (id)initWithFrom:(NSUInteger)aFrom to:(NSUInteger)aTo command:(NSString*)aMonkeyCommand;

@end
