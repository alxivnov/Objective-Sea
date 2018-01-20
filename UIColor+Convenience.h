//
//  UIColor+Convenience.h
//  Crowd Guard
//
//  Created by Alexander Ivanov on 25.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSObject+Convenience.h"

#define WA(w, a) [UIColor colorWithWhite:w / 255.0 alpha:a / 255.0]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a / 100.0]
#define RGB(r, g, b) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1.0]

#define HEX(v) [UIColor colorWithRed:((v & 0xFF0000) >> 16) / 255.0 green:((v & 0x00FF00) >> 8) / 255.0 blue:((v & 0x0000FF) >> 0) / 255.0 alpha:1.0]

#define HEX_IOS_BLUE 0x007AFF
#define HEX_IOS_GREEN 0x4CD964
#define HEX_IOS_RED 0xFF3B30
#define HEX_IOS_YELLOW 0xE4AF0A

#define HEX_IOS_WHITE 0xFAFAFF
#define HEX_IOS_LIGHT_GRAY 0xEFEFF4
#define HEX_IOS_GRAY 0xC7C7CC
#define HEX_IOS_DARK_GRAY 0x8E8E93	// not sure
#define HEX_IOS_BLACK 0x171717

#define HEX_NCS_BLUE 0x0087BD
#define HEX_NCS_GREEN 0x009F6B
#define HEX_NCS_RED 0xC40233
#define HEX_NCS_YELLOW 0xFFD300

// https://www.competethemes.com/blog/social-media-colors/
#define HEX_FB_BLUE 0x3b5998
#define HEX_TW_BLUE 0x00aced
#define HEX_VK_BLUE 0x45668e

@interface UIColor (Convenience)

- (UIColor *)mixWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue value:(CGFloat)value;
- (UIColor *)mixWithColor:(UIColor *)anotherColor value:(CGFloat)value;
- (UIColor *)shaded:(CGFloat)value;
- (UIColor *)tinted:(CGFloat)value;
- (UIColor *)grayed:(CGFloat)value;
- (UIColor *)lightGrayed:(CGFloat)value;
- (UIColor *)darkGrayed:(CGFloat)value;

- (CGFloat)alphaComponent;

+ (UIColor *)color:(NSUInteger)hex;

@end
