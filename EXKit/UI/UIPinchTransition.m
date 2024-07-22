//
//  UIPinchTransition.m
//  Done!
//
//  Created by Alexander Ivanov on 08.06.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "CoreGraphics+Convenience.h"
#import "NSObject+Convenience.h"
#import "UIColor+Convenience.h"
#import "UIView+Convenience.h"
#import "UIPinchTransition.h"
#import "UIView+Convenience.h"

#define TRANSFORM_LARGE 3.00
#define TRANSFORM_SMALL 0.33

typedef NS_OPTIONS(NSUInteger, PinchDirection) {
    PinchIn = 1 << 0,
    PinchOut = 1 << 1,
};

@interface UIPinchTransition ()
@property (assign, nonatomic) PinchDirection direction;

@property (strong, nonatomic) UIView *from;
@property (strong, nonatomic) UIView *to;

@property (assign, nonatomic) CGFloat fromAlpha;
@property (assign, nonatomic) CGAffineTransform fromTransform;
@property (strong, nonatomic) UIColor *toColor;

@property (assign, nonatomic) CGFloat toAlpha;
@property (assign, nonatomic) CGAffineTransform toTransform;
@property (strong, nonatomic) UIColor *fromColor;

@end

@implementation UIPinchTransition

- (CGFloat)animationVelocity {
	return 0.4;
}

- (CGFloat)animationDamping {
	return 0.6;
}

- (UIView *)originalContentView {
	return Nil;
}

- (void)startGestureTransition {
	UIViewController *fromVC = self.fromViewController;
	UIViewController *toVC = self.toViewController;
	UIView *container = self.containerView;

//	if ([CGHelper orientationForRect:fromVC.view.frame] != [CGHelper orientationForRect:toVC.view.frame]) {
//		CGRect frame = toVC.view.frame;
//		toVC.view.bounds = [CGHelper rotateRect:toVC.view.bounds];
//		toVC.view.frame = [CGHelper rotateRect:frame];
//	}
	
//	if (VER(8, 0)) {
		self.from = [fromVC.view snapshotView];
		self.to = [toVC.view snapshotView];
/*	} else {
		self.from = [fromVC snapshotView];
		self.to = [toVC snapshotView];
	}
*/
	self.fromAlpha = self.from.alpha;
	self.fromTransform = self.from.transform;
	UIView *fromView = [fromVC respondsToSelector:@selector(originalContentView)] ? [fromVC performSelector:@selector(originalContentView)] : fromVC.view;
	self.fromColor = fromView.backgroundColor;
	self.toAlpha = self.to.alpha;
	self.toTransform = self.to.transform;
	self.toColor = toVC.view.backgroundColor;
	
	CGAffineTransform transform;
	if (self.direction == PinchIn) {
		[container addSubview:self.from];
		[container addSubview:self.to];
		
		transform = CGAffineTransformMakeScale(TRANSFORM_LARGE, TRANSFORM_LARGE);
	} else {
		[container addSubview:self.to];
		[container addSubview:self.from];
		
		transform = CGAffineTransformMakeScale(TRANSFORM_SMALL, TRANSFORM_SMALL);
	}
	
	self.to.alpha = 0;
	self.to.transform = CGAffineTransformConcat(self.to.transform, transform);
	
	container.backgroundColor = self.fromColor;
	
	fromVC.view.hidden = YES;
	toVC.view.hidden = YES;
}

- (void)updateGestureTransition:(CGFloat)percentComplete {
	UIView *container = [self.context containerView];
	
	CGFloat f = 1.0 + ((self.direction == PinchIn ? TRANSFORM_SMALL : TRANSFORM_LARGE) - 1.0) * percentComplete;
	CGFloat t = (self.direction == PinchIn ? TRANSFORM_LARGE : TRANSFORM_SMALL) - ((self.direction == PinchIn ? TRANSFORM_LARGE : TRANSFORM_SMALL) - 1.0) * percentComplete;
	
	self.from.alpha = self.fromAlpha * (1 - percentComplete);
	self.from.transform = CGAffineTransformConcat(self.fromTransform, CGAffineTransformMakeScale(f, f));
	
	self.to.alpha = self.toAlpha * percentComplete;
	self.to.transform = CGAffineTransformConcat(self.toTransform, CGAffineTransformMakeScale(t, t));
	
	container.backgroundColor = [self.fromColor mixWithColor:self.toColor value:percentComplete];
}

- (void)endGestureTransition:(BOOL)didComplete {
	UIViewController *fromVC = [self.context viewControllerForKey:UITransitionContextFromViewControllerKey];
	UIViewController *toVC = [self.context viewControllerForKey:UITransitionContextToViewControllerKey];
	UIView *container = [self.context containerView];

	if (didComplete) {
		[fromVC.view removeFromSuperview];
		[container addSubview:toVC.view];
	}

	fromVC.view.hidden = NO;
	toVC.view.hidden = NO;

	if (toVC.transitioningDelegate == self)
		toVC.transitioningDelegate = Nil;

	if (fromVC.transitioningDelegate == self)
		fromVC.transitioningDelegate = Nil;


	[self.from removeFromSuperview];
	[self.to removeFromSuperview];

	self.from = Nil;
	self.to = Nil;

	self.fromColor = Nil;
	self.toColor = Nil;
}

- (CGFloat)gestureTransitionPercentComplete:(UIPinchGestureRecognizer *)gestureRecognizer {
	UIPinchGestureRecognizer *sender = cls(UIPinchGestureRecognizer, gestureRecognizer);

	return self.direction == PinchIn ? 1.0 - sender.scale : (sender.scale - 1.0) / 2.0;
}

+ (instancetype)animatedPinchIn:(NSTimeInterval)duration {
	UIPinchTransition *instance = [[self alloc] initWithDuration:duration];
	instance.direction = PinchIn;
	return instance;
}

+ (instancetype)animatedPinchOut:(NSTimeInterval)duration {
	UIPinchTransition *instance = [[self alloc] initWithDuration:duration];
	instance.direction = PinchOut;
	return instance;
}

+ (instancetype)interactiveTransitionWithDirection:(PinchDirection)direction delegate:(id <UIInteractiveTransitionDelegate>)delegate recognizer:(UIGestureRecognizer *)recognizer {
//	if (![delegate respondsToSelector:@selector(transitionGestureRecognizer:)])
//		return Nil;
	
//	UIPinchGestureRecognizer *gesture = cls(UIPinchGestureRecognizer, [delegate transitionGestureRecognizer:Nil]);
//	if (!gesture)
//		return Nil;

	UIPinchTransition *instance = [self gestureTransition:recognizer];
	instance.direction = direction;
	instance.delegate = delegate;
	return instance;
}

+ (instancetype)interactivePinchIn:(id <UIInteractiveTransitionDelegate>)delegate recognizer:(UIGestureRecognizer *)recognizer {
	return [self interactiveTransitionWithDirection:PinchIn delegate:delegate recognizer:recognizer];
}

+ (instancetype)interactivePinchOut:(id <UIInteractiveTransitionDelegate>)delegate recognizer:(UIGestureRecognizer *)recognizer {
	return [self interactiveTransitionWithDirection:PinchOut delegate:delegate recognizer:recognizer];
}

@end
