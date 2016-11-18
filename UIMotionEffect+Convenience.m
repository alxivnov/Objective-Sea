//
//  UIMotionEffect+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 18.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UIMotionEffect+Convenience.h"

@implementation UIInterpolatingMotionEffect (Convenience)

+ (instancetype)motionEffectWithType:(UIInterpolatingMotionEffectType)type keyPath:(NSString *)keyPath maxValue:(CGFloat)maxValue minValue:(CGFloat)minValue {
	UIInterpolatingMotionEffect *instance = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:keyPath type:type];
	instance.maximumRelativeValue = @(maxValue);
	instance.minimumRelativeValue = @(minValue);
	return instance;
}

+ (instancetype)horizontalTiltWithKeyPath:(NSString *)keyPath maxValue:(CGFloat)maxValue minValue:(CGFloat)minValue {
	return [self motionEffectWithType:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis keyPath:keyPath maxValue:maxValue minValue:minValue];
}

+ (instancetype)horizontalTiltWithKeyPath:(NSString *)keyPath relativeValue:(CGFloat)relativeValue {
	return [self motionEffectWithType:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis keyPath:keyPath maxValue:relativeValue minValue:-relativeValue];
}

+ (instancetype)verticalTiltWithKeyPath:(NSString *)keyPath maxValue:(CGFloat)maxValue minValue:(CGFloat)minValue {
	return [self motionEffectWithType:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis keyPath:keyPath maxValue:maxValue minValue:minValue];
}

+ (instancetype)verticalTiltWithKeyPath:(NSString *)keyPath relativeValue:(CGFloat)relativeValue {
	return [self motionEffectWithType:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis keyPath:keyPath maxValue:relativeValue minValue:-relativeValue];
}

@end

@implementation UIMotionEffectGroup (Convenience)

- (instancetype)initWithMotionEffects:(NSArray *)motionEffects {
	self = [super init];

	if (self)
		self.motionEffects = motionEffects;

	return self;
}

@end

@implementation UIView (UIMotionEffect)

- (UIMotionEffect *)addTiltToCenter:(CGFloat)relativeValue {
	UIInterpolatingMotionEffect *horizontal = [UIInterpolatingMotionEffect horizontalTiltWithKeyPath:@"center.x" relativeValue:relativeValue];
	UIInterpolatingMotionEffect *vertical = [UIInterpolatingMotionEffect verticalTiltWithKeyPath:@"center.y" relativeValue:relativeValue];
	UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] initWithMotionEffects:@[ horizontal, vertical ]];

	[self addMotionEffect:group];

	return group;
}

@end
