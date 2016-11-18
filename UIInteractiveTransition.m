//
//  UIInteractiveTransition.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 29/08/16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UIInteractiveTransition.h"

@interface UIInteractiveTransition ()
@property (assign, nonatomic) NSTimeInterval duration;

@property (strong, nonatomic) id <UIViewControllerContextTransitioning> context;
@end

@implementation UIInteractiveTransition

- (instancetype)initWithDuration:(NSTimeInterval)duration {
	self = [super init];

	if (self)
		self.duration = duration;

	return self;
}

__synthesize(UIView *, containerView, [self.context containerView])
__synthesize(UIView *, fromView, [self.context viewForKey:UITransitionContextFromViewKey])
__synthesize(UIView *, toView, [self.context viewForKey:UITransitionContextToViewKey])
__synthesize(UIViewController *, fromViewController, [self.context viewControllerForKey:UITransitionContextFromViewControllerKey])
__synthesize(UIViewController *, toViewController, [self.context viewControllerForKey:UITransitionContextToViewControllerKey])

- (void)setContext:(id<UIViewControllerContextTransitioning>)context {
	_context = context;

	_containerView = Nil;
	_fromView = Nil;
	_toView = Nil;
	_fromViewController = Nil;
	_toViewController = Nil;
}

- (BOOL)isPresenting {
	return self.fromViewController.presentedViewController == self.toViewController;
}

- (BOOL)isDismissing {
	return self.toViewController.presentedViewController == self.fromViewController;
}

// UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
	return self.duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
	[self startInteractiveTransition:transitionContext];
}

// UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
	return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
	return self;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
	id <UIViewControllerInteractiveTransitioning> interaction = self.duration > 0.0 ? Nil : self;

	return interaction;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
	id <UIViewControllerInteractiveTransitioning> interaction = self.duration > 0.0 ? Nil : self;

	return interaction;
}

// UIViewControllerInteractiveTransitioning

- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
	self.context = transitionContext;

	if (CGRectIsHorizontal(self.fromView.frame) != CGRectIsHorizontal(self.toView.frame) || CGRectIsVertical(self.fromView.frame) != CGRectIsVertical(self.toView.frame))
		self.toView.frame = CGRectRotate(self.toView.frame);

	[self startInteractiveTransition];

	if (self.duration > 0.0)
		[self finishInteractiveTransition:self.duration];
	else if (self.duration < 0.0)
		[self cancelInteractiveTransition:-self.duration];
}

- (void)finishInteractiveTransition:(NSTimeInterval)duration {
/*	if (!self.context) {
		self.duration = 0.20;
		return;
	}
*/
	[UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:[self animationDamping] initialSpringVelocity:[self animationVelocity] options:[self animationOptions] animations:^{
		[self updateInteractiveTransition:1.0];
	} completion:^(BOOL finished) {
		[self endInteractiveTransition:YES];

		[self.context finishInteractiveTransition];
		[self.context completeTransition:YES];
		self.context = Nil;
	}];

	if ([self.delegate respondsToSelector:@selector(transitionWillFinish:)])
		[self.delegate transitionWillFinish:self];
}

- (void)cancelInteractiveTransition:(NSTimeInterval)duration {
/*	if (!self.context) {
		self.duration = -0.20;
		return;
	}
*/
	[UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:[self animationDamping] initialSpringVelocity:[self animationVelocity] options:[self animationOptions] animations:^{
		[self updateInteractiveTransition:0.0];
	} completion:^(BOOL finished) {
		[self endInteractiveTransition:NO];

		[self.context finishInteractiveTransition];
		[self.context completeTransition:NO];
		self.context = Nil;
	}];

	if ([self.delegate respondsToSelector:@selector(transitionWillCancel:)])
		[self.delegate transitionWillCancel:self];
}

- (CGFloat)animationVelocity {
	return ANIMATION_VELOCITY;
}

- (CGFloat)animationDamping {
	return ANIMATION_DAMPING;
}

- (UIViewAnimationOptions)animationOptions {
	return ANIMATION_OPTIONS;
}

- (void)startInteractiveTransition {
	if (self.isPresenting)
		[self.containerView insertSubview:self.toView aboveSubview:self.fromView];
	else
		[self.containerView insertSubview:self.toView belowSubview:self.fromView];
}

- (void)endInteractiveTransition:(BOOL)didComplete {
	if (!didComplete)
		[self.toView removeFromSuperview];
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
	// abstract required
}

- (CGFloat)interactiveTransitionPercentComplete:(UIGestureRecognizer *)gestureRecognizer {
	return 0.0; // abstract required
}

- (CGFloat)interactiveTransitionPercentVelocity:(UIGestureRecognizer *)gestureRecognizer {
	return 0.0; // abstract required
}

@end

@implementation UIInteractiveTransition (UIGestureRecognizer)

- (void)gestureTransitionAction:(UIGestureRecognizer *)sender {
	if (sender.state == UIGestureRecognizerStateBegan)
		return;

	CGFloat percentComplete = [self interactiveTransitionPercentComplete:sender];

	if (percentComplete < 0.0) {
//		[sender removeTarget:self action:@selector(gestureTransitionAction:)];

		[self cancelInteractiveTransition:0.0];
	} else if (sender.state == UIGestureRecognizerStateChanged) {
		[self updateInteractiveTransition:percentComplete];

		[self.context updateInteractiveTransition:percentComplete];
	} else if (sender.state == UIGestureRecognizerStateEnded) {
//		[sender removeTarget:self action:@selector(gestureTransitionAction:)];

		if (percentComplete > 0.5 || percentComplete + [self interactiveTransitionPercentVelocity:sender] > 1.0)
			[self finishInteractiveTransition:1.0 - percentComplete];
		else
			[self cancelInteractiveTransition:percentComplete];
	} else /*if (sender.state == UIGestureRecognizerStateCancelled)*/ {
//		[sender removeTarget:self action:@selector(gestureTransitionAction:)];

		[self cancelInteractiveTransition:0];
	}
}

+ (instancetype)gestureTransition:(UIGestureRecognizer *)gestureRecognizer {
//	if (!gestureRecognizer)
//		return Nil;

	UIInteractiveTransition *instance = [[self alloc] initWithDuration:gestureRecognizer.state == UIGestureRecognizerStateBegan ? 0.0 : ANIMATION_DURATION];

	[gestureRecognizer addTarget:instance action:@selector(gestureTransitionAction:)];

	return instance;
}

@end
