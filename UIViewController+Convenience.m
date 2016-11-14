//
//  UIViewController+Convenience.m
//  Crowd Guard
//
//  Created by Alexander Ivanov on 13.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UIViewController+Convenience.h"

@implementation UIViewController (Convenience)

- (UIViewController *)previousViewController {
	if (self.navigationController)
		return self.navigationController;
	if (self.tabBarController)
		return self.tabBarController;
	if (self.presentingViewController)
		return self.presentingViewController;

	return Nil;
}

- (UIViewController *)firstViewController {
	UIViewController *vc = self.previousViewController;

	return vc ? vc.firstViewController : self;
}

- (UIViewController *)nextViewController {
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

- (UIViewController *)lastViewController {
	UIViewController *vc = self.nextViewController;

	return vc ? vc.lastViewController : self;
}

- (UIViewController *)presentRootViewControllerAnimated:(BOOL)animated {
	if ([self isKindOfClass:[UINavigationController class]]) {
		UINavigationController *nav = (UINavigationController *)self;

		[nav popToRootViewControllerAnimated:animated];

		return [nav.topViewController presentRootViewControllerAnimated:animated];
	} else if ([self isKindOfClass:[UITabBarController class]]) {
		UITabBarController *tab = (UITabBarController *)self;

		[tab setSelectedIndex:0];

		return [tab.selectedViewController presentRootViewControllerAnimated:animated];
	} else {
		[self dismissViewControllerAnimated:animated completion:Nil];

		return self;
	}
}

- (UIViewController *)presentRootViewController {
	return [self presentRootViewControllerAnimated:NO];
}

- (void)setToolbar {
	self.navigationController.toolbarHidden = !self.toolbarItems.count;
}

- (void)setToolbar:(NSArray<UIBarButtonItem *> *)toolbarItems animated:(BOOL)animated {
	[self setToolbarItems:toolbarItems animated:animated];

	[self setToolbar];
}

- (void)setToolbar:(NSArray<UIBarButtonItem *> *)toolbarItems {
	[self setToolbar:toolbarItems animated:NO];
}

@end
