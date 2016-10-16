//
//  CMMotionActivitySample.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 02.10.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "CMMotionActivitySample.h"

@interface CMMotionActivitySample ()
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (assign, nonatomic) CMMotionActivityType type;
@property (assign, nonatomic) CMMotionActivityConfidence confidence;
@end

@implementation CMMotionActivitySample

- (NSTimeInterval)duration {
	return [self.endDate timeIntervalSinceDate:self.startDate];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"{ startDate : %@, endDate : %@, type : %lu, confidence : %ld }", self.startDate, self.endDate, (unsigned long)self.type, (long)self.confidence];
}

+ (instancetype)sampleWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate type:(CMMotionActivityType)type confidence:(CMMotionActivityConfidence)confidence {
	if (!startDate || !endDate || type == CMMotionActivityTypeNone)
		return Nil;

	CMMotionActivitySample *sample = [CMMotionActivitySample new];
	sample.startDate = startDate;
	sample.endDate = endDate;
	sample.type = type;
	sample.confidence = confidence;
	return sample;
}

+ (instancetype)sampleWithStartActivity:(CMMotionActivity *)startActivity endActivity:(CMMotionActivity *)endActivity {
	return [self sampleWithStartDate:startActivity.startDate endDate:endActivity.startDate type:startActivity.activityType confidence:startActivity.confidence];
}

+ (void)queryActivityStartingFromDate:(NSDate *)start toDate:(NSDate *)end within:(NSTimeInterval)within withHandler:(void (^)(NSArray<CMMotionActivitySample *> *))handler {
	if (!handler)
		return;

	[[CMMotionActivityManager defaultManager] queryActivityStartingFromDate:start toDate:end withHandler:^(NSArray<CMMotionActivity *> *activities) {
		__block NSArray<CMMotionActivity *> *temp = activities;

		if (activities.count && within > 0.0 && activities.firstObject.activityType == CMMotionActivityTypeNone)
			[GCD sync:^(GCD *sema) {
				[[CMMotionActivityManager defaultManager] queryActivityStartingFromDate:[start dateByAddingTimeInterval:-within] toDate:start withHandler:^(NSArray<CMMotionActivity *> *startActivities) {
					if (startActivities.count && startActivities.lastObject.activityType != CMMotionActivityTypeNone)
						temp = [@[ startActivities.lastObject ] arrayByAddingObjectsFromArray:temp];

					[sema signal];
				}];
			}];

		if (activities.count && within > 0.0 && activities.lastObject.activityType != CMMotionActivityTypeNone)
			[GCD sync:^(GCD *sema) {
				[[CMMotionActivityManager defaultManager] queryActivityStartingFromDate:end toDate:[end dateByAddingTimeInterval:within] withHandler:^(NSArray<CMMotionActivity *> *endActivities) {
					if (endActivities.count && endActivities.firstObject.activityType == CMMotionActivityTypeNone)
						temp = [temp arrayByAddingObject:endActivities.firstObject];

					[sema signal];
				}];
			}];

		NSMutableArray<CMMotionActivitySample *> *array = [NSMutableArray arrayWithCapacity:activities.count];
		for (NSUInteger index = 0; index + 1 < temp.count; index++) {
			CMMotionActivitySample *object = [CMMotionActivitySample sampleWithStartActivity:temp[index] endActivity:temp[index + 1]];
			if (object)
				[array addObject:object];
		}
		handler(array);
	}];
}

- (NSData *)sampleData:(NSDate *)date {
	NSMutableData *data = [NSMutableData dataWithLength:date ? 10 : 18];

	if (date) {
		float startDate = [self.startDate timeIntervalSinceDate:date];
		float endDate = [self.endDate timeIntervalSinceDate:date];

		[data replaceBytesInRange:NSMakeRange(0, sizeof(startDate)) withBytes:&startDate];
		[data replaceBytesInRange:NSMakeRange(4, sizeof(endDate)) withBytes:&endDate];
	} else {
		double startDate = self.startDate.timeIntervalSinceReferenceDate;
		double endDate = self.endDate.timeIntervalSinceReferenceDate;

		[data replaceBytesInRange:NSMakeRange(0, sizeof(startDate)) withBytes:&startDate];
		[data replaceBytesInRange:NSMakeRange(8, sizeof(endDate)) withBytes:&endDate];
	}

	unsigned char type = self.type;
	char confidence = self.confidence;

	[data replaceBytesInRange:NSMakeRange(date ? 8 : 16, sizeof(type)) withBytes:&type];
	[data replaceBytesInRange:NSMakeRange(date ? 9 : 17, sizeof(confidence)) withBytes:&confidence];

	return data;
}

+ (instancetype)sampleWithData:(NSData *)data date:(NSDate *)date {
	NSDate *startDate = Nil;
	NSDate *endDate = Nil;

	if (date) {
		float startTimeInterval = 0.0;
		float endTimeInterval = 0.0;

		[data getBytes:&startTimeInterval range:NSMakeRange(0, sizeof(startTimeInterval))];
		[data getBytes:&endTimeInterval range:NSMakeRange(4, sizeof(endTimeInterval))];

		startDate = [date dateByAddingTimeInterval:startTimeInterval];
		endDate = [date dateByAddingTimeInterval:endTimeInterval];
	} else {
		double startTimeInterval = 0.0;
		double endTimeInterval = 0.0;

		[data getBytes:&startTimeInterval range:NSMakeRange(0, sizeof(startTimeInterval))];
		[data getBytes:&endTimeInterval range:NSMakeRange(8, sizeof(endTimeInterval))];

		startDate = [NSDate dateWithTimeIntervalSinceReferenceDate:startTimeInterval];
		endDate = [NSDate dateWithTimeIntervalSinceReferenceDate:endTimeInterval];
	}

	unsigned char type = 0;
	char confidence = 0;

	[data getBytes:&type range:NSMakeRange(date ? 8 : 16, sizeof(type))];
	[data getBytes:&confidence range:NSMakeRange(date ? 9 : 17, sizeof(confidence))];

	return [self sampleWithStartDate:startDate endDate:endDate type:type confidence:confidence];
}

+ (NSData *)samplesToData:(NSArray<CMMotionActivitySample *> *)samples date:(NSDate *)date {
	NSUInteger length = date ? 10 : 18;

	NSMutableData *data = [NSMutableData dataWithCapacity:samples.count * length];
	for (CMMotionActivitySample *sample in samples)
		[data appendData:[sample sampleData:date]];
	return data;
}

+ (NSArray<CMMotionActivitySample *> *)samplesFromData:(NSData *)data date:(NSDate *)date {
	NSUInteger length = date ? 10 : 18;

	NSUInteger count = data.length / length;

	NSMutableArray<CMMotionActivitySample *> *samples = [NSMutableArray arrayWithCapacity:count];
	for (NSUInteger index = 0; index < count; index++)
		[samples addObject:[CMMotionActivitySample sampleWithData:[data subdataWithRange:NSMakeRange(index * length, length)] date:date]];
	return samples;
}

+ (NSString *)samplesToString:(NSArray<CMMotionActivitySample *> *)samples date:(NSDate *)date {
	return samples.count ? [[self samplesToData:samples date:date] base64EncodedStringWithOptions:0] : Nil;
}

+ (NSArray<CMMotionActivitySample *> *)samplesFromString:(NSString *)string date:(NSDate *)date {
	return string ? [self samplesFromData:[[NSData alloc] initWithBase64EncodedString:string options:0] date:date] : Nil;
}

@end
