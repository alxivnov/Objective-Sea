//
//  UIView+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UIView+Convenience.h"

@implementation UIView (Helper)

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
