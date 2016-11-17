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

@interface CLGeocoder (Convenience)

@property (strong, nonatomic, readonly, class) CLGeocoder *defaultGeocoder;

@end

@interface CLPlacemark (Convenience)

@property (strong, nonatomic, readonly) NSArray *formattedAddressLines;
@property (strong, nonatomic, readonly) NSString *formattedAddress;

@end

@interface NSURL (CoreLocation)

+ (NSURL *)URLWithLocation:(CLLocation *)location query:(NSString *)query;

@end
