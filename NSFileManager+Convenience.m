//
//  NSFileManager+Convenience.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "NSFileManager+Convenience.h"

@implementation NSFileManager (Convenience)

- (NSURL *)URLForDirectory:(NSSearchPathDirectory)directory {
	return [self URLsForDirectory:directory inDomains:NSUserDomainMask].firstObject;
}

- (NSURL *)URLForGroupIdentifier:(NSString *)groupIdentifier {
	return [self containerURLForSecurityApplicationGroupIdentifier:groupIdentifier];
}

- (BOOL)isUbiquityAvailable {
	return self.ubiquityIdentityToken ? YES : NO;
}

- (BOOL)URLForUbiquityContainerIdentifier:(NSString *)containerIdentifier handler:(void(^)(NSURL *))handler {
	if (![self ubiquityIdentityToken])
		return NO;

	[GCD global:^{
		NSURL *url = [self URLForUbiquityContainerIdentifier:containerIdentifier];

		if (handler)
			handler(url);
	}];
	return YES;
}

+ (NSURL *)URLForDirectory:(NSSearchPathDirectory)directory {
	return [[self defaultManager] URLForDirectory:directory];
}

+ (NSURL *)URLForGroupIdentifier:(NSString *)groupIdentifier {
	return [[self defaultManager] URLForGroupIdentifier:groupIdentifier];
}

+ (BOOL)isUbiquityAvailable {
	return [[self defaultManager] isUbiquityAvailable];
}

+ (BOOL)URLForUbiquityContainerIdentifier:(NSString *)containerIdentifier handler:(void (^)(NSURL *))handler {
	return [[self defaultManager] URLForUbiquityContainerIdentifier:containerIdentifier handler:handler];
}

@end

@implementation NSURL (File)

- (NSDictionary *)fileAttributes {
	NSError *error = Nil;
	NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:self.path error:Nil];
	[error log:@"attributesOfItemAtPath:"];
	return dictionary;
}

- (NSDate *)fileCreationDate {
	return [[self fileAttributes] fileCreationDate];
}

- (NSDate *)fileModificationDate {
	return [[self fileAttributes] fileModificationDate];
}

- (NSUInteger)fileSize {
	return (NSUInteger)[[self fileAttributes] fileSize];
}

- (id)resourceValueForKey:(NSString *)key {
	id value = Nil;
	NSError *error = Nil;

	if (![self getResourceValue:&value forKey:key error:&error])
		[error log:@"getResourceValue:"];

	return value;
}

- (NSString *)fileSizeString {
	NSUInteger fileSize = [self fileSize];

	return [NSByteCountFormatter stringFromByteCount:fileSize countStyle:NSByteCountFormatterCountStyleFile];
}

- (BOOL)isExistingItem {
	return [[NSFileManager defaultManager] fileExistsAtPath:self.path isDirectory:Nil];
}

- (BOOL)isExistingFile {
	BOOL isDir = NO;
	return [[NSFileManager defaultManager] fileExistsAtPath:self.path isDirectory:&isDir] && !isDir;
}

- (BOOL)isExistingDirectory {
	BOOL isDir = NO;
	return [[NSFileManager defaultManager] fileExistsAtPath:self.path isDirectory:&isDir] && isDir;
}

- (NSURL *)copyItem:(NSURL *)dstURL overwrite:(BOOL)overwrite {
	if ([dstURL isExistingDirectory])
		dstURL = [self URLByChangingPath:dstURL];

	if ([dstURL isExistingFile]) {
		if (!overwrite)
			return Nil;

		if ([dstURL isExistingItem])
			[dstURL removeItem];
	}

	NSError *error = Nil;
	BOOL flag = [[NSFileManager defaultManager] copyItemAtURL:self toURL:dstURL error:&error];
	[error log:@"copyItemAtURL:"];
	return flag && !error ? dstURL : Nil;
}

- (NSURL *)copyItem:(NSURL *)dstURL {
	return [self copyItem:dstURL overwrite:NO];
}

