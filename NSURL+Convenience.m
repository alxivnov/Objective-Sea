//
//  NSURL+Convenience.m
//  Crowd Guard
//
//  Created by Alexander Ivanov on 17.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "NSURL+Convenience.h"

#define PARAM_0 @"?%@=%@"
#define PARAM_1 @"&%@=%@"

#define STR_AMPERSAND_CODE @"%26"
#define STR_SPACE_CODE @"%20"

@implementation NSURL (Convenience)

+ (NSURL *)urlWithScheme:(NSString *)scheme andParameters:(NSDictionary *)parameters {
	NSMutableString *url = [NSMutableString stringWithFormat:@"%@://", scheme];

	NSUInteger index = 0;
	for (NSString *key in parameters) {
		[url appendFormat:index ? PARAM_1 : PARAM_0, key, parameters[key]];
		index++;
	}

	return [self URLWithString:url];
}

- (NSDictionary *)queryDictionary {
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

	NSArray *queryComponents = [self.query componentsSeparatedByString:STR_AMPERSAND];
	for (NSString *pair in queryComponents) {
		NSArray *pairComponents = [pair componentsSeparatedByString:STR_EQUALITY];

		if (pairComponents.count == 2)
			dictionary[pairComponents[0]] = [[[pairComponents[1] stringByReplacingOccurrencesOfString:STR_AMPERSAND_CODE withString:STR_AMPERSAND] stringByRemovingPercentEncoding] stringByReplacingOccurrencesOfString:STR_PLUS withString:STR_SPACE];
	}

	return dictionary;
}

- (NSURL *)URLByAppendingQueryDictionary:(NSDictionary *)dictionary allowedCharacters:(NSCharacterSet *)allowedCharacters {
	NSMutableString *url = [[self description] mutableCopy];

	NSMutableCharacterSet *urlQueryAllowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
	[urlQueryAllowedCharacterSet removeCharactersInString:@"?&="];

	NSUInteger index = self.query ? 1 : 0;
	for (NSString *key in dictionary) {
		NSString *value = [dictionary[key] description];
		value = allowedCharacters ? [value stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters] : [[[value stringByReplacingOccurrencesOfString:STR_SPACE withString:STR_PLUS] stringByAddingPercentEncodingWithAllowedCharacters:urlQueryAllowedCharacterSet] stringByReplacingOccurrencesOfString:STR_AMPERSAND withString:STR_AMPERSAND_CODE];
		[url appendFormat:index ? PARAM_1 : PARAM_0, key, value];
		index++;
	}

	return [NSURL URLWithString:url];
}

- (NSURL *)URLByAppendingQueryDictionary:(NSDictionary *)dictionary {
	return [self URLByAppendingQueryDictionary:dictionary allowedCharacters:Nil];
}

- (BOOL)isWebAddress {
	return [self.scheme isEqualToString:URL_SCHEME_HTTP] || [self.scheme isEqualToString:URL_SCHEME_HTTPS];
}

- (BOOL)isMediaItem {
	return [self.scheme isEqualToString:URL_SCHEME_IPOD_LIBRARY];
}

- (NSString *)lastPathComponentWithoutExtension {
	NSString *lastPathComponent = self.lastPathComponent;
	if (self.pathExtension.length)
		lastPathComponent = [lastPathComponent substringToIndex:lastPathComponent.length - (self.pathExtension.length + 1)];
	return lastPathComponent;
}

- (NSURL *)URLByChangingPathExtension:(NSString *)extension {
	return [[self URLByDeletingPathExtension] URLByAppendingPathExtension:extension];
}

- (NSURL *)URLByChangingPath:(NSURL *)path {
	return path ? [path URLByAppendingPathComponent:[self lastPathComponent]] : self;
}

- (NSURL *)URLByAppendingPathComponents:(NSArray<NSString *> *)pathComponents {
	NSURL *url = self;
	for (NSString *pathComponent in pathComponents)
		url = [url URLByAppendingPathComponent:pathComponent];
	return url;
}

@end
