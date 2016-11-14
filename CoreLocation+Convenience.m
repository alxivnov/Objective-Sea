//
//  CoreLocation+Convenience.m
//  Crowd Guard
//
//  Created by Alexander Ivanov on 12.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "CoreLocation+Convenience.h"

@implementation CLLocationManager (Convenience)

+ (NSNumber *)authorization:(BOOL)always {
	CLAuthorizationStatus status = [CLLocationManager authorizationStatus];

	return status == kCLAuthorizationStatusNotDetermined ? Nil : status == kCLAuthorizationStatusAuthorizedAlways || (!always && status == kCLAuthorizationStatusAuthorizedWhenInUse) ? @YES : @NO;
}

- (void)requestAuthorization:(BOOL)always {
	if (always)
		[self requestAlwaysAuthorization];
	else
		[self requestWhenInUseAuthorization];
}

__static(CLLocationManager *, defaultManager, [CLLocationManager new])

@end
