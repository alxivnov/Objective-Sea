//
//  UIColor+Convenience.m
//  Crowd Guard
//
//  Created by Alexander Ivanov on 25.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UIColor+Convenience.h"

@implementation UIColor (Convenience)

- (UIColor *)mixWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue value:(CGFloat)value {
	CGFloat r = 0.0;
	CGFloat g = 0.0;
	CGFloat b = 0.0;
	CGFloat a = 1.0;
	if (![self getRed:&r green:&g blue:&b alpha:&a])
		return self;
	if (value < -1.0)
		value = -1.0;
	else if (value > 1.0)
		value = 1.0;
	if (value < 0.0)
		value = 1.0 + value;
	r = r + (red - r) * value;
	g = g + (green - g) * value;
	b = b + (blue - b) * value;
	return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

- (UIColor *)mixWithColor:(UIColor *)anotherColor value:(CGFloat)value {
	CGFloat r = 0.0;
	CGFloat g = 0.0;
	CGFloat b = 0.0;
	CGFloat a = 1.0;
	if (![anotherColor getRed:&r green:&g blue:&b alpha:&a])
		return self;
	return [self mixWithRed:r green:g blue:b value:value];
}

- (UIColor *)shaded:(CGFloat)value {
	return [self mixWithRed:0.0 green:0.0 blue:0.0 value:value];
}

- (UIColor *)tinted:(CGFloat)value {
	return [self mixWithRed:1.0 green:1.0 blue:1.0 value:value];
}

- (UIColor *)grayed:(CGFloat)value {
	return [self mixWithRed:0.5 green:0.5 blue:0.5 value:value];
}

- (UIColor *)darkGrayed:(CGFloat)value {
	return [self mixWithRed:0.333 green:0.333 blue:0.333 value:value];
}

- (UIColor *)lightGrayed:(CGFloat)value {
	return [self mixWithRed:0.666 green:0.666 blue:0.666 value:value];
}

- (CGFloat)alphaComponent {
	CGFloat alpha = 0.0;
	return [self getRed:Nil green:Nil blue:Nil alpha:&alpha] ? alpha : 0.0;
}

__static(NSMutableDictionary *, colors, [NSMutableDictionary new])

+ (UIColor *)color:(NSUInteger)hex {
	NSNumber *key = @(hex);

	UIColor *value = [self colors][key];

	if (!value)
		[self colors][key] = value = HEX(hex);

	return value;
}

+ (UIColor *)colorWithR:(NSUInteger)red G:(NSUInteger)green B:(NSUInteger)blue {
	return [self color:red << 16 | green << 8 | blue];
}

+ (UIColor *)colorWithW:(NSUInteger)white {
	return [self color:white << 16 | white << 8 | white];
}

@end
