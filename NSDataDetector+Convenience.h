//
//  NSDataDetector+Convenience.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 21.01.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSObject+Convenience.h"

@interface NSDataDetector (Convenience)

- (NSUInteger)numberOfMatchesInString:(NSString *)string options:(NSMatchingOptions)options;
- (NSUInteger)numberOfMatchesInString:(NSString *)string;

- (void)enumerateMatchesInString:(NSString *)string options:(NSMatchingOptions)options usingBlock:(void (^)(NSTextCheckingResult *, NSMatchingFlags, BOOL *))block;
- (void)enumerateMatchesInString:(NSString *)string usingBlock:(void (^)(NSTextCheckingResult *, NSMatchingFlags, BOOL *))block;

- (NSArray *)matchesInString:(NSString *)string options:(NSMatchingOptions)options;
- (NSArray *)matchesInString:(NSString *)string;

- (NSTextCheckingResult *)firstMatchInString:(NSString *)string options:(NSMatchingOptions)options;
- (NSTextCheckingResult *)firstMatchInString:(NSString *)string;

- (NSRange)rangeOfFirstMatchInString:(NSString *)string options:(NSMatchingOptions)options;
- (NSRange)rangeOfFirstMatchInString:(NSString *)string;

+ (NSDataDetector *)dateDetector;

@end
