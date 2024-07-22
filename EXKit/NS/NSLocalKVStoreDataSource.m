//
//  NSUserDefaultsDataSource.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 13.11.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "NSObject+Convenience.h"
#import "NSLocalKVStoreDataSource.h"

@interface NSLocalKVStoreDataSource ()
@property (strong, nonatomic) NSUserDefaults *store;
@end

@implementation NSLocalKVStoreDataSource

- (id)loadByKey:(NSString *)key {
	return [self.store objectForKey:key];
}

- (void)save:(NSArray *)array byKey:(NSString *)key {
	[self.store setObject:array forKey:key];
}

- (void)removeByKey:(NSString *)key {
	[self.store removeObjectForKey:key];
}

+ (instancetype)create:(NSString *)suiteName {
	NSLocalKVStoreDataSource *instance = [self new];
	instance.store = suiteName.length ? [[NSUserDefaults alloc] initWithSuiteName:suiteName] : [NSUserDefaults standardUserDefaults];
	return instance;
}

+ (instancetype)create {
	return [self create:Nil];
}

@end
