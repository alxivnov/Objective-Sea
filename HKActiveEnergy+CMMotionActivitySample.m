//
//  HKActiveEnergy+CMMotionActivitySample.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 07.03.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import "HKActiveEnergy+CMMotionActivitySample.h"

@implementation HKActiveEnergy (CMMotionActivitySample)

+ (void)queryActivityStartingFromDate:(NSDate *)start toDate:(NSDate *)end /*within:(NSTimeInterval)within*/ withHandler:(void (^)(NSArray<CMMotionActivitySample *> *))handler {
	[HKActiveEnergy querySamplesWithStartDate:start endDate:end options:HKQueryOptionNone limit:HKObjectQueryNoLimit sort:@{ HKSampleSortIdentifierEndDate : @YES } completion:^(NSArray<__kindof HKSample *> *samples) {
		NSMutableArray<CMMotionActivitySample *> *activities = [NSMutableArray arrayWithCapacity:samples.count * 2];

		if ([samples.firstObject.startDate timeIntervalSinceDate:start] > 1.0)
			[activities addObject:[CMMotionActivitySample sampleWithStartDate:start endDate:samples.firstObject.startDate type:CMMotionActivityTypeStationary confidence:CMMotionActivityConfidenceHigh]];

		for (NSUInteger index = 1; index < samples.count; index++) {
			HKQuantitySample *prev = samples[index - 1];
			HKQuantitySample *curr = samples[index];

			CMMotionActivitySample *activity = activities.lastObject;
			CMMotionActivityType type = CMMotionActivityTypeUnknown;

			if ([curr.startDate timeIntervalSinceDate:prev.endDate] < 1.0 && activity.type == type) {
				[activities removeLastObject];

				[activities addObject:[CMMotionActivitySample sampleWithStartDate:activity.startDate endDate:curr.endDate type:type confidence:activity.confidence == CMMotionActivityConfidenceLow ? CMMotionActivityConfidenceMedium : CMMotionActivityConfidenceHigh]];
			} else {
				[activities addObject:[CMMotionActivitySample sampleWithStartDate:prev.endDate endDate:curr.startDate type:CMMotionActivityTypeStationary confidence:CMMotionActivityConfidenceHigh]];
				[activities addObject:[CMMotionActivitySample sampleWithStartDate:curr.startDate endDate:curr.endDate type:type confidence:CMMotionActivityConfidenceLow]];
			}
		}

		if ([end timeIntervalSinceDate:samples.lastObject.endDate] > 1.0)
			[activities addObject:[CMMotionActivitySample sampleWithStartDate:samples.lastObject.endDate endDate:end type:CMMotionActivityTypeStationary confidence:CMMotionActivityConfidenceHigh]];

		if (handler)
			handler(activities);
	}];
}

@end
