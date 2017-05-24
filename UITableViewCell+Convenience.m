//
//  UITableViewCell+Convenience.m
//  Crowd Guard
//
//  Created by Alexander Ivanov on 23.05.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import "UITableViewCell+Convenience.h"

@implementation UITableViewCell (Convenience)

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

@end

@interface UISwitchTableViewCell ()
@property (strong, nonatomic) UIImage *onImage;
@property (strong, nonatomic) UIImage *offImage;
@end

@implementation UISwitchTableViewCell

__synthesize(UISwitch *, switchView, [[UISwitch alloc] initWithFrame:CGRectZero])

- (void)setupSwitch {
	[self.switchView addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];

	self.accessoryView = self.switchView;
}

- (void)setupImage {
	UIImage *image = self.switchView.on ? self.onImage : self.offImage;
	if (image)
		self.imageView.image = image;

	NSLog(@"image: %@", self.imageView.image);
}

- (IBAction)switchValueChanged:(UISwitch *)sender {
	[self setupImage];
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

@end

#if __has_include("UserNotifications+Convenience.h")

@implementation UNTableViewCell

__synthesize(UNAuthorizationOptions, authorizationOptions, UNAuthorizationOptionAll)

- (void)setOn:(BOOL)on animated:(BOOL)animated {
	[self.switchView setOn:on animated:animated];

	[self setupImage];
}

- (void)setupSwitch {
	[super setupSwitch];

	self.onImage = [[UIImage imageNamed:@"user-notifications-on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	self.offImage = [[UIImage imageNamed:@"user-notifications-off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

	[UNUserNotificationCenter getNotificationSettings:^(UNNotificationSettings *settings) {
		[GCD main:^{
			[self setOn:settings.authorization.boolValue animated:YES];
		}];
	}];
}

- (void)switchValueChanged:(UISwitch *)sender {
	if (sender.on) {
		[UNUserNotificationCenter requestAuthorizationIfNeededWithOptions:self.authorizationOptions completionHandler:^(NSNumber *granted) {
			[GCD main:^{
				[self setOn:granted.boolValue animated:YES];
			}];
		}];
	} else {
		[self setOn:YES animated:YES];
	}
}

@end

#endif

#if __has_include("UserNotifications+Convenience.h")

@implementation CLTableViewCell

__synthesize(BOOL, requestAlwaysAuthorization, NO)

- (void)setOn:(BOOL)on animated:(BOOL)animated {
	[self.switchView setOn:on animated:animated];

	[self setupImage];
}

- (void)setupSwitch {
	[super setupSwitch];

	self.onImage = [[UIImage imageNamed:@"core-location-on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	self.offImage = [[UIImage imageNamed:@"core-location-off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

	[self setOn:[CLLocationManager authorization:self.requestAlwaysAuthorization].boolValue animated:YES];
}

- (void)switchValueChanged:(UISwitch *)sender {
	if (sender.on) {
		[self setOn:[[CLLocationManager defaultManager] requestAuthorizationIfNeeded:self.requestAlwaysAuthorization].boolValue animated:YES];
	} else {
		[self setOn:YES animated:YES];
	}
}

@end

#endif
