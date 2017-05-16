//
//  NSArray+Convenience.h
//  Sleep Diary
//
//  Created by Alexander Ivanov on 16.10.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray<ObjectType> (Convenience)

- (instancetype)initWithURL:(NSURL *)url;
+ (instancetype)arrayWithURL:(NSURL *)url;

+ (instancetype)arrayWithObject:(id)anObject count:(NSUInteger)count;
+ (instancetype)arrayWithObject:(id)object1 withObject:(id)object2;
+ (instancetype)arrayWithObject:(id)object1 withObject:(id)object2 withObject:(id)object3;

- (NSArray<ObjectType> *)arrayWithRange:(NSRange)range;
- (NSArray<ObjectType> *)arrayWithCount:(NSUInteger)count;
- (NSArray<ObjectType> *)arrayWithIndex:(NSUInteger)index;

- (NSArray<ObjectType> *)arrayByAddingObjectsFromNullableArray:(NSArray<ObjectType> *)otherArray;
- (NSArray<ObjectType> *)arrayByAddingNullableObject:(ObjectType)anObject;
- (NSArray<ObjectType> *)arrayByRemovingObjectsFromArray:(NSArray<ObjectType> *)otherArray;
- (NSArray<ObjectType> *)arrayByRemovingObject:(ObjectType)anObject;
- (NSArray<ObjectType> *)arrayByRemovingObjectAtIndex:(NSUInteger)index;



- (NSArray<ObjectType> *)reversedArray;

- (NSArray<ObjectType> *)sortedArray:(BOOL)descending;
- (NSArray<ObjectType> *)sortedArray;



- (NSArray *)map:(id (^)(ObjectType obj))predicate;
- (NSArray<ObjectType> *)query:(BOOL (^)(ObjectType obj))predicate;

- (NSUInteger)first:(BOOL (^)(ObjectType obj))predicate;
- (ObjectType)firstObject:(BOOL (^)(ObjectType obj))predicate;

- (NSUInteger)last:(BOOL (^)(ObjectType obj))predicate;
- (ObjectType)lastObject:(BOOL (^)(ObjectType obj))predicate;

- (BOOL)all:(BOOL (^)(ObjectType obj))predicate;
- (BOOL)any:(BOOL (^)(ObjectType obj))predicate;

- (NSDictionary *)dictionaryWithKey:(id<NSCopying>(^)(ObjectType obj))keyPredicate value:(id(^)(ObjectType obj, id<NSCopying> key, id val))valPredicate;
- (NSDictionary *)dictionaryWithKey:(id<NSCopying>(^)(ObjectType obj))keyPredicate;

+ (instancetype)arrayFromCount:(NSUInteger)count block:(ObjectType (^)(NSUInteger index))block;
+ (instancetype)arrayFromRange:(NSRange)range block:(ObjectType (^)(NSUInteger index))block;

- (NSString *)componentsJoinedByString:(NSString *)separator block:(NSString *(^)(ObjectType obj))block;
- (BOOL)isEqualToArray:(NSArray<ObjectType> *)otherArray block:(BOOL(^)(ObjectType obj, ObjectType otherObj))predicate;

- (double)max:(NSNumber *(^)(ObjectType obj))predicate;
- (double)min:(NSNumber *(^)(ObjectType obj))predicate;
- (double)sum:(NSNumber *(^)(ObjectType obj))predicate;
- (double)avg:(NSNumber *(^)(ObjectType obj))predicate;
- (double)med:(NSNumber *(^)(ObjectType obj))predicate;

@end
