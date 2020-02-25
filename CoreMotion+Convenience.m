//
//  CoreMotion+Convenience.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 14.10.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "CoreMotion+Convenience.h"

@implementation CMAltimeter (Convenience)

static CMAltimeter *_defaultAltimeter;

+ (CMAltimeter *)defaultAltimeter {
	if (![CMAltimeter isRelativeAltitudeAvailable])
		return Nil;

	@synchronized (self) {
		if (!_defaultAltimeter)
			_defaultAltimeter = [CMAltimeter new];
	}

	return _defaultAltimeter;
}

__static(NSOperationQueue *, queue, [NSOperationQueue new])

- (void)startRelativeAltitudeUpdatesWithHandler:(CMAltitudeHandler)handler {
	[self startRelativeAltitudeUpdatesToQueue:[[self class] queue] withHandler:handler];
}

- (void)getAltitude:(CMAltitudeHandler)handler {
	[self startRelativeAltitudeUpdatesWithHandler:^(CMAltitudeData *altitudeData, NSError *error) {
		[self stopRelativeAltitudeUpdates];

		if (handler)
			handler(altitudeData, error);

		[error log:@"startRelativeAltitudeUpdatesWithHandler:"];
	}];
}

@end

@implementation CMMotionActivity (Convenience)

- (CMMotionActivityType)activityType {
	return self.unknown ? CMMotionActivityTypeUnknown : self.stationary ? CMMotionActivityTypeStationary : self.walking ? CMMotionActivityTypeWalking : self.running ? CMMotionActivityTypeRunning : self.automotive ? CMMotionActivityTypeAutomotive : self.cycling ? CMMotionActivityTypeCycling : CMMotionActivityTypeNone;
}

- (NSString *)activityTypeDescription {
	return self.unknown ? @"Unknown" : self.stationary ? @"Stationary" : self.walking ? @"Walking" : self.running ? @"Running" : self.automotive ? @"Automotive" : self.cycling ? @"Cycling" : Nil;
}

@end

@implementation CMMotionActivityManager (Convenience)

static CMMotionActivityManager *_defaultManager;

+ (instancetype)defaultManager {
	if (![CMMotionActivityManager isActivityAvailable])
		return Nil;

	@synchronized (self) {
		if (!_defaultManager)
			_defaultManager = [self new];
	}

	return _defaultManager;
}

__static(NSOperationQueue *, queue, [NSOperationQueue new])

- (void)startActivityUpdatesWithHandler:(CMMotionActivityHandler)handler {
	[self startActivityUpdatesToQueue:[[self class] queue] withHandler:handler];
}

- (void)getActivity:(CMMotionActivityHandler)handler {
	[self startActivityUpdatesWithHandler:^(CMMotionActivity * _Nullable activity) {
		[self stopActivityUpdates];

		if (handler)
			handler(activity);
	}];
}

- (void)queryActivityStartingFromDate:(NSDate *)start toDate:(NSDate *)end withHandler:(void(^)(NSArray<CMMotionActivity *> *activities))handler {
	if (!start || /*!end ||*/ !handler)
		return;
	
	if (!end)
		end = [NSDate date];

	BOOL reverse = start.timeIntervalSinceReferenceDate > end.timeIntervalSinceReferenceDate;
	[self queryActivityStartingFromDate:reverse ? end : start toDate:reverse ? start : end toQueue:[[self class] queue] withHandler:^(NSArray<CMMotionActivity *> * _Nullable activities, NSError * _Nullable error) {
		if (handler)
			handler(activities);

		[error log:@"queryActivityStartingFromDate:"];
	}];
}

@end
