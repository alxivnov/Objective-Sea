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

- (__kindof UIView *)root {
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

- (__kindof UIView *)subviewKindOfClass:(Class)aClass {
	return [self subview:^BOOL(UIView *subview) {
		return [subview isKindOfClass:aClass];
	}];
}

- (__kindof UIView *)subviewMemberOfClass:(Class)aClass {
	return [self subview:^BOOL(UIView *subview) {
		return [subview isMemberOfClass:aClass];
	}];
}

- (UIViewController *)embedInViewController {
	UIViewController *vc = [UIViewController new];
	vc.view = self;
	return vc;
}

- (UIColor *)calculatedBackgroundColor {
	UIColor *clear = [UIColor clearColor];
	UIView *view = self;
	while (view.backgroundColor == Nil || view.backgroundColor == clear)
		view = view.superview;
	return view.backgroundColor;
}

@end

@implementation UIView (Position)

+ (UIPosition)invertPosition:(UIPosition)position {
	switch (position) {
		case UIPositionBottom:
			return UIPositionTop;
		case UIPositionLeft:
			return UIPositionRight;
		case UIPositionRight:
			return UIPositionLeft;
		case UIPositionTop:
			return UIPositionBottom;
	}
}

- (void)setOriginWithX:(CGFloat)x andY:(CGFloat)y {
	if (self.frame.origin.x != x || self.frame.origin.y != y)
		self.frame = CGRectMake(x, y, self.frame.size.width, self.frame.size.height);
}

- (void)setOffsetWithX:(CGFloat)x andY:(CGFloat)y {
	[self setOriginWithX:self.frame.origin.x + x andY:self.frame.origin.y + y];
}

- (void)setOrigin:(CGPoint)origin {
	[self setOriginWithX:origin.x andY:origin.y];
}

- (void)setOffset:(CGPoint)offset {
	[self setOffsetWithX:offset.x andY:offset.y];
}

- (void)setOriginX:(CGFloat)x {
	if (self.frame.origin.x != x)
		self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setOriginY:(CGFloat)y {
	if (self.frame.origin.y != y)
		self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
}

- (void)setSizeWithWidth:(CGFloat)width andHeight:(CGFloat)height {
	if (self.frame.size.width != width || self.frame.size.height != height)
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width < 0 ? self.frame.size.width : width, height < 0 ? self.frame.size.height : height);
}

- (void)setSize:(CGSize)size {
	[self setSizeWithWidth:size.width andHeight:size.height];
}

- (void)setWidth:(CGFloat)width {
	[self setSizeWithWidth:width andHeight:self.frame.size.height];
}

- (void)setHeight:(CGFloat)height {
	[self setSizeWithWidth:self.frame.size.width andHeight:height];
}

- (void)setCenterX:(CGFloat)x {
	if (self.center.x != x)
		self.center = CGPointMake(x, self.center.y);
}

- (void)setCenterY:(CGFloat)y {
	if (self.center.y != y)
		self.center = CGPointMake(self.center.x, y);
}

- (void)offsetByX:(CGFloat)x {
	[self setCenterX:self.center.x + x];
}

- (void)offsetByY:(CGFloat)y {
	[self setCenterY:self.center.y + y];
}

- (CGRect)centerRectWithWidth:(CGFloat)width andHeight:(CGFloat)height {
	return CGRectMake((self.bounds.size.width - width) / 2.0, (self.bounds.size.height - height) / 2.0, width, height);
}

- (CGRect)centerRectWithSize:(CGSize)size {
	return [self centerRectWithWidth:size.width andHeight:size.height];
}

- (CGPoint)boundsCenter {
	return CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
}

- (BOOL)centerSubview:(UIView *)subview {
	if (subview == nil)
		return NO;

	CGRect frame = [self centerRectWithSize:subview.frame.size];
	if (CGRectEqualToRect(subview.frame, frame))
		return NO;

	subview.frame = frame;

	return YES;
}

- (BOOL)centerInSuperview:(UIView *)superview {
	if (superview == nil)
		superview = self.superview;

	if (superview == nil)
		return NO;

	CGRect frame = [superview centerRectWithSize:self.frame.size];
	if (CGRectEqualToRect(self.frame, frame))
		return NO;

	self.frame = frame;

	return YES;
}

- (BOOL)centerInSuperview {
	return [self centerInSuperview:nil];
}

- (void)dock:(UIPosition)position inside:(BOOL)inside margin:(CGFloat)margin view:(UIView *)view {
	CGRect rect = view ? view.frame : self.superview.bounds;

	switch (position) {
		case UIPositionBottom:
			[self setOriginWithX:self.frame.origin.x andY:rect.origin.y + rect.size.height + (inside ? -(self.frame.size.height + margin) : margin)];
			break;
		case UIPositionLeft:
			[self setOriginWithX:rect.origin.x + (inside ? margin : -(self.frame.size.width + margin)) andY:self.frame.origin.y];
			break;
		case UIPositionRight:
			[self setOriginWithX:rect.origin.x + rect.size.width + (inside ? -(self.frame.size.width + margin) : margin) andY:self.frame.origin.y];
			break;
		case UIPositionTop:
			[self setOriginWithX:self.frame.origin.x andY:rect.origin.y + (inside ? margin : -(self.frame.size.height + margin))];
			break;
	}
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

- (void)bringToFront {
	[self.superview bringSubviewToFront:self];
}

@end
