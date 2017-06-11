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

#if TARGET_OS_IOS
- (NSNumber *)requestAuthorizationIfNeeded:(BOOL)always {
	if ([CLLocationManager authorization:always].boolValue)
		return @YES;
	else if ([CLLocationManager authorization:always])
		[UIApplication openSettings];
	else
		[[CLLocationManager defaultManager] requestAuthorization:always];

	return Nil;
}
#endif

__static(CLLocationManager *, defaultManager, [self new])

@end

@implementation CLLocation (Convenience)

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
	return [self initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
}

- (void)reverseGeocodeLocation:(void (^)(NSArray<CLPlacemark *> *placemarks))completionHandler {
	if ([CLGeocoder defaultGeocoder].isGeocoding)
		[[CLGeocoder defaultGeocoder] cancelGeocode];
	
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

+ (NSURL *)URLWithSize:(CGSize)size scale:(CGFloat)scale markers:(NSDictionary<NSURL *, NSArray<CLLocation *> *> *)markers {
	NSMutableString *url = [NSMutableString stringWithString:@"https://maps.googleapis.com/maps/api/staticmap"];
	[url appendFormat:@"?maptype=%@", @"roadmap"];
	[url appendFormat:@"&size=%ux%u", (unsigned int)fmin(size.width, 640.0), (unsigned int)fmin(size.height, 640.0)];
	[url appendFormat:@"&scale=%u", (unsigned int)fmin(scale, 2.0)];

	for (NSURL *icon in markers.allKeys) {
		[url appendString:@"&"];
		[url appendString:[[NSString stringWithFormat:@"markers=icon:%@|shadow:false|scale:%u|", icon.absoluteString, (unsigned int)fmin(scale, 2.0)] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
		for (CLLocation *location in markers[icon])
			[url appendString:CLLocationCoordinate2DDescription(location.coordinate)];
	}

	return [NSURL URLWithString:url];
}

@end
