//
//  NSDictionary+Convenience.h
//  Sleep Diary
//
//  Created by Alexander Ivanov on 19.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary<KeyType, ObjectType> (Convenience)

- (ObjectType)objectForNullableKey:(KeyType)aKey;

- (instancetype)dictionaryWithObject:(ObjectType)object forKey:(KeyType)key;
- (instancetype)dictionaryWithObjects:(NSArray<ObjectType> *)objects forKeys:(NSArray<KeyType> *)keys;

- (NSDictionary *)castKeys:(id (^)(KeyType item))keyBlock andValues:(id (^)(ObjectType item))valueBlock;
- (NSDictionary *)castKeys:(id (^)(KeyType item))block;
- (NSDictionary *)castValues:(id (^)(ObjectType item))block;

- (NSArray *)array;

- (BOOL)boolForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key;
- (NSUInteger)unsignedIntegerForKey:(NSString *)key;

@end

@interface NSMutableDictionary (Convenience)

- (void)setBool:(BOOL)value forKey:(NSString *)key;
- (void)setDouble:(double)value forKey:(NSString *)key;
- (void)setInteger:(NSInteger)value forKey:(NSString *)key;
- (void)setUnsignedInteger:(NSUInteger)value forKey:(NSString *)key;

@end
