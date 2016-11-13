//
//  UIViewController+Convenience.m
//  Crowd Guard
//
//  Created by Alexander Ivanov on 13.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UIViewController+Convenience.h"

@implementation UIViewController (Convenience)

- (__kindof UIViewController *)nextViewController {
	if ([self isKindOfClass:[UINavigationController class]])
		return ((UINavigationController *)self).topViewController;
	if ([self isKindOfClass:[UITabBarController class]])
		return ((UITabBarController *)self).selectedViewController;
	if (self.presentedViewController)
		return self.presentedViewController;
//	if ([self isKindOfClass:[UIPageViewController class]])
//		return ((UIPageViewController *)self).viewControllers.firstObject;
	return Nil;
}

@end
