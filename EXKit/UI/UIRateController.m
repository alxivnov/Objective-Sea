//
//  UIReviewController.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 08/09/16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UIRateController.h"

#import "UIButton+Convenience.h"

@interface UIRateView ()
@property (assign, nonatomic, readonly) CGRect labelFrame;
@property (assign, nonatomic, readonly) CGRect leftButtonFrame;
@property (assign, nonatomic, readonly) CGRect rightButtonFrame;
@end

@implementation UIRateView

- (CGRect)labelFrame {
	CGFloat x = self.bounds.size.height / 8.0;
	CGFloat y = self.bounds.size.height / 2.0;
	if (y > 44.0 + x)
		y = self.bounds.size.height - (44.0 + x);

	return CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, y);
}

- (CGRect)leftButtonFrame {
	CGFloat x = self.bounds.size.height / 8.0;
	CGFloat y = self.bounds.size.height / 2.0;
	CGFloat height = self.bounds.size.height / 4.0 + x;
	if (y > 44.0 + x) {
		y = self.bounds.size.height - (44.0 + x);
		height = 44.0;
	}

	return CGRectMake(self.bounds.origin.x + x, self.bounds.origin.y + y, self.bounds.size.width / 2.0 - 1.5 * x, height);
}

- (CGRect)rightButtonFrame {
	CGFloat x = self.bounds.size.height / 8.0;
	CGFloat y = self.bounds.size.height / 2.0;
	CGFloat height = self.bounds.size.height / 4.0 + x;
	if (y > 44.0 + x) {
		y = self.bounds.size.height - (44.0 + x);
		height = 44.0;
	}

	return CGRectMake(self.bounds.origin.x + self.bounds.size.width / 2.0 + 0.5 * x, self.bounds.origin.y + y, self.bounds.size.width / 2.0 - 1.5 * x, height);
}

@synthesize label = _label;
@synthesize leftButton = _leftButton;
@synthesize rightButton = _rightButton;

- (UILabel *)label {
	if (!_label) {
		_label = [[UILabel alloc] initWithFrame:self.labelFrame];
		_label.text = NSLocalizedString(@"Enjoing this app?", Nil);
		_label.textAlignment = NSTextAlignmentCenter;
		_label.textColor = self.tintColor;

		[self addSubview:_label];
	}

	return _label;
}

- (UIButton *)leftButton {
	if (!_leftButton) {
		_leftButton = [[UIBorderButton alloc] initWithFrame:self.leftButtonFrame];
		[_leftButton setTitle:NSLocalizedString(@"NO", Nil) forState:UIControlStateNormal];

		[self addSubview:_leftButton];
	}

	return _leftButton;
}

- (UIButton *)rightButton {
	if (!_rightButton) {
		_rightButton = [[UIBorderButton alloc] initWithFrame:self.rightButtonFrame];
//		_rightButton.backgroundColor = self.tintColor;
		[_rightButton setTitle:NSLocalizedString(@"YES", Nil) forState:UIControlStateNormal];

		[self addSubview:_rightButton];
	}

	return _rightButton;
}

- (void)setTintColor:(UIColor *)tintColor {
	[super setTintColor:tintColor];

	self.label.textColor = tintColor;
	self.leftButton.tintColor = tintColor;
	self.rightButton.tintColor = tintColor;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	if (self) {
		self.label.frame = self.labelFrame;
		self.leftButton.frame = self.leftButtonFrame;
		self.rightButton.frame = self.rightButtonFrame;
	}

	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];

	self.label.frame = self.labelFrame;
	self.leftButton.frame = self.leftButtonFrame;
	self.rightButton.frame = self.rightButtonFrame;
}

@end

@interface UIRateController ()
@property (strong, nonatomic, readonly) UIRateView *rateView;
@end

@implementation UIRateController

@synthesize rateView = _rateView;

- (UIRateView *)rateView {
	if (!_rateView) {
		_rateView = [UIRateView new];

		[_rateView.leftButton addTarget:self action:@selector(leftButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
		[_rateView.rightButton addTarget:self action:@selector(rightButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
	}

	return _rateView;
}

- (IBAction)leftButtonTouchUpInside:(id)sender {
	NSRateController *sk = [NSRateController instance];

	switch (sk.state) {
		case NSRateControllerStateLikeNo:		// MAIL-NO
			sk.state = NSRateControllerStateMailNo;
			break;
		case NSRateControllerStateLikeYes:	// RATE-NO
			sk.state = NSRateControllerStateRateNo;
			break;
		default:								// LIKE-NO
			sk.state = NSRateControllerStateLikeNo;
			break;
	}

	[self setup];

	if (self.buttonAction)
		self.buttonAction(sk.state);
}

- (IBAction)rightButtonTouchUpInside:(id)sender {
	NSRateController *sk = [NSRateController instance];

	switch (sk.state) {
		case NSRateControllerStateLikeNo:		// MAIL-YES
			[[UIApplication sharedApplication].rootViewController presentMailComposeWithRecipient:sk.recipient subject:[NSBundle bundleDisplayNameAndShortVersion]];
			sk.state = NSRateControllerStateMailYes;
			break;
		case NSRateControllerStateLikeYes:	// RATE-YES
			[UIApplication openURL:[NSURL URLForMobileAppWithIdentifier:sk.appIdentifier affiliateInfo:[NSRateController instance].affiliateInfo]];
			sk.state = NSRateControllerStateRateYes;
			break;
		default:								// LIKE-YES
			sk.state = NSRateControllerStateLikeYes;
			break;
	}

	[self setup];

	if (self.buttonAction)
		self.buttonAction(sk.state);
}

- (void)setup {
	NSRateController *sk = [NSRateController instance];

	switch (sk.state) {
		case NSRateControllerStateInit:
			self.rateView.label.text = NSLocalizedString(@"Enjoying this app?", Nil);
			[self.rateView.leftButton setTitle:NSLocalizedString(@"Not really", Nil) forState:UIControlStateNormal];
			[self.rateView.rightButton setTitle:NSLocalizedString(@"Yes!", Nil) forState:UIControlStateNormal];
			self.rateView.hidden = NO;
			break;
		case NSRateControllerStateLikeNo:
			self.rateView.label.text = NSLocalizedString(@"Would you mind giving me some feedback?", Nil);
			[self.rateView.leftButton setTitle:NSLocalizedString(@"No, thanks", Nil) forState:UIControlStateNormal];
			[self.rateView.rightButton setTitle:NSLocalizedString(@"Ok, sure", Nil) forState:UIControlStateNormal];
			self.rateView.hidden = NO;
			break;
		case NSRateControllerStateLikeYes:
			self.rateView.label.text = NSLocalizedString(@"How about rating on the App Store, then?", Nil);
			[self.rateView.leftButton setTitle:NSLocalizedString(@"No, thanks", Nil) forState:UIControlStateNormal];
			[self.rateView.rightButton setTitle:NSLocalizedString(@"Ok, sure", Nil) forState:UIControlStateNormal];
			self.rateView.hidden = NO;
			break;
		default:
			self.rateView.hidden = YES;
			break;
	}
}

- (instancetype)init {
	self = [super init];

	if (self)
		[self setup];

	return self;
}

- (UIView *)view {
	return self.rateView.hidden ? Nil : self.rateView;
}

__static(UIRateController *, instance, [self new])

@end