- (NSURL *)moveItem:(NSURL *)dstURL overwrite:(BOOL)overwrite {
	if ([dstURL isExistingDirectory])
		dstURL = [self URLByChangingPath:dstURL];

	if ([dstURL isExistingFile]) {
		if (!overwrite)
			return Nil;

		if ([dstURL isExistingItem])
			[dstURL removeItem];
	}

	NSError *error = Nil;
	BOOL flag = [[NSFileManager defaultManager] moveItemAtURL:self toURL:dstURL error:&error];
	[error log:@"moveItemAtURL:"];
	return flag && !error ? dstURL : Nil;
}

- (NSURL *)moveItem:(NSURL *)dstURL {
	return [self moveItem:dstURL overwrite:NO];
}

- (BOOL)removeItem {
	NSError *error = Nil;
	BOOL flag = [[NSFileManager defaultManager] removeItemAtURL:self error:&error];
	[error log:@"removeItemAtURL:"];
	return flag && !error;
}

- (BOOL)createDirectoryWithAttributes:(NSDictionary *)attributes {
	NSError *error = Nil;
	BOOL flag = [[NSFileManager defaultManager] createDirectoryAtURL:self withIntermediateDirectories:YES attributes:attributes error:&error];
	[error log:@"createDirectoryAtURL:"];
	return flag && !error;
}

- (BOOL)createDirectory {
	return [self createDirectoryWithAttributes:Nil];
}

- (NSURL *)createDirectory:(NSString *)pathComponent withAttributes:(NSDictionary *)attributes {
	NSURL *url = [self URLByAppendingPathComponent:pathComponent];
	return [url createDirectoryWithAttributes:attributes] ? url : Nil;
}

- (NSURL *)createDirectory:(NSString *)pathComponent {
	return [self createDirectory:pathComponent withAttributes:Nil];
}

- (NSArray *)allItems:(BOOL)subdirectories includingPropertiesForKeys:(NSArray *)keys {
	NSDirectoryEnumerationOptions options = subdirectories ? 0 :  NSDirectoryEnumerationSkipsPackageDescendants | NSDirectoryEnumerationSkipsSubdirectoryDescendants;
	NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtURL:self includingPropertiesForKeys:keys options:options errorHandler:^BOOL(NSURL *url, NSError *error) {
		[error log:@"enumeratorAtURL:"];
		return YES;
	}];
	NSMutableArray *array = [NSMutableArray new];
	while (YES) {
		NSURL *url = [enumerator nextObject];
		if (url)
			[array addObject:url];
		else
			break;
	}
	return array;
}

- (NSArray *)allItems:(BOOL)subdirectories {
	return [self allItems:subdirectories includingPropertiesForKeys:Nil];
}

- (NSArray *)allItems {
	return [self allItems:NO];
}

- (NSArray *)allFiles:(BOOL)subdirectories {
	NSArray *items = [self allItems:subdirectories includingPropertiesForKeys:@[ NSURLIsDirectoryKey ]];
	NSArray *files = [items query:^BOOL(id item) {
		NSNumber *isDirectory = [item resourceValueForKey:NSURLIsDirectoryKey];
		return isDirectory && !isDirectory.boolValue;
	}];
	return files;
}

- (NSArray *)allFiles {
	return [self allFiles:NO];
}

- (NSArray *)allDirectories:(BOOL)subdirectories {
	NSArray *items = [self allItems:subdirectories includingPropertiesForKeys:@[ NSURLIsDirectoryKey ]];
	NSArray *files = [items query:^BOOL(id item) {
		NSNumber *isDirectory = [item resourceValueForKey:NSURLIsDirectoryKey];
		return isDirectory && isDirectory.boolValue;
	}];
	return files;
}

- (NSArray *)allDirectories {
	return [self allDirectories:NO];
}

- (void)clearDirectory:(BOOL)directories {
	NSArray *items = directories ? [self allItems:NO includingPropertiesForKeys:Nil] : [self allFiles:NO];
	for (NSURL *item in items)
		[item removeItem];
}

- (void)clearDirectory {
	[self clearDirectory:NO];
}

@end
