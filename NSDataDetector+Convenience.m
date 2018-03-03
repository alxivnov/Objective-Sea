//
//  NSDataDetector+Convenience.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 21.01.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "NSDataDetector+Convenience.h"

@implementation NSDataDetector (Convenience)

- (NSUInteger)numberOfMatchesInString:(NSString *)string options:(NSMatchingOptions)options {
	return [self numberOfMatchesInString:string options:options range:NSMakeRange(0, [string length])];
}

- (NSUInteger)numberOfMatchesInString:(NSString *)string {
	return [self numberOfMatchesInString:string options:kNilOptions range:NSMakeRange(0, [string length])];
}

- (void)enumerateMatchesInString:(NSString *)string options:(NSMatchingOptions)options usingBlock:(void (^)(NSTextCheckingResult *, NSMatchingFlags, BOOL *))block {
	[self enumerateMatchesInString:string options:options range:NSMakeRange(0, [string length]) usingBlock:block];
}

- (void)enumerateMatchesInString:(NSString *)string usingBlock:(void (^)(NSTextCheckingResult *, NSMatchingFlags, BOOL *))block {
	[self enumerateMatchesInString:string options:kNilOptions range:NSMakeRange(0, [string length]) usingBlock:block];
}

- (NSArray *)matchesInString:(NSString *)string options:(NSMatchingOptions)options {
	return [self matchesInString:string options:options range:NSMakeRange(0, [string length])];
}

- (NSArray *)matchesInString:(NSString *)string {
	return [self matchesInString:string options:kNilOptions range:NSMakeRange(0, [string length])];
}

- (NSTextCheckingResult *)firstMatchInString:(NSString *)string options:(NSMatchingOptions)options {
	return [self firstMatchInString:string options:options range:NSMakeRange(0, [string length])];
}

- (NSTextCheckingResult *)firstMatchInString:(NSString *)string {
	return [self firstMatchInString:string options:kNilOptions range:NSMakeRange(0, [string length])];
}

- (NSRange)rangeOfFirstMatchInString:(NSString *)string options:(NSMatchingOptions)options {
	return [self rangeOfFirstMatchInString:string options:options range:NSMakeRange(0, [string length])];
}

- (NSRange)rangeOfFirstMatchInString:(NSString *)string {
	return [self rangeOfFirstMatchInString:string options:kNilOptions range:NSMakeRange(0, [string length])];
}

+ (NSDataDetector *)dataDetectorWithTypes:(NSTextCheckingTypes)checkingTypes {
	NSError *error = Nil;

	NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:checkingTypes error:&error];

	[error log:@"dataDetectorWithTypes:"];

	return detector;
}

static NSDataDetector *_dateDetector;

+ (NSDataDetector *)dateDetector {
	if (!_dateDetector)
		_dateDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeDate];

	return _dateDetector;
}

@end
