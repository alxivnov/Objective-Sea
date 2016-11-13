//
//  QuartzCore+Convenience.h
//  Crowd Guard
//
//  Created by Alexander Ivanov on 13.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#define CALayerKeyBounds @"bounds"
#define CALayerKeyOpacity @"opacity"
#define CALayerKeyPath @"path"
#define CALayerKeyStrokeStart @"strokeStart"
#define CALayerKeyStrokeEnd @"strokeEnd"

#define CAAnimationDurationXS 0.1
#define CAAnimationDurationS 0.333
#define CAAnimationDurationM 0.667
#define CAAnimationDurationL 1.0
#define CAAnimationDurationXL 2.0
#define CAAnimationDurationXXL 2.0
#define CAAnimationDurationXXXL 3.0

@interface CALayer (Convenience)

- (void)roundCorners:(CGFloat)radius;
- (void)roundCornersWithRatio:(CGFloat)ratio;
- (void)setBorderWidth:(CGFloat)width color:(CGColorRef)color;

- (CABasicAnimation *)addAnimationFromValue:(id)from toValue:(id)to forKey:(NSString *)key duration:(NSTimeInterval)duration beginTime:(NSTimeInterval)beginTime;
- (CABasicAnimation *)addAnimationFromValue:(id)from toValue:(id)to forKey:(NSString *)key duration:(NSTimeInterval)duration;
- (CABasicAnimation *)addAnimationFromValue:(id)from toValue:(id)to forKey:(NSString *)key;
- (CABasicAnimation *)addAnimationFromValue:(id)from toValue:(id)to;

@end

@interface CAShapeLayer (Convenience)

+ (instancetype)layerWithPath:(void (^)(CGMutablePathRef path))draw fillColor:(CGColorRef)fillColor strokeColor:(CGColorRef)strokeColor;
+ (instancetype)layerWithPath:(void (^)(CGMutablePathRef path))draw fillColor:(CGColorRef)fillColor;
+ (instancetype)layerWithPath:(void (^)(CGMutablePathRef path))draw strokeColor:(CGColorRef)strokeColor;
+ (instancetype)layerWithPath:(void (^)(CGMutablePathRef path))draw;

@end
