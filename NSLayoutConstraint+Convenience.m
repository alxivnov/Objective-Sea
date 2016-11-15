//
//  NSLayoutConstraint+Convenience.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "NSLayoutConstraint+Convenience.h"

@implementation UIView (Constraints)

- (void)equal:(NSLayoutAttribute)selfAttribute view:(UIView *)view attribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant {
	view.translatesAutoresizingMaskIntoConstraints = NO;

	[self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:attribute relatedBy:NSLayoutRelationEqual toItem:self attribute:selfAttribute multiplier:1.0 constant:constant]];
}

- (void)equal:(NSLayoutAttribute)selfAttribute view:(UIView *)view attribute:(NSLayoutAttribute)attribute {
	[self equal:selfAttribute view:view attribute:attribute constant:0.0];
}

- (void)equal:(NSLayoutAttribute)selfAttribute view:(UIView *)view {
	[self equal:selfAttribute view:view attribute:selfAttribute constant:0.0];
}

- (void)equalSize:(UIView *)view {
	[self equal:NSLayoutAttributeWidth view:view];
	[self equal:NSLayoutAttributeHeight view:view];
}

- (void)equalCenter:(UIView *)view constant:(CGPoint)constant {
	[self equal:NSLayoutAttributeCenterX view:view attribute:NSLayoutAttributeCenterX constant:constant.x];
	[self equal:NSLayoutAttributeCenterY view:view attribute:NSLayoutAttributeCenterY constant:constant.y];
}

- (void)equalCenter:(UIView *)view {
	[self equalCenter:view constant:CGPointZero];
}

@end
