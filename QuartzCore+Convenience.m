//
//  QuartzCore+Convenience.m
//  Crowd Guard
//
//  Created by Alexander Ivanov on 13.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "QuartzCore+Convenience.h"

@implementation CALayer (Convenience)

- (void)roundCorners:(CGFloat)radius {
	self.cornerRadius = radius;
	self.masksToBounds = YES;
}

- (void)roundCornersWithRatio:(CGFloat)ratio {
	if (ratio > 0.0)
		[self roundCorners:fminf(self.frame.size.width, self.frame.size.height) / (2.0 * ratio)];
}

- (void)setBorderWidth:(CGFloat)width color:(CGColorRef)color {
	self.borderColor = color;
	self.borderWidth = width;
}

- (CABasicAnimation *)addAnimationFromValue:(id)from toValue:(id)to forKey:(NSString *)key duration:(NSTimeInterval)duration beginTime:(NSTimeInterval)beginTime {
	CABasicAnimation *animation = [CABasicAnimation new];
	if (beginTime > 0.0) {
		animation.beginTime = [self convertTime:CACurrentMediaTime() fromLayer:nil] + beginTime;
		animation.fillMode = kCAFillModeBackwards;
	}
	animation.duration = duration;
	animation.fromValue = from;
	animation.toValue = to;

	[self addAnimation:animation forKey:key];

	return animation;
}

- (CABasicAnimation *)addAnimationFromValue:(id)from toValue:(id)to forKey:(NSString *)key duration:(NSTimeInterval)duration {
	return [self addAnimationFromValue:from toValue:to forKey:key duration:duration beginTime:0.0];
}

- (CABasicAnimation *)addAnimationFromValue:(id)from toValue:(id)to forKey:(NSString *)key {
	return [self addAnimationFromValue:from toValue:to forKey:key duration:0.0 beginTime:0.0];
}

- (CABasicAnimation *)addAnimationFromValue:(id)from toValue:(id)to {
	return [self addAnimationFromValue:from toValue:to forKey:Nil duration:0.0 beginTime:0.0];
}

@end

@implementation CAShapeLayer (Convenience)

+ (instancetype)layerWithPath:(void(^)(CGMutablePathRef))draw fillColor:(CGColorRef)fillColor strokeColor:(CGColorRef)strokeColor {
	CAShapeLayer *layer = [CAShapeLayer layer];

	if (!draw)
		return layer;

	CGMutablePathRef path = CGPathCreateMutable();

	draw(path);

	layer.path = path;

	CGPathRelease(path);

	layer.fillColor = fillColor;
	layer.strokeColor = strokeColor;

	layer.frame = CGPathGetPathBoundingBox(layer.path);

	return layer;
}

+ (instancetype)layerWithPath:(void (^)(CGMutablePathRef))draw fillColor:(CGColorRef)fillColor {
	return [self layerWithPath:draw fillColor:fillColor strokeColor:Nil];
}

+ (instancetype)layerWithPath:(void(^)(CGMutablePathRef))draw strokeColor:(CGColorRef)strokeColor {
	return [self layerWithPath:draw fillColor:Nil strokeColor:strokeColor];
}

+ (instancetype)layerWithPath:(void (^)(CGMutablePathRef))draw {
	return [self layerWithPath:draw fillColor:Nil strokeColor:Nil];
}

@end
