//
//  UIRateController+Answers.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 23.05.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UIRateController+Answers.h"

//#import <Crashlytics/Answers.h>

@implementation UIRateController (Answers)

+ (void)logRateWithMethod:(NSString *)method success:(BOOL)success {
//	[Answers logCustomEventWithName:@"Rate" customAttributes:@{ @"method" : method, @"Rate" : success ? @"YES" : @"NO" }];
}

- (void)setupLogging:(void(^)(NSRateControllerState))buttonAction {
	if (self.buttonAction)
		return;
	
	self.buttonAction = ^void(NSRateControllerState state) {
		NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:@"UIRateController" forKey:@"method"];
		switch (state) {
			case NSRateControllerStateLikeNo:
				attributes[@"Like"] = @"NO";
				break;
			case NSRateControllerStateLikeYes:
				attributes[@"Like"] = @"YES";
				break;
			case NSRateControllerStateMailNo:
				attributes[@"Mail"] = @"NO";
				break;
			case NSRateControllerStateMailYes:
				attributes[@"Mail"] = @"YES";
				break;
			case NSRateControllerStateRateNo:
				attributes[@"Rate"] = @"NO";
				break;
			case NSRateControllerStateRateYes:
				attributes[@"Rate"] = @"YES";
				break;
			default:
				break;
		}
		if (attributes.count > 1)
//			[Answers logCustomEventWithName:@"Rate" customAttributes:attributes];

		if (buttonAction)
			buttonAction(state);
	};
}

- (void)setupLogging {
	[self setupLogging:Nil];
}

@end
