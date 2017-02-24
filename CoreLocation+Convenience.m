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

#if TARGET_OS_IPHONE
- (NSNumber *)requestAuthorizationIfNeeded:(BOOL)always {
	if ([CLLocationManager authorization:always].boolValue)
		return @YES;
	else if ([CLLocationManager authorization:always] == Nil)
		[[CLLocationManager defaultManager] requestAuthorization:YES];
	else
		[UIApplication openSettings];

	return Nil;
}
#endif

__static(CLLocationManager *, defaultManager, [self new])

@end

@implementation CLLocation (Convenience)

- (void)reverseGeocodeLocation:(void (^)(NSArray<CLPlacemark *> *placemarks))completionHandler {
	[[CLGeocoder defaultGeocoder] reverseGeocodeLocation:self completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
		if (completionHandler)
			completionHandler(placemarks);

		[error log:@"reverseGeocodeLocation:"];
	}];
}

@end

@implementation CLGeocoder (Convenience)

__static(CLGeocoder *, defaultGeocoder, [self new])

@end

@implementation CLPlacemark (Convenience)

- (NSArray *)formattedAddressLines {
	return self.addressDictionary[@"FormattedAddressLines"];
}

- (NSString *)formattedAddress {
	return [self.formattedAddressLines componentsJoinedByString:@", "];
}

@end

@implementation NSURL (CoreLocation)

+ (NSURL *)URLWithLocation:(CLLocation *)location query:(NSString *)query {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:2];
	parameters[@"ll"] = CLLocationCoordinate2DDescription(location.coordinate);
	parameters[@"q"] = query;
	return [[NSURL URLWithString:URL_MAPS] URLByAppendingQueryDictionary:parameters];
}

+ (NSURL *)URLWithDirectionsTo:(NSString *)daddr from:(NSString *)saddr {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:saddr ? 3 : 2];
	parameters[@"dirflg"] = @"w";	// by foot
	parameters[@"daddr"] = daddr;
	parameters[@"saddr"] = saddr;
	return [[NSURL URLWithString:URL_MAPS] URLByAppendingQueryDictionary:parameters];
}

+ (NSURL *)URLWithDirectionsToLocation:(CLLocation *)daddr fromLocation:(CLLocation *)saddr {
	return [self URLWithDirectionsTo:daddr ? CLLocationCoordinate2DDescription(daddr.coordinate) : Nil from:saddr ? CLLocationCoordinate2DDescription(saddr.coordinate) : Nil];
}

@end
