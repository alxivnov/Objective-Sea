//
//  UIBezierPath+Convenience.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 04.07.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import "UIBezierPath+Convenience.h"

@implementation UIBezierPath (Convenience)

+ (instancetype)bezierPathWithArcCenter:(CGPoint)center radius:(CGFloat)radius start:(CGFloat)start end:(CGFloat)end {
	CGFloat startAngle = 0.0;
	CGFloat endAngle = DEG_360;

	CGFloat angle = end - start;
	if (angle >= 0.0 && angle <= 1.0) {
		CGFloat deg_270 = DEG_360 / 4.0 * 3.0;

		startAngle = start * endAngle + deg_270;
		endAngle = end * endAngle + deg_270;
		//		startAngle += 1.5 * M_PI;
		//		endAngle *= angle;
		//		if (endAngle > startAngle)
		//			endAngle -= 0.5 * M_PI;
		//		else
		//			endAngle += startAngle;
	}

	return [self bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
}

+ (instancetype)bezierPathWithArcCenter:(CGPoint)center radius:(CGFloat)radius angle:(CGFloat)angle {
	return [self bezierPathWithArcCenter:center radius:radius start:0.0 end:angle];
}

+ (instancetype)bezierPathWithArcFrame:(CGRect)frame width:(CGFloat)width start:(CGFloat)start end:(CGFloat)end lineCap:(CGLineCap)lineCap lineJoin:(CGLineJoin)lineJoin {
	if (width < 0.0)
		width = fmin(frame.size.width, frame.size.height) * -width;

	UIBezierPath *path = [self bezierPathWithArcCenter:CGPointMake(frame.origin.x + frame.size.width / 2.0, frame.origin.y + frame.size.height / 2.0) radius:(fmin(frame.size.height, frame.size.width) - width) / 2.0 start:start end:end];
	path.lineWidth = width;

	path.lineCapStyle = lineCap;
	path.lineJoinStyle = lineJoin;

	return path;
}

+ (instancetype)bezierPathWithArcFrame:(CGRect)frame width:(CGFloat)width angle:(CGFloat)angle {
	return [self bezierPathWithArcFrame:frame width:width start:0.0 end:angle lineCap:kCGLineCapButt lineJoin:kCGLineJoinMiter];
}

- (CGRect)boundingBox {
	return CGPathGetBoundingBox(self.CGPath);
}

- (CGRect)pathBoundingBox {
	return CGPathGetPathBoundingBox(self.CGPath);
}

#if __has_include(<QuartzCore/QuartzCore.h>)

- (NSString *)layerLineCap {
	return self.lineCapStyle == kCGLineCapRound ? kCALineCapRound : self.lineCapStyle == kCGLineCapSquare ? kCALineCapSquare : kCALineCapButt;
}

- (NSString *)layerLineJoin {
	return self.lineJoinStyle == kCGLineJoinRound ? kCALineJoinRound : self.lineJoinStyle == kCGLineJoinBevel ? kCALineJoinBevel : kCALineJoinMiter;
}

- (CAShapeLayer *)layerWithStrokeColors:(NSArray<UIColor *> *)strokeColors fillColor:(UIColor *)fillColor lineWidth:(CGFloat)lineWidth {
	CAShapeLayer *layer = [CAShapeLayer layer];

	layer.lineCap = [self layerLineCap];
	layer.lineJoin = [self layerLineJoin];

	if (strokeColors.count > 1) {
		layer.shadowColor = strokeColors.lastObject.CGColor;
		layer.shadowOpacity = 1.0;
		layer.shadowRadius = 8.0;
	}

	layer.path = self.CGPath;
	layer.lineWidth = lineWidth > 0.0 ? lineWidth : self.lineWidth;
	layer.fillColor = (fillColor ? fillColor : [UIColor clearColor]).CGColor;
	layer.strokeColor = (strokeColors.count > 0 ? strokeColors.firstObject : [UIColor blackColor]).CGColor;

//	if (strokeColors.count < 2)
		return layer;
/*
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.colors = [strokeColors map:^id(UIColor *obj) {
		return obj.CGColor;
	}];
	gradient.frame = self.boundingBox;
	gradient.mask = layer;
	return gradient;
*/}

- (CAShapeLayer *)layerWithStrokeColors:(NSArray<UIColor *> *)strokeColors fillColor:(UIColor *)fillColor {
	return [self layerWithStrokeColors:strokeColors fillColor:fillColor lineWidth:0.0];
}

- (CAShapeLayer *)layerWithStrokeColors:(NSArray<UIColor *> *)strokeColors {
	return [self layerWithStrokeColors:strokeColors fillColor:Nil lineWidth:0.0];
}

#endif

@end
