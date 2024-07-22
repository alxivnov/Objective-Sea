//
//  NSPropertyFile.m
//  Done!
//
//  Created by Alexander Ivanov on 11.01.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "NSPropertyFile.h"
#import "NSFileManager+Convenience.h"
#import "NSObject+Convenience.h"
#import "NSLocalFileDataSource.h"
#import "NSString+Convenience.h"

@interface NSPropertyFile ()
@property (strong, nonatomic, readwrite) NSString *key;
@end

@implementation NSPropertyFile

- (id <NSPropertyDataSource>)dataSource {
	if (!_dataSource)
		_dataSource = [NSLocalFileDataSource create];
	
	return _dataSource;
}

- (instancetype)initWithKey:(NSString *)key {
	self = [self init];
	
	if (self)
		self.key = key ? key : [[self class] description];
	
	return self;
}

- (void)load:(NSString *)key {
	// abstract
}

- (void)save:(NSString *)key {
	// abstract
}

- (void)load {
	[self load:self.key];	// abstract
}

- (void)save {
	[self save:self.key];	// abstract
}

- (void)loadFromFile:(NSURL *)url {
	// abstract
}

- (void)saveToFile:(NSURL *)url {
	// abstract
}

- (BOOL)isChanged {
	return YES;				// abstract
}

+ (NSURL *)urlFromKey:(NSString *)key extension:(NSString *)extension {
	return [[NSFileManager URLForDirectory:NSDocumentDirectory] URLByAppendingPathComponent:[key ? [key fileName] : [[self class] description] stringByAppendingString:extension]];
}

+ (NSURL *)urlFromKey:(NSString *)key {
	return [self urlFromKey:key extension:FILE_EXTENSION_PLIST];
}

+ (instancetype)create:(NSString *)key dataSource:(id <NSPropertyDataSource>)dataSource {
	NSPropertyFile *instance = [[self alloc] initWithKey:key];
	instance.dataSource = dataSource;
	[instance load];
	
	return instance;
}

+ (instancetype)create:(NSString *)key {
	return [self create:key dataSource:Nil];
}

+ (instancetype)create {
	return [self create:Nil dataSource:Nil];
}

@end
