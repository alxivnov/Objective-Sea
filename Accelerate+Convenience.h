//
//  Accelerate+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 13.06.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<Accelerate/Accelerate.h>)

@import Accelerate;

#endif

#import "NSArray+Convenience.h"

@interface NSArray<ObjectType> (Accelerate)

- (NSArray<NSNumber *> *)meanAndStandardDeviation:(NSNumber *(^)(ObjectType obj))predicate;
- (NSArray<NSNumber *> *)quartiles:(NSNumber *(^)(ObjectType obj))predicate;

- (double)vSum:(NSNumber *(^)(ObjectType obj))predicate;

- (double)vAvg:(NSNumber *(^)(ObjectType obj))predicate;
- (double)vDev:(NSNumber *(^)(ObjectType obj))predicate;

- (double)vMin:(NSNumber *(^)(ObjectType obj))predicate;
- (double)vMed:(NSNumber *(^)(ObjectType obj))predicate;
- (double)vMax:(NSNumber *(^)(ObjectType obj))predicate;

@end
