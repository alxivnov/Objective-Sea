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

__static(CLLocationManager *, defaultManager, [self new])

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
