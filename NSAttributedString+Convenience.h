//
//  NSAttributedString+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 30.04.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface NSAttributedString (Convenience)

- (NSAttributedString *)font:(UIFont *)font forRange:(NSRange)range;
- (NSAttributedString *)font:(UIFont *)font;

- (NSAttributedString *)strikethrough:(NSNumber *)styleAndPattern forRange:(NSRange)range;
- (NSAttributedString *)strikethrough:(NSRange)range;
- (NSAttributedString *)strikethrough;

- (NSAttributedString *)underline:(NSNumber *)styleAndPattern forRange:(NSRange)range;
- (NSAttributedString *)underline:(NSRange)range;
- (NSAttributedString *)underline;

+ (instancetype)attributedStringWithString:(NSString *)str attributes:(NSDictionary<NSString *, id> *)attrs;
+ (instancetype)attributedStringWithString:(NSString *)str;

@end
