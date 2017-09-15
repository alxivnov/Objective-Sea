//
//  UIActivityIndicatorView+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UIActivityIndicatorView+Convenience.h"

@implementation UIView (UIActivityIndicatorView)

- (UIView *)startActivityIndication:(UIActivityIndicatorViewStyle)style message:(NSString *)message {
	UIView *blur = [[UIView alloc] initWithFrame:self.bounds];
	blur.alpha = 0.0;
	blur.backgroundColor = style == UIActivityIndicatorViewStyleGray ? [UIColor whiteColor] : [UIColor blackColor];

	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
	indicator.center = blur.center;

	[blur addSubview:indicator];
	[self addSubview:blur];

	[self equalSize:blur];
	[blur equalCenter:indicator];

	if (message.length) {
		UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
		CGSize size = [message sizeWithAttributes:@{ NSFontAttributeName : font }];

		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(blur.bounds.origin.x, indicator.frame.origin.y - indicator.frame.size.height - size.height, blur.bounds.size.width, size.height)];
		label.numberOfLines = 0;
		label.text = message;
		label.textAlignment = NSTextAlignmentCenter;
		label.textColor = style == UIActivityIndicatorViewStyleGray ? [UIColor blackColor] : [UIColor whiteColor];
		label.font = font;
		[blur addSubview:label];

		[blur equalCenter:label constant:CGPointMake(0.0, 0.0 - indicator.frame.size.height - size.height)];
	}

	[UIView animateWithDuration:ANIMATION_DURATION delay:0.0 usingSpringWithDamping:ANIMATION_DAMPING initialSpringVelocity:ANIMATION_VELOCITY options:ANIMATION_OPTIONS animations:^{
		blur.alpha = 0.4;
	} completion:^(BOOL finished) {
		[indicator startAnimating];
	}];

	return blur;
}

- (UIView *)startActivityIndication:(UIActivityIndicatorViewStyle)style {
	return [self startActivityIndication:style message:Nil];
}

- (UIView *)startActivityIndication {
	return [self startActivityIndication:UIActivityIndicatorViewStyleWhiteLarge];
}

- (void)stopActivityIndication:(void (^)(void))completion {
	UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self subview:UISubviewKindOfClass(UIActivityIndicatorView)];
	[indicator stopAnimating];

	[UIView animateWithDuration:ANIMATION_DURATION delay:0.0 usingSpringWithDamping:ANIMATION_DAMPING initialSpringVelocity:ANIMATION_VELOCITY options:ANIMATION_OPTIONS animations:^{
		indicator.superview.alpha = 0.0;
	} completion:^(BOOL finished) {
		[indicator.superview removeFromSuperview];

		if (completion)
			completion();
	}];
}

- (void)stopActivityIndication {
	[self stopActivityIndication:Nil];
}

@end

@implementation UIViewController (UIActivityIndicatorView)

- (UIView *)startActivityIndication:(UIActivityIndicatorViewStyle)style message:(NSString *)message {
	UIViewController *vc = self.containingViewController;

	return [vc.view startActivityIndication:style message:message];
}

- (UIView *)startActivityIndication:(UIActivityIndicatorViewStyle)style {
	return [self startActivityIndication:style message:Nil];
}

- (UIView *)startActivityIndication {
	return [self startActivityIndication:UIActivityIndicatorViewStyleWhiteLarge];
}

- (void)stopActivityIndication:(void (^)(void))completion {
	[self.containingViewController.view stopActivityIndication:completion];
}

- (void)stopActivityIndication {
	[self stopActivityIndication:Nil];
}

@end
