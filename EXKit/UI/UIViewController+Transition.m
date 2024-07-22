//
//  UIViewController+Transition.m
//  Done!
//
//  Created by Alexander Ivanov on 10.06.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "UIView+Convenience.h"
#import "UIViewController+Transition.h"

@implementation UIViewController (Transition)

- (void)presentViewControllerWithIdentifier:(NSString *)identifier animated:(BOOL)flag completion:(void (^)(void))completion {
	UIViewController *controller = [[self storyboard] instantiateViewControllerWithIdentifier:identifier];
	[self presentViewController:controller animated:flag completion:completion];
}

- (void)presentViewControllerWithIdentifier:(NSString *)identifier animated:(BOOL)flag {
	[self presentViewControllerWithIdentifier:identifier animated:flag completion:Nil];
}

- (void)presentViewController:(UIViewController *)controller withTransition:(id <UIViewControllerTransitioningDelegate>)delegate andCompletion:(void (^)(void))completion {
	if (!VER(8, 0))
		controller.modalPresentationStyle = UIModalPresentationCustom;
	controller.transitioningDelegate = delegate;
	
	[self presentViewController:controller animated:YES completion:completion];
}

- (void)presentViewControllerWithIdentifier:(NSString *)identifier withTransition:(id <UIViewControllerTransitioningDelegate>)delegate andCompletion:(void (^)(void))completion {
	
	UIViewController *controller = [[self storyboard] instantiateViewControllerWithIdentifier:identifier];
	[self presentViewController:controller withTransition:delegate andCompletion:completion];
}

- (void)presentViewController:(UIViewController *)controller withTransition:(id <UIViewControllerTransitioningDelegate>)delegate {
	[self presentViewController:controller withTransition:delegate andCompletion:Nil];
}

- (void)presentViewControllerWithIdentifier:(NSString *)identifier withTransition:(id <UIViewControllerTransitioningDelegate>)delegate {
	[self presentViewControllerWithIdentifier:identifier withTransition:delegate andCompletion:Nil];
}

- (void)dismissViewControllerWithTransition:(id <UIViewControllerTransitioningDelegate>)delegate  andCompletion:(void (^)(void))completion {
//	self.modalPresentationStyle = UIModalPresentationCustom;
	if (self.presentedViewController)
		self.presentedViewController.transitioningDelegate = delegate;
	else
		self.transitioningDelegate = delegate;
	
	[self dismissViewControllerAnimated:YES completion:completion];
}

- (void)dismissViewControllerWithTransition:(id <UIViewControllerTransitioningDelegate>)delegate {
	[self dismissViewControllerWithTransition:delegate andCompletion:Nil];
}

@end
