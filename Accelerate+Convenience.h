//
//  Accelerate+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 13.06.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSArray+Convenience.h"

@interface NSArray<ObjectType> (Accelerate)

- (NSArray<NSNumber *> *)meanAndStandardDeviation:(NSNumber *(^)(ObjectType obj))predicate;
- (NSArray<NSNumber *> *)quartiles:(NSNumber *(^)(ObjectType obj))predicate;

- (double)sum:(NSNumber *(^)(ObjectType obj))predicate;

- (double)avg:(NSNumber *(^)(ObjectType obj))predicate;
- (double)dev:(NSNumber *(^)(ObjectType obj))predicate;

- (double)min:(NSNumber *(^)(ObjectType obj))predicate;
- (double)med:(NSNumber *(^)(ObjectType obj))predicate;
- (double)max:(NSNumber *(^)(ObjectType obj))predicate;

@end
