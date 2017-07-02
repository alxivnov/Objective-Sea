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

#define CLLocationIsEqualToLocation(l1, l2) ({ CLLocation *__l1 = (l1); CLLocation *__l2 = (l2); __l1 == __l2 || (__l2 != Nil && fabs(__l1.coordinate.latitude - __l2.coordinate.latitude) < DBL_EPSILON && fabs(__l1.coordinate.longitude - __l2.coordinate.longitude) < DBL_EPSILON); })

#if TARGET_OS_IOS
#import "UIApplication+Convenience.h"
#endif

@interface CLLocationManager (Convenience)

+ (NSNumber *)authorization:(BOOL)always;

- (void)requestAuthorization:(BOOL)always;

#if TARGET_OS_IOS
- (NSNumber *)requestAuthorizationIfNeeded:(BOOL)always;
#endif

@property (strong, nonatomic, readonly, class) CLLocationManager *defaultManager;

@end

@interface CLLocation (Convenience)

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

- (void)reverseGeocodeLocation:(void (^)(NSArray<CLPlacemark *> *placemarks))completionHandler;

@property (assign, nonatomic, readonly) BOOL isValid;

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

#import <CoreGraphics/CoreGraphics.h>

@interface NSURL (CoreLocation)

+ (NSURL *)URLWithLocation:(CLLocation *)location query:(NSString *)query;

+ (NSURL *)URLWithDirectionsTo:(NSString *)daddr from:(NSString *)saddr;
+ (NSURL *)URLWithDirectionsToLocation:(CLLocation *)daddr fromLocation:(CLLocation *)saddr;

+ (NSURL *)URLWithSize:(CGSize)size scale:(CGFloat)scale markers:(NSDictionary<NSURL *, NSArray<CLLocation *> *> *)markers;

@end
