//
//  UIBezierPath+Convenience.h
//  Sleep Diary
//
//  Created by Alexander Ivanov on 04.07.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<QuartzCore/QuartzCore.h>)

@import QuartzCore;

#endif

#define DEG_360 (2.0 * M_PI)

#import "NSArray+Convenience.h"

@interface UIBezierPath (Convenience)

+ (instancetype)bezierPathWithArcFrame:(CGRect)frame width:(CGFloat)width start:(CGFloat)start end:(CGFloat)end lineCap:(CGLineCap)lineCap lineJoin:(CGLineJoin)lineJoin;
+ (instancetype)bezierPathWithArcFrame:(CGRect)frame width:(CGFloat)width angle:(CGFloat)angle;

@property (assign, nonatomic, readonly) CGRect boundingBox;
@property (assign, nonatomic, readonly) CGRect pathBoundingBox;

#if __has_include(<QuartzCore/QuartzCore.h>)

- (CALayer *)layerWithStrokeColors:(NSArray<UIColor *> *)strokeColors fillColor:(UIColor *)fillColor lineWidth:(CGFloat)lineWidth;
- (CALayer *)layerWithStrokeColors:(NSArray<UIColor *> *)strokeColors fillColor:(UIColor *)fillColor;
- (CALayer *)layerWithStrokeColors:(NSArray<UIColor *> *)strokeColors;

#endif

@end
