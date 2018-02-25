//
//  UIView+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UIView+Convenience.h"

@implementation UIView (Convenience)

- (void)hideSubviews {
	for (UIView *subview in self.subviews)
		subview.hidden = YES;
}

- (void)showSubviews {
	for (UIView *subview in self.subviews)
		subview.hidden = NO;
}

- (__kindof UIView *)rootview {
	UIView *rootview = self;
	while (rootview.superview && ![rootview.superview isKindOfClass:[UIWindow class]])
		rootview = rootview.superview;
	return rootview;
}

- (__kindof UIView *)subview:(BOOL (^)(UIView *))block {
	for (UIView *view in self.subviews) {
		UIView *subview = block && block(view) ? view : [view subview:block];
		if (subview)
			return subview;
	}
	return Nil;
}

- (UIColor *)rootBackgroundColor {
	UIView *view = self;
	while (view.backgroundColor == Nil || view.backgroundColor == [UIColor clearColor])
		view = view.superview;
	return view.backgroundColor;
}

- (void)bringToFront {
	[self.superview bringSubviewToFront:self];
}

- (BOOL)centerSubview:(UIView *)subview {
	if (subview == nil)
		return NO;

	CGRect frame = CGRectCenterInRect(subview.frame, self.bounds);
	if (CGRectEqualToRect(subview.frame, frame))
		return NO;

	subview.frame = frame;

	return YES;
}

- (BOOL)centerInSuperview:(UIView *)superview {
	return [superview centerSubview:self];
}

- (BOOL)centerInSuperview {
	return [self.superview centerInSuperview];
}

- (void)dock:(UIPosition)position inside:(BOOL)inside margin:(CGFloat)margin view:(UIView *)view {
	CGRect rect = view ? view.frame : self.superview.bounds;

	if (position == UIPositionBottom)
		self.frame = CGRectSetY(self.frame, rect.origin.y + rect.size.height + (inside ? -(self.frame.size.height + margin) : margin));
	else if (position == UIPositionLeft)
		self.frame = CGRectSetX(self.frame, rect.origin.x + (inside ? margin : -(self.frame.size.width + margin)));
	else if (position == UIPositionRight)
		self.frame = CGRectSetX(self.frame, rect.origin.x + rect.size.width + (inside ? -(self.frame.size.width + margin) : margin));
	else if (position == UIPositionTop)
		self.frame = CGRectSetY(self.frame, rect.origin.y + (inside ? margin : -(self.frame.size.height + margin)));
}

- (void)dock:(UIPosition)position inside:(BOOL)inside margin:(CGFloat)margin {
	[self dock:position inside:inside margin:margin view:Nil];
}

- (void)dock:(UIPosition)position inside:(BOOL)inside {
	[self dock:position inside:inside margin:0.0 view:Nil];
}

- (void)dock:(UIPosition)position {
	[self dock:position inside:NO margin:0.0 view:Nil];
}

