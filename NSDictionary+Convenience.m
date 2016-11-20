//
//  NSDictionary+Convenience.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 19.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "NSDictionary+Convenience.h"

@implementation NSDictionary (Convenience)

- (instancetype)dictionaryWithValue:(id)object forKey:(id<NSCopying>)key {
	NSMutableDictionary *dictionary = [self mutableCopy];
	if (object)
		dictionary[key] = object;
	else
		[dictionary removeObjectForKey:key];
	return dictionary;
}

- (instancetype)dictionaryWithValues:(NSArray *)objects forKeys:(NSArray *)keys {
	NSMutableDictionary *dictionary = [self mutableCopy];
	for (NSUInteger index = 0; index < keys.count; index++) {
		id object = index < objects.count ? objects[index] : Nil;
		id<NSCopying> key = keys[index];

		if (object)
			dictionary[key] = object;
		else
			[dictionary removeObjectForKey:key];
	}
	return dictionary;
}

- (NSDictionary *)castKeys:(id (^)(id item))keyBlock andValues:(id (^)(id item))valueBlock {
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

	for (id key in self) {
		id value = self[key];

		id k = keyBlock ? keyBlock(key) : key;
		id v = valueBlock ? valueBlock(value) : value;
		if (k && v)
			dictionary[k] = v;
	}

	return dictionary;
}

- (NSDictionary *)castKeys:(id (^)(id))block {
	return [self castKeys:block andValues:Nil];
}

- (NSDictionary *)castValues:(id (^)(id item))block {
	return [self castKeys:Nil andValues:block];
}

- (NSArray *)array {
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:2 * self.count];
	for (NSUInteger index = 0; index < self.count; index++) {
		[array addObject:self.allKeys[index]];
		[array addObject:self.allValues[index]];
	}
	return array;
}

- (BOOL)boolForKey:(NSString *)key {
	return [self[key] boolValue];
}

- (double)doubleForKey:(NSString *)key {
	return [self[key] doubleValue];
}

- (NSInteger)integerForKey:(NSString *)key {
	return [self[key] integerValue];
}

- (NSUInteger)unsignedIntegerForKey:(NSString *)key {
	return [self[key] unsignedIntegerValue];
}

@end

@implementation NSMutableDictionary (Convenience)

- (void)setBool:(BOOL)value forKey:(NSString *)key {
	if (value)
		self[key] = @(value);
}

- (void)setDouble:(double)value forKey:(NSString *)key {
	if (value != 0.0)
		self[key] = @(value);
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)key {
	if (value != 0)
		self[key] = @(value);
}

- (void)setUnsignedInteger:(NSUInteger)value forKey:(NSString *)key {
	if (value != 0)
		self[key] = @(value);
}

@end
