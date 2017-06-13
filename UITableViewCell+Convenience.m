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

@implementation UISwitchTableViewCell

__synthesize(UISwitch *, switchView, [[UISwitch alloc] initWithFrame:CGRectZero])

- (void)setupSwitch {
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

#if __has_include("UserNotifications+Convenience.h")

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

		if (IS_DEBUGGING)
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
		[self.switchView setOn:[[CLLocationManager defaultManager] requestAuthorizationIfNeeded:self.requestAlwaysAuthorization].boolValue animated:YES];
	} else {
		[self.switchView setOn:YES animated:YES];

		if (IS_DEBUGGING)
			[UIApplication openSettings];
	}
}

@end

#endif

#if __has_include("AVAudioRecorder+Convenience.h")

@implementation AVFTableViewCell

__synthesize(AVAudioSession *, audioSession, [AVAudioSession sharedInstance])

- (void)setupSwitch {
	[super setupSwitch];

	[self.switchView setOn:self.audioSession.recordPermissionGranted.boolValue animated:YES];
}

- (void)switchValueChanged:(UISwitch *)sender {
	if (sender.on) {
		[self.audioSession requestRecordPermissionIfNeeded:^(NSNumber *granted) {
			[GCD main:^{
				[self.switchView setOn:granted.boolValue animated:YES];
			}];
		}];
	} else {
		[self.switchView setOn:YES animated:YES];

		if (IS_DEBUGGING)
			[UIApplication openSettings];
	}
}

@end

#endif