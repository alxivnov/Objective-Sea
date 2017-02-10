//
//  CoreLocation+Convenience.h
//  Crowd Guard
//
//  Created by Alexander Ivanov on 12.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "NSObject+Convenience.h"
#import "NSURL+Convenience.h"

@interface CLLocationManager (Convenience)

+ (NSNumber *)authorization:(BOOL)always;

- (void)requestAuthorization:(BOOL)always;

@property (strong, nonatomic, readonly, class) CLLocationManager *defaultManager;

@end

@interface CLLocation (Convenience)

- (void)reverseGeocodeLocation:(void (^)(NSArray<CLPlacemark *> *placemarks))completionHandler;

@end

@interface CLGeocoder (Convenience)

@property (strong, nonatomic, readonly, class) CLGeocoder *defaultGeocoder;

@end

@interface CLPlacemark (Convenience)

@property (strong, nonatomic, readonly) NSArray *formattedAddressLines;
@property (strong, nonatomic, readonly) NSString *formattedAddress;

@end

#define URL_MAPS @"http://maps.apple.com/"
#define CLLocationCoordinate2DString(coord) [NSString stringWithFormat:@"%.04f, %.04f", coord.latitude, coord.longitude]
#define CLLocationCoordinate2DDescription(coord) [NSString stringWithFormat:@"%f,%f", coord.latitude, coord.longitude]

@interface NSURL (CoreLocation)

+ (NSURL *)URLWithLocation:(CLLocation *)location query:(NSString *)query;

+ (NSURL *)URLWithDirectionsTo:(NSString *)daddr from:(NSString *)saddr;
+ (NSURL *)URLWithDirectionsToLocation:(CLLocation *)daddr fromLocation:(CLLocation *)saddr;

@end
