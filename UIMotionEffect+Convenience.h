//
//  UIMotionEffect+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 18.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIInterpolatingMotionEffect (Convenience)

+ (instancetype)motionEffectWithType:(UIInterpolatingMotionEffectType)type keyPath:(NSString *)keyPath maxValue:(CGFloat)maxValue minValue:(CGFloat)minValue;

+ (instancetype)horizontalTiltWithKeyPath:(NSString *)keyPath maxValue:(CGFloat)maxValue minValue:(CGFloat)minValue;
+ (instancetype)horizontalTiltWithKeyPath:(NSString *)keyPath relativeValue:(CGFloat)relativeValue;

+ (instancetype)verticalTiltWithKeyPath:(NSString *)keyPath maxValue:(CGFloat)maxValue minValue:(CGFloat)minValue;
+ (instancetype)verticalTiltWithKeyPath:(NSString *)keyPath relativeValue:(CGFloat)relativeValue;

@end

@interface UIMotionEffectGroup (Convenience)

- (instancetype)initWithMotionEffects:(NSArray<__kindof UIMotionEffect *> *)motionEffects;

@end

@interface UIView (UIMotionEffect)

- (__kindof UIMotionEffect *)addTiltToCenter:(CGFloat)relativeValue;

@end
