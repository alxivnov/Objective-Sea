//
//  UIInteractiveTransition.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 29/08/16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

@import UIKit;

#import "CoreGraphics+Convenience.h"
#import "NSObject+Convenience.h"
#import "UIView+Convenience.h"

@class UIInteractiveTransition;

@protocol UIInteractiveTransitionDelegate <NSObject>

@optional

- (void)transitionWillFinish:(UIInteractiveTransition *)sender;
- (void)transitionWillCancel:(UIInteractiveTransition *)sender;

@end

@interface UIInteractiveTransition : NSObject <UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) id <UIInteractiveTransitionDelegate> delegate;

@property (assign, nonatomic, readonly) NSTimeInterval duration;

- (instancetype)initWithDuration:(NSTimeInterval)duration;

@property (strong, nonatomic, readonly) id <UIViewControllerContextTransitioning> context;
@property (strong, nonatomic, readonly) UIViewController *fromViewController;
@property (strong, nonatomic, readonly) UIViewController *toViewController;
@property (strong, nonatomic, readonly) UIView *fromView;
@property (strong, nonatomic, readonly) UIView *toView;
@property (strong, nonatomic, readonly) UIView *containerView;

@property (assign, nonatomic, readonly) BOOL isPresenting;
@property (assign, nonatomic, readonly) BOOL isDismissing;

- (CGFloat)animationVelocity;																	// abstract optional
- (CGFloat)animationDamping;																	// abstract optional
- (UIViewAnimationOptions)animationOptions;														// abstract optional

- (void)startInteractiveTransition;																// abstract optional
- (void)endInteractiveTransition:(BOOL)didComplete;												// abstract optional

- (void)updateInteractiveTransition:(CGFloat)percentComplete;									// abstract required
- (CGFloat)interactiveTransitionPercentComplete:(UIGestureRecognizer *)gestureRecognizer;		// abstract required
- (CGFloat)interactiveTransitionPercentVelocity:(UIGestureRecognizer *)gestureRecognizer;		// abstract required

@end

@interface UIInteractiveTransition (UIGestureRecognizer)

+ (instancetype)gestureTransition:(UIGestureRecognizer *)gestureRecognizer;

@end
