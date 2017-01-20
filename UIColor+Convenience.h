//
//  UIColor+Convenience.h
//  Crowd Guard
//
//  Created by Alexander Ivanov on 25.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSObject+Convenience.h"

#define RGBA(r, g, b, a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a / 100.0]
#define RGB(r, g, b) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1.0]

#define HEX(v) [UIColor colorWithRed:((v & 0xFF0000) >> 16) / 255.0 green:((v & 0x00FF00) >> 8) / 255.0 blue:((v & 0x0000FF) >> 0) / 255.0 alpha:1.0]

#define HEX_IOS_BLUE 0x007AFF
#define HEX_IOS_GREEN 0x95C11F
#define HEX_IOS_RED 0xFF3B30

@interface UIColor (Convenience)

- (UIColor *)mixWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue value:(CGFloat)value;
- (UIColor *)mixWithColor:(UIColor *)anotherColor value:(CGFloat)value;
- (UIColor *)shaded:(CGFloat)value;
- (UIColor *)tinted:(CGFloat)value;
- (UIColor *)grayed:(CGFloat)value;
- (UIColor *)lightGrayed:(CGFloat)value;
- (UIColor *)darkGrayed:(CGFloat)value;

- (CGFloat)alphaComponent;

+ (UIColor *)colorWithHex:(NSUInteger)hex;

@end
