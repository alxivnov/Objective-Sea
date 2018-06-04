//
//  UITableViewCell+Convenience.m
//  Crowd Guard
//
//  Created by Alexander Ivanov on 23.05.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import "UITableViewCell+Convenience.h"

@implementation UITableViewCell (Convenience)

- (void)removeSeparators {
	NSArray<UIView *> *subviews = self.subviews;

	for (UIView *subview in subviews)
		if (subview != self.contentView)
			[subview removeFromSuperview];
}

- (UITableView *)tableView {
	UIView *superview = self.superview;
	while (superview)
		if ([superview isKindOfClass:[UITableView class]])
			return (UITableView *)superview;
		else
			superview = superview.superview;
	return Nil;
}

- (void)setAccessoryView:(UIView *)accessoryView insets:(UIEdgeInsets)insets {
	if (UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero)) {
		CGFloat left = self.imageView.frame.origin.x ?: self.textLabel.frame.origin.x;
		insets = UIEdgeInsetsMake(0.0, left, 0.0, 0.0 - left);
	}

	accessoryView.frame = UIEdgeInsetsInsetRect(accessoryView.frame, insets);
	self.accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, accessoryView.frame.origin.x + accessoryView.frame.size.width, accessoryView.frame.origin.y + accessoryView.frame.size.height)];
	[self.accessoryView addSubview:accessoryView];
}

- (NSArray<UIView *> *)accessoryViews {
	UIStackView *stack = cls(UIStackView, self.accessoryView);
	if (stack)
		return stack.arrangedSubviews;

	return self.accessoryView ? @[ self.accessoryView ] : Nil;
}

- (void)setAccessoryViews:(NSArray<__kindof UIView *> *)accessoryViews {
	if (accessoryViews.count) {
		UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:accessoryViews];
		stack.axis = UILayoutConstraintAxisHorizontal;
		stack.frame = CGRectMake(0.0, 0.0, [accessoryViews sum:^NSNumber *(__kindof UIView *obj) {
			return @(obj.frame.size.width);
		}] + (accessoryViews.count - 1) * 8.0, [accessoryViews max:^NSNumber *(__kindof UIView *obj) {
			return @(obj.frame.size.height);
		}]);
		
		if (@available(iOS 11.0, *))
			stack.spacing = UIStackViewSpacingUseSystem;
		else
			stack.spacing = 8.0;
		self.accessoryView = stack;
	} else {
		self.accessoryView = Nil;
	}
}

- (UILabel *)accessoryLabel {
	UILabel *label = cls(UILabel, self.accessoryView);
	if (!label) {
		label = [[UILabel alloc] init];
		label.backgroundColor = self.textLabel.backgroundColor;
		label.font = [UIFont monospacedDigitSystemFontOfSize:self.textLabel.font.pointSize weight:UIFontWeightRegular];
		label.opaque = self.textLabel.opaque;
		label.textColor = self.textLabel.textColor;
		self.accessoryView = label;
	}
	return label;
}

- (UISwitch *)accessorySwitch {
	UISwitch *view = cls(UISwitch, self.accessoryView);
	if (!view) {
		view = [[UISwitch alloc] init];
		view.backgroundColor = self.textLabel.backgroundColor;
		view.opaque = self.textLabel.opaque;
		self.accessoryView = view;
	}
	return view;
}

@end

@implementation UISwitchTableViewCell

__synthesize(UISwitch *, switchView, [[UISwitch alloc] initWithFrame:CGRectZero])

- (void)setupSwitch {
	if (self.accessoryView)
		return;

	[self.switchView addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];

	self.accessoryView = self.switchView;
}

- (IBAction)switchValueChanged:(UISwitch *)sender {

}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	if (self)
		[self setupSwitch];

	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];

	if (self)
		[self setupSwitch];

	return self;
}

- (void)awakeFromNib  {
	[super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];

	if (selected) {
		[self.switchView setOn:!self.switchView.on animated:YES];

		[self.switchView sendActionsForControlEvents:UIControlEventValueChanged];
	}
}

@end

#if __has_include("UserNotifications+Convenience.h") && __has_include(<UserNotifications/UserNotifications.h>)

@implementation UNTableViewCell

__synthesize(UNAuthorizationOptions, authorizationOptions, UNAuthorizationOptionAll)

- (void)setupSwitch {
	[super setupSwitch];

	[UNUserNotificationCenter getNotificationSettings:^(UNNotificationSettings *settings) {
		[GCD main:^{
			[self.switchView setOn:settings.authorization.boolValue animated:YES];
		}];
	}];
}

- (void)switchValueChanged:(UISwitch *)sender {
	if (sender.on) {
		[UNUserNotificationCenter requestAuthorizationIfNeededWithOptions:self.authorizationOptions completionHandler:^(NSNumber *granted) {
			[GCD main:^{
				[self.switchView setOn:granted.boolValue animated:YES];
			}];
		}];
	} else {
		[self.switchView setOn:YES animated:YES];

//		if (IS_DEBUGGING)
			[UIApplication openSettings];
	}
}

@end

#endif

#if __has_include("UserNotifications+Convenience.h")

@implementation CLTableViewCell

__synthesize(BOOL, requestAlwaysAuthorization, YES)

- (void)setupSwitch {
	[super setupSwitch];

	[self.switchView setOn:[CLLocationManager authorization:self.requestAlwaysAuthorization].boolValue animated:YES];
}

- (void)switchValueChanged:(UISwitch *)sender {
	if (sender.on) {
		[GCD global:^{
			NSNumber *granted = [[CLLocationManager defaultManager] requestAuthorizationIfNeeded:self.requestAlwaysAuthorization];

			[GCD main:^{
//				if (granted.boolValue)
					[self.switchView setOn:granted.boolValue animated:YES];
			}];
		}];
	} else {
		[self.switchView setOn:YES animated:YES];

//		if (IS_DEBUGGING)
			[UIApplication openSettings];
	}
}

@end

#endif

#if __has_include("AVAudioRecorder+Convenience.h")

@implementation AVFTableViewCell

- (void)setupSwitch {
	[super setupSwitch];

	[self.switchView setOn:[AVAudioSession sharedInstance].recordPermissionGranted.boolValue animated:YES];
}

- (void)switchValueChanged:(UISwitch *)sender {
	if (sender.on) {
		[[AVAudioSession sharedInstance] requestRecordPermissionIfNeeded:^(NSNumber *granted) {
			[GCD main:^{
				[self.switchView setOn:granted.boolValue animated:YES];
			}];
		}];
	} else {
		[self.switchView setOn:YES animated:YES];

//		if (IS_DEBUGGING)
			[UIApplication openSettings];
	}
}

@end

#endif
