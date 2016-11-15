//
//  NSFileManager+Convenience.h
//  Sleep Diary
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Dispatch+Convenience.h"
#import "NSArray+Convenience.h"
#import "NSObject+Convenience.h"

@interface NSFileManager (Convenience)

- (NSURL *)URLForDirectory:(NSSearchPathDirectory)directory;
+ (NSURL *)URLForDirectory:(NSSearchPathDirectory)directory;

- (NSURL *)URLForGroupIdentifier:(NSString *)groupIdentifier;
+ (NSURL *)URLForGroupIdentifier:(NSString *)groupIdentifier;

- (BOOL)isUbiquityAvailable;
+ (BOOL)isUbiquityAvailable;

- (BOOL)URLForUbiquityContainerIdentifier:(NSString *)containerIdentifier handler:(void(^)(NSURL *url))handler;
+ (BOOL)URLForUbiquityContainerIdentifier:(NSString *)containerIdentifier handler:(void(^)(NSURL *url))handler;

@end

@interface NSURL (File)

- (NSDate *)fileCreationDate;
- (NSDate *)fileModificationDate;
- (NSUInteger)fileSize;
- (NSString *)fileSizeString;

- (id)resourceValueForKey:(NSString *)key;

@property (assign, nonatomic, readonly) BOOL isExistingItem;
@property (assign, nonatomic, readonly) BOOL isExistingFile;
@property (assign, nonatomic, readonly) BOOL isExistingDirectory;

- (NSURL *)copyItem:(NSURL *)dstURL overwrite:(BOOL)overwrite;
- (NSURL *)copyItem:(NSURL *)dstURL;
- (NSURL *)moveItem:(NSURL *)dstURL overwrite:(BOOL)overwrite;
- (NSURL *)moveItem:(NSURL *)dstURL;
- (BOOL)removeItem;

- (BOOL)createDirectoryWithAttributes:(NSDictionary *)attributes;
- (BOOL)createDirectory;

- (NSURL *)createDirectory:(NSString *)pathComponent withAttributes:(NSDictionary *)attributes;
- (NSURL *)createDirectory:(NSString *)pathComponent;

- (NSArray<NSURL *> *)allItems:(BOOL)subdirectories;
- (NSArray<NSURL *> *)allItems;

- (NSArray<NSURL *> *)allFiles:(BOOL)subdirectories;
- (NSArray<NSURL *> *)allFiles;

- (NSArray<NSURL *> *)allDirectories:(BOOL)subdirectories;
- (NSArray<NSURL *> *)allDirectories;

- (void)clearDirectory:(BOOL)directories;
- (void)clearDirectory;

@end

@interface NSURL (Path)

- (NSURL *)URLByAppendingPathComponents:(NSArray<NSString *> *)pathComponents;

- (NSURL *)URLByChangingPathExtension:(NSString *)extension;

- (NSURL *)URLByChangingPath:(NSURL *)path;

- (NSString *)lastPathComponentWithoutExtension;

@end
