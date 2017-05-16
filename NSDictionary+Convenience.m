//
//  NSDictionary+Convenience.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 19.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "NSDictionary+Convenience.h"

@implementation NSDictionary (Convenience)

- (id)objectForNullableKey:(id<NSCopying>)aKey {
	return aKey ? [self objectForKey:aKey] : Nil;
}

- (NSDictionary *)dictionaryWithObjectsForKeys:(NSArray *)keys {
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:keys.count];

	for (id key in keys)
		dictionary[key] = self[key];

	return dictionary;
}

- (instancetype)dictionaryWithObject:(id)object forKey:(id<NSCopying>)key {
	NSMutableDictionary *dictionary = [self mutableCopy];
	if (object)
		dictionary[key] = object;
	else
		[dictionary removeObjectForKey:key];
	return dictionary;
}

- (instancetype)dictionaryWithObjects:(NSArray *)objects forKeys:(NSArray *)keys {
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

- (NSDictionary *)mapKeys:(id (^)(id))keyBlock values:(id (^)(id))valBlock {
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

	for (id key in self) {
		id val = self[key];

		id k = keyBlock ? keyBlock(key) : key;
		id v = valBlock ? valBlock(val) : val;
		if (k && v)
			dictionary[k] = v;
	}

	return dictionary;
}

- (NSDictionary *)mapKeys:(id (^)(id))block {
	return [self mapKeys:block values:Nil];
}

- (NSDictionary *)mapValues:(id (^)(id))block {
	return [self mapKeys:Nil values:block];
}

- (NSArray *)array:(NSArray *(^)(id, id))block {
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:2 * self.count];

	for (id key in self) {
		id val = self[key];

		NSArray *objects = block ? block(key, val) : @[ key, val ];
		if (objects)
			[array addObjectsFromArray:objects];
	}

	return array;
}

- (NSArray *)array {
	return [self array:Nil];
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
