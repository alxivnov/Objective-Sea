//
//  Accelerate+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 13.06.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray<ObjectType> (Accelerate)

- (NSNumber *)sumOfElements:(NSNumber *(^)(ObjectType obj))predicate;

- (NSArray<NSNumber *> *)meanAndStandardDeviation:(NSNumber *(^)(ObjectType obj))predicate;

- (NSArray<NSNumber *> *)fiveNumberSummary:(NSNumber *(^)(ObjectType obj))predicate;

@end
