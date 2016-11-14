//
//  CoreLocation+Convenience.h
//  Crowd Guard
//
//  Created by Alexander Ivanov on 12.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "NSObject+Convenience.h"

@interface CLLocationManager (Convenience)

+ (NSNumber *)authorization:(BOOL)always;

- (void)requestAuthorization:(BOOL)always;

@property (strong, nonatomic, readonly, class) CLLocationManager *defaultManager;

@end
