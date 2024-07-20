//
//  NSString+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSArray+Convenience.h"
#import "NSObject+Convenience.h"

@interface NSString (Convenience)

- (NSUInteger)numberOfLines;

- (BOOL)isEqualToAnyString:(NSArray<NSString *> *)strings;

- (BOOL)containsString:(NSString *)aString options:(NSStringCompareOptions)mask range:(NSRange)searchRange locale:(NSLocale *)locale;
- (BOOL)containsString:(NSString *)aString options:(NSStringCompareOptions)mask locale:(NSLocale *)locale;

- (BOOL)caseInsensitiveContainsString:(NSString *)aString;
- (BOOL)localizedCaseInsensitiveContainsString:(NSString *)aString;
- (BOOL)caseInsensitiveContainsAnyString:(NSArray<NSString *> *)strings;
- (BOOL)localizedCaseInsensitiveContainsAnyString:(NSArray<NSString *> *)strings;
- (BOOL)caseInsensitiveContainsAllStrings:(NSArray<NSString *> *)strings;
- (BOOL)localizedCaseInsensitiveContainsAllStrings:(NSArray<NSString *> *)strings;

- (NSString *)stringByRemovingCharactersInSet:(NSCharacterSet *)set;
- (NSString *)stringBySelectingCharactersInSet:(NSCharacterSet *)set;
@property (strong, nonatomic, readonly) NSString *stringByTrimmingWhitespace;
@property (assign, nonatomic, readonly) BOOL isWhitespace;

- (NSString *)uppercaseFirstLetter;

+ (instancetype)stringWithFormat:(NSString *)format arguments:(NSArray *)arguments;
+ (instancetype)stringWithLocalizedFormat:(NSString *)format arguments:(NSArray *)arguments;

- (NSString *)stringByApplyingTransform:(NSString *)transform;

- (NSString *)stringByReplacingMatches:(NSString *)pattern options:(NSRegularExpressionOptions)options range:(NSRange)range withTemplate:(NSString *)templ;
- (NSString *)stringByReplacingMatches:(NSString *)pattern options:(NSRegularExpressionOptions)options withTemplate:(NSString *)templ;
- (NSString *)stringByReplacingMatches:(NSString *)pattern withTemplate:(NSString *)templ;

- (NSString *)stringByReplacingDictionary:(NSDictionary *)dic;

- (NSString *)fileSystemString;

- (NSString *)stringByAppendingExtension:(NSString *)extension;

- (NSString *)fileName:(NSString *)extension;
- (NSString *)fileName;

- (NSString *)stringByAppendingNewLine;
- (NSString *)stringByAppendingNewLineWithString:(NSString *)aString;

+ (instancetype)stringWithData:(NSData *)data encoding:(NSStringEncoding *)encodingInOut;
+ (instancetype)stringWithData:(NSData *)data;

- (NSAttributedString *)attributedString:(NSDictionary<NSAttributedStringKey, id> *)attrs;

@end
