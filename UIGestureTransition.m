//
//  UIGestureTransitionSnapshot:.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 12/09/16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UIGestureTransition.h"

@interface UIGestureTransition ()
@property (strong, nonatomic) UIView *toSnapshot;
@property (strong, nonatomic) UIView *fromSnapshot;
@end

@implementation UIGestureTransition

- (void)setFromSnapshot:(UIView *)fromSnapshot {
	[_fromSnapshot removeFromSuperview];

	[super fromView].hidden = fromSnapshot != Nil;
	if ([super fromView].hidden)
		[self.containerView insertSubview:fromSnapshot aboveSubview:self.fromView];

	_fromSnapshot = fromSnapshot;
}

- (void)setToSnapshot:(UIView *)toSnapshot {
	[_toSnapshot removeFromSuperview];

	[super toView].hidden = toSnapshot != Nil;
	if ([super toView].hidden)
		[self.containerView insertSubview:toSnapshot aboveSubview:self.toView];

	_toSnapshot = toSnapshot;
}

- (UIView *)fromView {
	return self.fromSnapshot ? self.fromSnapshot : [super fromView];
}

- (UIView *)toView {
	return self.toSnapshot ? self.toSnapshot : [super toView];
}

- (void)startInteractiveTransition {
	[super startInteractiveTransition];

	if (self.shouldSnapshotFromView)
		self.fromSnapshot = [self.fromView snapshotViewAfterScreenUpdates:YES];
	if (self.shouldSnapshotToView)
		self.toSnapshot = [self.toView snapshotViewAfterScreenUpdates:YES];
}

- (void)endInteractiveTransition:(BOOL)didComplete {
	self.fromSnapshot = Nil;
	self.toSnapshot = Nil;

	[super endInteractiveTransition:didComplete];

}

@end

#define SCALE 0.9
#define ALPHA 0.4

@interface UIPanTransition ()
@property (strong, nonatomic) UIView *blur;
@end

@implementation UIPanTransition

@synthesize blur = _blur;

- (UIView *)blur {
	if (!_blur) {
		_blur = [[UIView alloc] initWithFrame:self.containerView.bounds];
		_blur.alpha = ALPHA;
		_blur.backgroundColor = [UIColor blackColor];
	}

	return _blur;
}

- (void)setBlur:(UIView *)blur {
	[_blur removeFromSuperview];

	_blur = blur;
}

- (BOOL)shouldSnapshotFromView {
	return YES;
}

- (void)startInteractiveTransition {
	[super startInteractiveTransition];

	if (self.isPresenting) {
		self.toView.frame = CGRectOffsetY(self.toView.frame, self.containerView.bounds.size.height);

		[self.containerView insertSubview:self.blur aboveSubview:self.fromView];
	} else {
		self.toView.transform = CGAffineTransformMakeScale(SCALE, SCALE);

		[self.containerView insertSubview:self.blur belowSubview:self.fromView];
	}
}

- (void)endInteractiveTransition:(BOOL)didComplete {
	[super endInteractiveTransition:didComplete];

	if (self.isPresenting)
		self.toView.frame = self.containerView.bounds;
	else
		self.toView.transform = CGAffineTransformIdentity;

	self.blur = Nil;
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
	if (self.isPresenting)
		percentComplete = 1.0 - percentComplete;

	UIView *panView = self.isPresenting ? self.toView : self.fromView;
	UIView *scaleView = self.isPresenting ? self.fromView : self.toView;

	CGFloat y = self.containerView.bounds.origin.y + self.containerView.bounds.size.height * percentComplete;
	panView.frame = CGRectSetY(panView.frame, y);

	CGFloat scale = SCALE + (1.0 - SCALE) * percentComplete;
	scaleView.transform = CGAffineTransformMakeScale(scale, scale);

	self.blur.alpha = ALPHA - ALPHA * percentComplete;
}

- (CGFloat)interactiveTransitionPercentComplete:(UIGestureRecognizer *)gestureRecognizer {
	UIPanGestureRecognizer *sender = cls(UIPanGestureRecognizer, gestureRecognizer);

	CGPoint transition = [sender translationInView:gestureRecognizer.view];

	return transition.y / self.containerView.bounds.size.height;
}

- (CGFloat)interactiveTransitionPercentVelocity:(UIGestureRecognizer *)gestureRecognizer {
	UIPanGestureRecognizer *sender = cls(UIPanGestureRecognizer, gestureRecognizer);

	CGPoint velocity = [sender velocityInView:gestureRecognizer.view];

	return velocity.y / self.containerView.bounds.size.height;
}

@end
