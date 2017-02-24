//
//  UIViewController+Convenience.m
//  Crowd Guard
//
//  Created by Alexander Ivanov on 13.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UIViewController+Convenience.h"

@implementation UIViewController (Convenience)

- (BOOL)iPad {
	return self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular && self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular;
}

- (BOOL)iPhone {
	return !self.iPad;
}

- (UIViewController *)prevViewController {
	if (self.navigationController)
		return self.navigationController;
	if (self.tabBarController)
		return self.tabBarController;
//	if (self.presentingViewController)
//		return self.presentingViewController;

	return Nil;
}

- (UIViewController *)containingViewController {
	UIViewController *vc = self.prevViewController;

	return vc ? vc.containingViewController : self;
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

+ (CGFloat)statusBarHeight {
	UIApplication *application = [[UIApplication class] sharedApplication];
	return application.statusBarHidden ? 0.0 : fminf(application.statusBarFrame.size.height, application.statusBarFrame.size.width);
}

+ (BOOL)inCallingStatusBar {
	return [self statusBarHeight] > GUI_STATUS_BAR_HEIGHT;
}

- (void)presentViewControllerWithIdentifier:(NSString *)viewControllerIdentifier animated:(BOOL)flag completion:(void (^)(UIViewController *))completion {
	if (!viewControllerIdentifier)
		return;

	UIViewController *viewController = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:viewControllerIdentifier];

	if (!viewController)
		return;

	[self presentViewController:viewController animated:flag completion:completion ? ^{
		completion(viewController);
	} : Nil];
}

- (void)performSegueWithIdentifier:(NSString *)identifier {
	[self performSegueWithIdentifier:identifier sender:Nil];
}

@end

@implementation UIViewController (UIPopoverPresentationController)

- (BOOL)popoverViewController:(UIViewController *)vc from:(id)source completion:(void (^)(UIViewController *vc))completion {
	if (!vc)
		return NO;

	if (self.iPad && ([source isKindOfClass:[UIView class]] || [source isKindOfClass:[UIBarButtonItem class]]))
		vc.modalPresentationStyle = UIModalPresentationPopover;

	[self presentViewController:vc animated:YES completion:^{
		if (completion)
			completion(vc);
	}];

	if ([source isKindOfClass:[UIView class]]) {
		vc.popoverPresentationController.sourceView = cls(UIView, source);
		vc.popoverPresentationController.sourceRect = cls(UIView, source).bounds;
	} else if ([source isKindOfClass:[UIBarButtonItem class]]) {
		vc.popoverPresentationController.barButtonItem = cls(UIBarButtonItem, source);
	}

	return YES;
}

- (BOOL)popoverViewController:(UIViewController *)vc from:(id)source {
	return [self popoverViewController:vc from:source completion:Nil];
}

- (BOOL)popoverViewController:(UIViewController *)vc fromView:(UIView *)view {
	return [self popoverViewController:vc from:view];
}

- (BOOL)popoverViewController:(UIViewController *)vc fromButton:(UIBarButtonItem *)button {
	return [self popoverViewController:vc from:button];
}

- (BOOL)popoverViewController:(UIViewController *)vc completion:(void (^)(UIViewController *vc))completion {
	return [self popoverViewController:vc from:Nil completion:completion];
}

- (BOOL)popoverViewController:(UIViewController *)vc {
	return [self popoverViewController:vc from:Nil];
}

- (UIViewController *)popoverViewControllerWithIdentifier:(NSString *)identifier from:(id)source completion:(void (^)(UIViewController *vc))completion {
	if (self.presentedViewController)
		return Nil;

	UIViewController *vc = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:identifier];
	return [self popoverViewController:vc from:source completion:completion] ? vc : Nil;
}

- (UIViewController *)popoverViewControllerWithIdentifier:(NSString *)identifier from:(id)source {
	return [self popoverViewControllerWithIdentifier:identifier from:source completion:Nil];
}

- (UIViewController *)popoverViewControllerWithIdentifier:(NSString *)identifier fromView:(UIView *)view {
	return [self popoverViewControllerWithIdentifier:identifier from:view];
}

- (UIViewController *)popoverViewControllerWithIdentifier:(NSString *)identifier fromButton:(UIBarButtonItem *)button {
	return [self popoverViewControllerWithIdentifier:identifier from:button];
}

- (UIViewController *)popoverViewControllerWithIdentifier:(NSString *)identifier completion:(void (^)(UIViewController *vc))completion {
	return [self popoverViewControllerWithIdentifier:identifier from:Nil completion:completion];
}

- (UIViewController *)popoverViewControllerWithIdentifier:(NSString *)identifier {
	return [self popoverViewControllerWithIdentifier:identifier from:Nil];
}

@end

#define UIMainStoryboardFile @"UIMainStoryboardFile"

@implementation UIStoryboard (Convenience)

+ (UIStoryboard *)mainStoryboard {
	NSString *name = [[NSBundle mainBundle] objectForInfoDictionaryKey:UIMainStoryboardFile];
	if (!name)
		name = @"Main";
	return [UIStoryboard storyboardWithName:name bundle:Nil];
}

@end
