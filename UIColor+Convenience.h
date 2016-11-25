//
//  UIColor+Convenience.h
//  Crowd Guard
//
//  Created by Alexander Ivanov on 25.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGBA(r, g, b, a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a / 100.0]
#define RGB(r, g, b) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1.0]

@interface UIColor (Convenience)

- (UIColor *)mixWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue value:(CGFloat)value;
- (UIColor *)mixWithColor:(UIColor *)anotherColor value:(CGFloat)value;
- (UIColor *)shaded:(CGFloat)value;
- (UIColor *)tinted:(CGFloat)value;
- (UIColor *)grayed:(CGFloat)value;
- (UIColor *)lightGrayed:(CGFloat)value;
- (UIColor *)darkGrayed:(CGFloat)value;

- (CGFloat)alphaComponent;

@end
