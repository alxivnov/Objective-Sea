//
//  UIViewController+Transition.h
//  Done!
//
//  Created by Alexander Ivanov on 10.06.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Transition)

- (void)presentViewControllerWithIdentifier:(NSString *)identifier animated:(BOOL)flag completion:(void (^)(void))completion;
- (void)presentViewControllerWithIdentifier:(NSString *)identifier animated:(BOOL)flag;

- (void)presentViewController:(UIViewController *)controller withTransition:(id <UIViewControllerTransitioningDelegate>)delegate andCompletion:(void (^)(void))completion;
- (void)presentViewControllerWithIdentifier:(NSString *)identifier withTransition:(id <UIViewControllerTransitioningDelegate>)delegate andCompletion:(void (^)(void))completion;

- (void)presentViewController:(UIViewController *)controller withTransition:(id <UIViewControllerTransitioningDelegate>)delegate;
- (void)presentViewControllerWithIdentifier:(NSString *)identifier withTransition:(id <UIViewControllerTransitioningDelegate>)delegate;

- (void)dismissViewControllerWithTransition:(id <UIViewControllerTransitioningDelegate>)delegate  andCompletion:(void (^)(void))completion;
- (void)dismissViewControllerWithTransition:(id <UIViewControllerTransitioningDelegate>)delegate;

@end
