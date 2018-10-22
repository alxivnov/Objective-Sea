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

#define CLLocationIsEqualToLocation(l1, l2) (l1 == l2 || (l1 && l2 && fabs(l1.coordinate.latitude - l2.coordinate.latitude) < DBL_EPSILON && fabs(l1.coordinate.longitude - l2.coordinate.longitude) < DBL_EPSILON))

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

@property (strong, nonatomic, readonly) NSString *locationString;
@property (strong, nonatomic, readonly) NSString *locationDescription;

+ (CLLocation *)locationFromString:(NSString *)string;

@end

@interface CLGeocoder (Convenience)

@property (strong, nonatomic, readonly, class) CLGeocoder *defaultGeocoder;

@end

@interface CLPlacemark (Convenience)

//@property (strong, nonatomic, readonly) NSArray *formattedAddressLines;
@property (strong, nonatomic, readonly) NSString *formattedAddress;

@end

#define URL_MAPS @"http://maps.apple.com/"
#define CLLocationCoordinate2DString(coord) [NSString stringWithFormat:@"%.04f, %.04f", coord.latitude, coord.longitude]
#define CLLocationCoordinate2DDescription(coord) [NSString stringWithFormat:@"%f,%f", coord.latitude, coord.longitude]

#import <CoreGraphics/CoreGraphics.h>

@interface NSURL (CoreLocation)

+ (NSURL *)URLWithLocation:(CLLocation *)location query:(NSString *)query;

+ (NSURL *)URLWithSize:(CGSize)size scale:(CGFloat)scale markers:(NSDictionary<NSURL *, NSArray<CLLocation *> *> *)markers;

#define AppleMapsTransportTypeDriving @"d"
#define AppleMapsTransportTypeWalking @"w"
#define AppleMapsTransportTypeTransit @"r"
+ (NSURL *)URLWithDirectionsTo:(NSString *)daddr from:(NSString *)saddr transport:(NSString *)dirflg;

#define GoogleMapsTransportTypeDriving @"driving"
#define GoogleMapsTransportTypeWalking @"walking"
#define GoogleMapsTransportTypeCycling @"bicycling"
#define GoogleMapsTransportTypeTransit @"transit"
+ (NSURL *)googleMapsURLWithDirectionsTo:(NSString *)daddr from:(NSString *)saddr transport:(NSString *)dirflg;

#define YandexMapsTransportTypeDriving @"auto"
#define YandexMapsTransportTypeTransit @"mt"
#define YandexMapsTransportTypeWalking @"pd"
+ (NSURL *)yandexMapsURLWithDirectionsTo:(NSString *)daddr from:(NSString *)saddr transport:(NSString *)dirflg;

@end
