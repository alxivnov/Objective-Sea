//
//  NSString+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "NSString+Convenience.h"

@implementation NSString (Calculation)

- (NSUInteger)numberOfLines {
	__block NSUInteger count = 0;

	[self enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
		count++;
	}];

	return count;
}

- (BOOL)isEqualToAnyString:(NSArray *)strings {
	return [strings any:^BOOL(id item) {
		return [self isEqualToString:item];
	}];
}

- (BOOL)containsString:(NSString *)aString options:(NSStringCompareOptions)mask range:(NSRange)searchRange locale:(NSLocale *)locale {
	NSRange range = [self rangeOfString:aString options:mask range:searchRange locale:locale];

	return range.location != NSNotFound && range.length > 0;
}

- (BOOL)containsString:(NSString *)aString options:(NSStringCompareOptions)mask locale:(NSLocale *)locale {
	return [self containsString:aString options:mask range:NSMakeRange(0, self.length) locale:Nil];
}

- (BOOL)caseInsensitiveContainsString:(NSString *)aString {
	return [self containsString:aString options:NSCaseInsensitiveSearch locale:Nil];
}

- (BOOL)localizedCaseInsensitiveContainsString:(NSString *)aString {
	return [self containsString:aString options:0 locale:[NSLocale currentLocale]];
}

- (BOOL)caseInsensitiveContainsAnyString:(NSArray<NSString *> *)strings {
	return [strings any:^BOOL(NSString *obj) {
		return [self caseInsensitiveContainsString:obj];
	}];
}

- (BOOL)localizedCaseInsensitiveContainsAnyString:(NSArray<NSString *> *)strings {
	return [strings any:^BOOL(NSString *obj) {
		return [self localizedCaseInsensitiveContainsString:obj];
	}];
}

- (BOOL)caseInsensitiveContainsAllStrings:(NSArray<NSString *> *)strings {
	return [strings all:^BOOL(NSString *obj) {
		return [self caseInsensitiveContainsString:obj];
	}];
}

- (BOOL)localizedCaseInsensitiveContainsAllStrings:(NSArray<NSString *> *)strings {
	return [strings all:^BOOL(NSString *obj) {
		return [self localizedCaseInsensitiveContainsString:obj];
	}];
}

- (NSString *)stringByRemovingCharactersInSet:(NSCharacterSet *)set {
	return [[self componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
}

- (NSString *)stringBySelectingCharactersInSet:(NSCharacterSet *)set {
	return [self stringByRemovingCharactersInSet:[set invertedSet]];
}

- (BOOL)isWhitespace {
	return ![self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length;
}

- (NSString *)uppercaseFirstLetter {
	return [[[self substringToIndex:1] uppercaseString] stringByAppendingString:[self substringFromIndex:1]];
}

#define INDEX(array, index) array.count > index ? array[index] : @""

+ (instancetype)stringWithFormat:(NSString *)format arguments:(NSArray *)arguments {
	return [self stringWithFormat:format, INDEX(arguments, 0), INDEX(arguments, 1), INDEX(arguments, 2), INDEX(arguments, 3), INDEX(arguments, 4), INDEX(arguments, 5), INDEX(arguments, 6), INDEX(arguments, 7), INDEX(arguments, 8), INDEX(arguments, 9)];
}

+ (instancetype)stringWithLocalizedFormat:(NSString *)format arguments:(NSArray *)arguments {
	return [self stringWithFormat:NSLocalizedString(format, Nil), INDEX(arguments, 0), INDEX(arguments, 1), INDEX(arguments, 2), INDEX(arguments, 3), INDEX(arguments, 4), INDEX(arguments, 5), INDEX(arguments, 6), INDEX(arguments, 7), INDEX(arguments, 8), INDEX(arguments, 9)];
}

- (NSString *)stringByApplyingTransform:(NSString *)transform {
	NSString *string = [self stringByApplyingTransform:transform reverse:NO];
	return string ? string : self;
}

- (NSString *)stringByReplacingMatches:(NSString *)pattern options:(NSRegularExpressionOptions)options range:(NSRange)range withTemplate:(NSString *)templ {
	NSError *error = Nil;
	NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
	NSString *string = [regEx stringByReplacingMatchesInString:self options:0 range:range withTemplate:templ];

	[error log:@"stringByReplacingMatchesInString:"];

	return error ? self : string;
}

- (NSString *)stringByReplacingMatches:(NSString *)pattern options:(NSRegularExpressionOptions)options withTemplate:(NSString *)templ {
	return [self stringByReplacingMatches:pattern options:options range:NSMakeRange(0, self.length) withTemplate:templ];
}

- (NSString *)stringByReplacingMatches:(NSString *)pattern withTemplate:(NSString *)templ {
	return [self stringByReplacingMatches:pattern options:0 range:NSMakeRange(0, self.length)  withTemplate:templ];
}

- (NSString *)fileSystemString {
	return [[self stringByReplacingOccurrencesOfString:STR_COLON withString:STR_HYPHEN] stringByReplacingOccurrencesOfString:STR_SLASH withString:STR_UNDERSCORE];
}

- (NSString *)stringByAppendingExtension:(NSString *)extension {
	return extension.length ? [self stringByAppendingFormat:[extension hasPrefix:STR_DOT] ? extension : @".%@", extension] : self;
}

- (NSString *)fileName:(NSString *)extension {
	NSString *fileName = [self stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
	fileName = [fileName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
	fileName = [fileName stringByReplacingOccurrencesOfString:@"\\" withString:@"_"];
	fileName = [fileName stringByAppendingExtension:extension];
	return fileName;
}

- (NSString *)fileName {
	return [self fileName:Nil];
}

- (NSString *)stringByAppendingNewLine {
	return [self stringByAppendingString:STR_NEW_LINE];
}

- (NSString *)stringByAppendingNewLineWithString:(NSString *)aString {
	return aString.length ? [[self stringByAppendingNewLine] stringByAppendingString:aString] : self;
}

+ (instancetype)stringWithData:(NSData *)data encoding:(NSStringEncoding *)encodingInOut {
	NSString *string = Nil;
	NSStringEncoding encoding = [NSString stringEncodingForData:data encodingOptions:encodingInOut && *encodingInOut ? @{ NSStringEncodingDetectionSuggestedEncodingsKey : @[ @(*encodingInOut) ] } : Nil convertedString:&string usedLossyConversion:Nil];
	if (encodingInOut)
		*encodingInOut = encoding;
	return string;
}

+ (instancetype)stringWithData:(NSData *)data {
	return [self stringWithData:data encoding:Nil];
}

@end
