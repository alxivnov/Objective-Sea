//
//  NSBundle+Convenience.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 15.03.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "NSBundle+Convenience.h"

@implementation NSBundle (Convenience)

- (NSURL *)URLForResource:(NSString *)name {
	return [self URLForResource:name.stringByDeletingPathExtension withExtension:name.pathExtension];
}

+ (NSURL *)URLForResource:(NSString *)name {
	return [[self mainBundle] URLForResource:name];
}

- (NSString *)pathForResource:(NSString *)name {
	return [self pathForResource:name.stringByDeletingPathExtension ofType:name.pathExtension];
}

+ (NSString *)pathForResource:(NSString *)name {
	return [[self mainBundle] pathForResource:name];
}

+ (NSString *)mainLocalization {
	return [self mainBundle].preferredLocalizations.firstObject;
}

- (BOOL)isPreferredLocalization:(NSString *)localization {
	return [self.preferredLocalizations any:^BOOL(NSString *item) {
		return [localization isEqualToString:item];
	}];
}

+ (BOOL)isPreferredLocalization:(NSString *)localization {
	return [[self mainBundle] isPreferredLocalization:localization];
}

+ (NSString *)bundleIdentifier {
	return [self mainBundle].bundleIdentifier;
}

+ (NSString *)bundleDisplayName {
	return [[self mainBundle] objectForInfoDictionaryKey:CFBundleDisplayName] ?: [[self mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleNameKey];
}

+ (NSString *)bundleShortVersionString {
	return [[self mainBundle] objectForInfoDictionaryKey:CFBundleShortVersionString];
}

+ (NSString *)bundleVersion {
	return [[self mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

+ (NSString *)bundleDisplayNameAndShortVersion {
	return [NSString stringWithFormat:@"%@ %@", [self bundleDisplayName], [self bundleShortVersionString]];
}

@end
