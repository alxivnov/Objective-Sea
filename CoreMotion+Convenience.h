//
//  CoreMotion+Convenience.h
//  Sleep Diary
//
//  Created by Alexander Ivanov on 14.10.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>

#import "NSObject+Convenience.h"

@interface CMAltimeter (Convenience)

+ (CMAltimeter *)defaultAltimeter;

- (void)startRelativeAltitudeUpdatesWithHandler:(CMAltitudeHandler)handler;

- (void)getAltitude:(CMAltitudeHandler)handler;

@end

typedef enum : NSUInteger {
	CMMotionActivityTypeNone = 0,
	CMMotionActivityTypeUnknown,
	CMMotionActivityTypeStationary,
	CMMotionActivityTypeWalking,
	CMMotionActivityTypeRunning,
	CMMotionActivityTypeAutomotive,
	CMMotionActivityTypeCycling,
} CMMotionActivityType;

@interface CMMotionActivity (Convenience)

@property (assign, nonatomic, readonly) CMMotionActivityType activityType;

@property (assign, nonatomic, readonly) NSString *activityTypeDescription;

@end

@interface CMMotionActivityManager (Convenience)

+ (instancetype)defaultManager;

- (void)startActivityUpdatesWithHandler:(CMMotionActivityHandler)handler;

- (void)getActivity:(CMMotionActivityHandler)handler;

- (void)queryActivityStartingFromDate:(NSDate *)start toDate:(NSDate *)end withHandler:(void(^)(NSArray<CMMotionActivity *> *activities))handler;

@end
