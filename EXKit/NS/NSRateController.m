//
//  SKReviewController.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 08/09/16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "NSRateController.h"

@interface NSRateController ()
@property (assign, nonatomic) NSUInteger launch;
@property (assign, nonatomic) NSUInteger action;

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *bundleVersion;
@end

@implementation NSRateController

- (void)setLaunch:(NSUInteger)launch {
	if (_launch == launch)
		return;

	_launch = launch;
	[[NSUserDefaults standardUserDefaults] setObject:@(launch) forKey:@"UIRateControllerLaunch"];
}

- (void)setAction:(NSUInteger)action {
	if (_action == action)
		return;

	_action = action;
	[[NSUserDefaults standardUserDefaults] setObject:@(action) forKey:@"UIRateControllerAction"];
}

- (NSUInteger)incrementAction {
	self.action++;

	return self.action;
}



- (void)setDate:(NSDate *)date {
	if ([_date isEqualToDate:date])
		return;

	_date = date;
	[[NSUserDefaults standardUserDefaults] setObject:date forKey:@"UIRateControllerDate"];
}

- (void)setBundleVersion:(NSString *)bundleVersion {
	if ([_bundleVersion isEqualToString:bundleVersion])
		return;

	_bundleVersion = bundleVersion;
	[[NSUserDefaults standardUserDefaults] setObject:bundleVersion forKey:@"UIRateControllerVersion"];
}



- (void)setState:(NSRateControllerState)state {
	if (_state == state)
		return;

	_state = state;
	[[NSUserDefaults standardUserDefaults] setObject:@(state) forKey:@"UIRateControllerState"];

	self.launch = 0;
	self.action = 0;
	self.date = [NSDate date];
	self.bundleVersion = [NSBundle bundleVersion];
}



- (instancetype)init {
	self = [super init];

	if (self) {
		_launch = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UIRateControllerLaunch"] integerValue];
		_action = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UIRateControllerAction"] integerValue];
		_bundleVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"UIRateControllerVersion"];
		_date = [[NSUserDefaults standardUserDefaults] objectForKey:@"UIRateControllerDate"];
		_state = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UIRateControllerState"] integerValue];

//		NSLog(@"defaults: %@", @{ @"UIRateControllerLaunch" : @(_launch), @"UIRateControllerAction" : @(_action), @"UIRateControllerVersion" : _bundleVersion, @"UIRateControllerDate" : _date, @"UIRateControllerState" : @(_state) });

		self.launch++;

		if (!_bundleVersion)
			self.bundleVersion = [NSBundle bundleVersion];
		if (!_date)
			self.date = [NSDate date];

		switch (_state) {
			case NSRateControllerStateNone:
				if ([[self.date addValue:5 forComponent:NSCalendarUnitDay] isPast] && self.launch >= 5 && self.action >= 5)
					self.state = NSRateControllerStateInit;
				break;
			case NSRateControllerStateInit:
				self.state = NSRateControllerStateNone;
				break;
			case NSRateControllerStateLikeNo:
			case NSRateControllerStateLikeYes:
				if ([[self.date addValue:1 forComponent:NSCalendarUnitDay] isPast] && self.launch >= 2 && self.action >= 3)
					self.state = NSRateControllerStateNone;
				break;
			case NSRateControllerStateMailNo:
			case NSRateControllerStateMailYes:
			case NSRateControllerStateRateNo:
			case NSRateControllerStateRateYes:
				if ((_state != NSRateControllerStateMailNo && ![self.bundleVersion isEqualToString:[NSBundle bundleVersion]] && [[self.date addValue:1 forComponent:NSCalendarUnitMonth] isPast]) || [[self.date addValue:3 forComponent:NSCalendarUnitMonth] isPast])
					self.state = NSRateControllerStateNone;
				break;
		}

//		self.state = NSRateControllerStateInit;
	}
	
	return self;
}



__static(NSRateController *, instance, [self new])

@end
