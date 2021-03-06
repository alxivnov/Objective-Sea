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
	else if ([CLLocationManager authorization:always] != Nil)
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

- (BOOL)isValid {
	return CLLocationCoordinate2DIsValid(self.coordinate);
}

- (NSString *)locationString {
	return CLLocationCoordinate2DString(self.coordinate);
}

- (NSString *)locationDescription {
	return CLLocationCoordinate2DDescription(self.coordinate);
}

+ (CLLocation *)locationFromString:(NSString *)string {
	NSArray<NSString *> *coordinates = [string componentsSeparatedByString:@","];
	if (coordinates.count != 2)
		return Nil;

	double latitude = coordinates.firstObject.doubleValue;
	double longitude = coordinates.lastObject.doubleValue;
	if (latitude == 0.0 || longitude == 0.0)
		return Nil;

	CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
	if (!CLLocationCoordinate2DIsValid(coordinate))
		return Nil;

	return [[CLLocation alloc] initWithCoordinate:coordinate];
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

+ (NSURL *)URLWithSize:(CGSize)size scale:(CGFloat)scale markers:(NSDictionary<NSURL *, NSArray<CLLocation *> *> *)markers {
	NSMutableString *url = [NSMutableString stringWithString:@"https://maps.googleapis.com/maps/api/staticmap"];
	[url appendString:@"?maptype=roadmap"];
	[url appendString:@"&format=jpg"];
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

+ (NSURL *)URLWithDirectionsTo:(NSString *)daddr from:(NSString *)saddr transport:(NSString *)dirflg {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:3];
	parameters[@"saddr"] = saddr;
	parameters[@"daddr"] = daddr;
	parameters[@"dirflg"] = dirflg;
	return [[NSURL URLWithString:URL_MAPS] URLByAppendingQueryDictionary:parameters];
}


+ (NSURL *)googleMapsURLWithDirectionsTo:(NSString *)daddr from:(NSString *)saddr transport:(NSString *)dirflg {
	NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", @"api", Nil];
	dic[@"origin"] = saddr;
	dic[@"destination"] = daddr;
	dic[@"travelmode"] = dirflg;
	return [[NSURL URLWithString:@"https://www.google.com/maps/dir/"] URLByAppendingQueryDictionary:dic allowedCharacters:Nil];
}

+ (NSURL *)yandexMapsURLWithDirectionsTo:(NSString *)daddr from:(NSString *)saddr transport:(NSString *)dirflg {
	NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
	dic[@"rtext"] = [NSString stringWithFormat:@"%@~%@", saddr, daddr];
	dic[@"rtt"] = dirflg;
	return [[NSURL URLWithString:@"https://maps.yandex.ru/"] URLByAppendingQueryDictionary:dic allowedCharacters:Nil];
}

@end
