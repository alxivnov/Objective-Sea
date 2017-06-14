//
//  Accelerate+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 13.06.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import "Accelerate+Convenience.h"

@import Accelerate;

@implementation NSArray (Accelerate)

- (NSData *)vector:(NSNumber *(^)(id))predicate {
	NSMutableData *data = [NSMutableData data];

	for (id obj in self) {
		id object = predicate ? predicate(obj) : obj;
		if (object) {
			double d = [object doubleValue];

			[data appendBytes:&d length:sizeof(double)];
		}
	}

	return data;
}

- (NSNumber *)sumOfElements:(NSNumber *(^)(id))predicate {
	NSData *vector = [self vector:predicate];

	double sum = 0.0;

	vDSP_sveD(vector.bytes, 1, &sum, vector.length / sizeof(double));

	return @(sum);
}

- (NSArray<NSNumber *> *)meanAndStandardDeviation:(NSNumber *(^)(id))predicate {
	NSData *vector = [self vector:predicate];

	double mean = 0.0;
	double standardDeviation = 0.0;

	vDSP_normalizeD(vector.bytes, 1, NULL, 1, &mean, &standardDeviation, vector.length / sizeof(double));

	return @[ @(mean), @(standardDeviation) ];
}

- (NSArray<NSNumber *> *)fiveNumberSummary:(NSNumber *(^)(id))predicate {
	NSData *vector = [self vector:predicate];

	NSUInteger count = vector.length / sizeof(double);
	if (count < 5)
		return Nil;

	double *bytes = malloc(vector.length);
	[vector getBytes:bytes length:vector.length];

	vDSP_vsortD(bytes, count, 1);

	NSUInteger q1 = count / 4;
	NSUInteger q2 = count / 2;
	NSUInteger q3 = count * 3 / 4;

	double min = bytes[0];
	double quartile1 = q2 % 2 ? bytes[q1] : ((bytes[q1 - 1] + bytes[q1]) / 2.0);
	double median = count % 2 ? bytes[q2] : ((bytes[q2 - 1] + bytes[q2]) / 2.0);
	double quartile3 = q2 % 2 ? bytes[q3] : ((bytes[q3 - 1] + bytes[q3]) / 2.0);
	double max = bytes[count - 1];

	free(bytes);

	return @[ @(min), @(quartile1), @(median), @(quartile3), @(max) ];
}

@end
