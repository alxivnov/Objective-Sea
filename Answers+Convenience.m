//
//  Answers+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 18.07.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import "Answers+Convenience.h"

@implementation Answers (Convenience)

+ (void)logError:(NSError *)error {
	if (!error)
		return;

//	[[Crashlytics sharedInstance] recordError:error];

	NSMutableDictionary *customAttributes = error.userInfo ? [error.userInfo mutableCopy] : [NSMutableDictionary dictionaryWithCapacity:2];
	customAttributes[@"domain"] = error.domain;
	customAttributes[@"code"] = [NSString stringWithFormat:@"%ld", (long)error.code];
	[self logCustomEventWithName:@"Error" customAttributes:customAttributes];
}

@end
