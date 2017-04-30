//
//  NSAttributedString+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 30.04.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import "NSAttributedString+Convenience.h"

@implementation NSAttributedString (Convenience)

- (NSAttributedString *)addAttribute:(NSString *)attribute withValue:(id)value andRange:(NSRange)range {
	NSMutableAttributedString *mutable = [self isKindOfClass:[NSMutableAttributedString class]]
	? (NSMutableAttributedString *)self
	: [self mutableCopy];

	[mutable addAttribute:attribute value:value range:range];

	return mutable;
}

- (NSAttributedString *)addAttribute:(NSString *)attribute withValue:(id)value {
	return [self addAttribute:attribute withValue:value andRange:NSMakeRange(0, [self length])];
}

- (NSAttributedString *)font:(UIFont *)font forRange:(NSRange)range {
	return [self addAttribute:NSFontAttributeName withValue:font andRange:range];
}

- (NSAttributedString *)font:(UIFont *)font {
	return [self font:font forRange:NSMakeRange(0, [self length])];
}

- (NSAttributedString *)strikethrough:(NSNumber *)styleAndPattern forRange:(NSRange)range {
	return [self addAttribute:NSStrikethroughStyleAttributeName withValue:styleAndPattern andRange:range];
}

- (NSAttributedString *)strikethrough:(NSRange)range {
	return [self strikethrough:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid) forRange:range];
}

- (NSAttributedString *)strikethrough {
	return [self strikethrough:NSMakeRange(0, [self length])];
}

- (NSAttributedString *)underline:(NSNumber *)styleAndPattern forRange:(NSRange)range {
	return [self addAttribute:NSUnderlineStyleAttributeName withValue:styleAndPattern andRange:range];
}

- (NSAttributedString *)underline:(NSRange)range {
	return [self underline:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid) forRange:range];
}

- (NSAttributedString *)underline {
	return [self underline:NSMakeRange(0, [self length])];
}

+ (instancetype)attributedStringWithString:(NSString *)str attributes:(NSDictionary<NSString *, id> *)attrs {
	return str ? [[self alloc] initWithString:str attributes:attrs] : Nil;
}

+ (instancetype)attributedStringWithString:(NSString *)str {
	return str ? [[self alloc] initWithString:str] : Nil;
}

@end