- (UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates {
	return [UIImage imageWithSize:self.bounds.size opaque:YES scale:0.0 draw:^(CGContextRef context) {
		[self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterUpdates];
	}];
}

- (UIImage *)snapshotImage {
	return [self snapshotImageAfterScreenUpdates:NO];
}

- (UIView *)snapshotView {
	return [self snapshotViewAfterScreenUpdates:NO];
}

- (UIViewController *)embedInViewController {
	UIViewController *vc = [UIViewController new];
	vc.view = self;
	return vc;
}

- (void)setHidden:(BOOL)hidden duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion {
	if (self.hidden == hidden)
		return;

	CGFloat alpha = self.alpha;
	if (!hidden) {
		self.alpha = 0.0;
		self.hidden = NO;
	}

	[UIView animateWithDuration:duration delay:delay usingSpringWithDamping:ANIMATION_DAMPING initialSpringVelocity:ANIMATION_VELOCITY options:ANIMATION_OPTIONS animations:^{
		self.alpha = hidden ? 0.0 : alpha;

		if (animations)
			animations();
	} completion:^(BOOL finished) {
		if (hidden) {
			self.hidden = YES;
			self.alpha = alpha;
		}

		if (completion)
			completion(finished);
	}];
}

- (void)setHidden:(BOOL)hidden duration:(NSTimeInterval)duration completion:(void (^)(BOOL))completion {
	[self setHidden:hidden duration:duration delay:0.0 animations:Nil completion:completion];
}

#define CGPointWithDirection(direction, offset) CGPointMake(direction == UIDirectionLeft ? -offset : direction == UIDirectionRight ? offset : 0.0, direction == UIDirectionUp ? offset : direction == UIDirectionDown ? -offset : 0.0)

- (void)shake:(UIDirection)direction duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion {
	if (self.hidden)
		return;

	CGFloat offset = self.frame.size.height < 512 && self.frame.size.width < 512 ? 1.0 : self.frame.size.height < 1024 && self.frame.size.width < 1024 ? 2.0 : 3.0;

	duration = duration / 5.0;
	[UIView animateWithDuration:duration delay:delay usingSpringWithDamping:ANIMATION_DAMPING initialSpringVelocity:ANIMATION_VELOCITY options:ANIMATION_OPTIONS animations:^{
		CGPoint origin = CGPointWithDirection(direction, 10.0 * offset);
		self.frame = CGRectOffsetOrigin(self.frame, origin);
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:ANIMATION_DAMPING initialSpringVelocity:ANIMATION_VELOCITY options:ANIMATION_OPTIONS animations:^{
			CGPoint origin = CGPointWithDirection(direction, -17.0 * offset);
			self.frame = CGRectOffsetOrigin(self.frame, origin);
		} completion:^(BOOL finished) {
			[UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:ANIMATION_DAMPING initialSpringVelocity:ANIMATION_VELOCITY options:ANIMATION_OPTIONS animations:^{
				CGPoint origin = CGPointWithDirection(direction, 13.0 * offset);
				self.frame = CGRectOffsetOrigin(self.frame, origin);

				if (animations)
					animations();
			} completion:^(BOOL finished) {
				[UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:ANIMATION_DAMPING initialSpringVelocity:ANIMATION_VELOCITY options:ANIMATION_OPTIONS animations:^{
					CGPoint origin = CGPointWithDirection(direction, -8.0 * offset);
					self.frame = CGRectOffsetOrigin(self.frame, origin);
				} completion:^(BOOL finished) {
					[UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:ANIMATION_DAMPING initialSpringVelocity:ANIMATION_VELOCITY options:ANIMATION_OPTIONS animations:^{
						CGPoint origin = CGPointWithDirection(direction, 2.0 * offset);
						self.frame = CGRectOffsetOrigin(self.frame, origin);
					} completion:completion];
				}];
			}];
		}];
	}];
}

- (void)shake:(UIDirection)direction duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion {
	[self shake:direction duration:duration delay:0.0 animations:Nil completion:completion];
}

- (void)burst:(CGFloat)scale duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion {
	if (self.hidden)
		return;

	CGAffineTransform transform = self.transform;

	duration = duration / 2.0;
	[UIView animateWithDuration:duration delay:delay usingSpringWithDamping:ANIMATION_DAMPING initialSpringVelocity:ANIMATION_VELOCITY options:ANIMATION_OPTIONS animations:^{
		self.transform = CGAffineTransformMakeScale(scale, scale);
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:ANIMATION_DAMPING initialSpringVelocity:ANIMATION_VELOCITY options:ANIMATION_OPTIONS animations:^{
			self.transform = transform;

			if (animations)
				animations();
		} completion:completion];
	}];
}

- (void)burst:(CGFloat)scale duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion {
	[self burst:scale duration:duration delay:0.0 animations:Nil completion:completion];
}

- (void)blink:(UIColor *)color duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion {
	if (self.hidden)
		return;

	UIColor *backgroundColor = self.backgroundColor;
	[UIView animateWithDuration:duration < 0.0 ? 0.0 : duration / 2.0 delay:0.0 usingSpringWithDamping:ANIMATION_DAMPING initialSpringVelocity:ANIMATION_VELOCITY options:ANIMATION_OPTIONS animations:^{
		self.backgroundColor = color;
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:duration < 0.0 ? 1.0 - duration : duration / 2.0 delay:0.0 usingSpringWithDamping:ANIMATION_DAMPING initialSpringVelocity:ANIMATION_VELOCITY options:ANIMATION_OPTIONS animations:^{
			self.backgroundColor = backgroundColor;

			if (animations)
				animations();
		} completion:completion];
	}];
}

- (void)blink:(UIColor *)color duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion {
	[self blink:color duration:duration delay:0.0 animations:Nil completion:completion];
}

- (void)animate:(CGAffineTransform)transform duration:(NSTimeInterval)duration damping:(CGFloat)damping velocity:(CGFloat)velocity options:(UIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion {
	self.transform = transform;

	[UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:damping initialSpringVelocity:velocity options:options animations:^{
		self.transform = CGAffineTransformIdentity;
	} completion:completion];
}

- (void)animate:(CGAffineTransform)transform duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(void (^)(BOOL))completion {
	[self animate:transform duration:duration damping:ANIMATION_DAMPING velocity:ANIMATION_VELOCITY options:options completion:completion];
}

- (BOOL)iPad {
	return self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular && self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular;
}

- (BOOL)iPhone {
	return !self.iPad;
}

@end
