//
//  NSCloudDataSource.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 27.03.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "NSCloudKVStoreDataSource.h"

@interface NSCloudKVStoreDataSource ()
@property (strong, nonatomic) NSUbiquitousKeyValueStore *store;
@end

@implementation NSCloudKVStoreDataSource

- (id)loadByKey:(NSString *)key {
	return [self.store objectForKey:key];
}

- (void)save:(NSArray *)array byKey:(NSString *)key {
	if (self.readonly)
		return;
	
	[self.store setObject:array forKey:key];
}

- (void)removeByKey:(NSString *)key {
	if (self.readonly)
		return;
	
	[self.store removeObjectForKey:key];
}

- (void)didChangeExternally:(NSNotification *)notification {
	if (self.externalChangeHandler)
		self.externalChangeHandler(notification);
}

- (void)addObserver {
	[self.store synchronize];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeExternally:) name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification object:self.store];
}

- (void)removeObserver {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification object:self.store];
	
	[self.store synchronize];
}

- (void)setExternalChangeHandler:(void (^)(NSNotification *))externalChangeHandler {
	if (_externalChangeHandler && !externalChangeHandler)
		[self removeObserver];
	else if (!_externalChangeHandler && externalChangeHandler)
		[self addObserver];
	
	_externalChangeHandler = externalChangeHandler;
}

- (instancetype)init {
	self = [super init];
	
	if (self)
		self.store = [NSUbiquitousKeyValueStore defaultStore];
	
	return self;
}

- (void)dealloc {
	[self removeObserver];
}

+ (instancetype)create:(void (^)(NSNotification *notification))externalChangeHandler readonly:(BOOL)readonly {
	NSCloudKVStoreDataSource *instance = [self new];
	instance.externalChangeHandler = externalChangeHandler;
	instance.readonly = readonly;
	
	return instance;
}

+ (instancetype)create:(void (^)(NSNotification *notification))didChangeExternally {
	return [self create:didChangeExternally readonly:NO];
}

+ (instancetype)create {
	return [self create:Nil readonly:NO];
}

@end
