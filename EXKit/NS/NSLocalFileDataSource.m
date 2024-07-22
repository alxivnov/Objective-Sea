//
//  NSFileDataSource.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 27.03.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "NSLocalFileDataSource.h"
#import "NSFileManager+Convenience.h"
#import "NSObject+Convenience.h"
#import "NSString+Convenience.h"
#import "NSFileManager+Convenience.h"

@interface NSLocalFileDataSource ()
@property (strong, nonatomic) NSURL *directory;
@end

@implementation NSLocalFileDataSource

- (void)setDirectory:(NSURL *)directory {
	if ([_directory isEqual:directory])
		return;
	
	_directory = directory;
	
	if (![_directory isExistingDirectory])
		[_directory createDirectory];
}

- (NSURL *)urlFromKey:(NSString *)key {
	return  key ? [self.directory URLByAppendingPathComponent:[[key fileName] stringByAppendingString:FILE_EXTENSION_PLIST]] : Nil;
}

- (id)loadByKey:(NSString *)key {
	NSURL *url = [self urlFromKey:key];
	id object = [NSDictionary dictionaryWithContentsOfURL:url];
	if (!object)
		object = [NSArray arrayWithContentsOfURL:url];
	return object;
}

- (void)save:(id)object byKey:(NSString *)key {
	if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]])
		[object writeToURL:[self urlFromKey:key] atomically:YES];
}

- (void)removeByKey:(NSString *)key {
	[[self urlFromKey:key] removeItem];
}

+ (instancetype)create:(NSString *)suiteName {
	NSLocalFileDataSource *instance = [[self alloc] init];
	instance.directory = suiteName ? [NSFileManager URLForGroupIdentifier:suiteName] : [NSFileManager URLForDirectory:NSDocumentDirectory];
	return instance;
}

+ (instancetype)create {
	return [self create:Nil];
}

@end
