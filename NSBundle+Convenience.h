//
//  NSBundle+Convenience.h
//  Sleep Diary
//
//  Created by Alexander Ivanov on 15.03.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSArray+Convenience.h"

#define CFBundleShortVersionString @"CFBundleShortVersionString"
#define CFBundleVersion (NSString *)kCFBundleVersionKey

@interface NSBundle (Convenience)

- (NSURL *)URLForResource:(NSString *)name;
+ (NSURL *)URLForResource:(NSString *)name;

- (NSString *)pathForResource:(NSString *)name;
+ (NSString *)pathForResource:(NSString *)name;

@property (strong, nonatomic, readonly, class) NSString *mainLocalization;

- (BOOL)isPreferredLocalization:(NSString *)localization;
+ (BOOL)isPreferredLocalization:(NSString *)localization;

@property (strong, nonatomic, readonly, class) NSString *bundleIdentifier;

@property (strong, nonatomic, readonly, class) NSString *bundleDisplayName;
@property (strong, nonatomic, readonly, class) NSString *bundleShortVersionString;
@property (strong, nonatomic, readonly, class) NSString *bundleVersion;

+ (NSString *)bundleDisplayNameAndShortVersion;

@end
