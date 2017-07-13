//
//  Accelerate+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 13.06.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import "Accelerate+Convenience.h"

#if __has_include(<Accelerate/Accelerate.h>)

@import Accelerate;

#endif

@implementation NSArray (Accelerate)

#if __has_include(<Accelerate/Accelerate.h>)

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

- (double)sum:(NSNumber *(^)(id))predicate {
	NSData *vector = [self vector:predicate];

	double sum = 0.0;

	vDSP_sveD(vector.bytes, 1, &sum, vector.length / sizeof(double));

	return sum;
}

- (NSArray<NSNumber *> *)meanAndStandardDeviation:(NSNumber *(^)(id))predicate {
	NSData *vector = [self vector:predicate];

	double mean = 0.0;
	double standardDeviation = 0.0;

	vDSP_normalizeD(vector.bytes, 1, NULL, 1, &mean, &standardDeviation, vector.length / sizeof(double));

	return @[ @(mean), @(standardDeviation) ];
}

- (NSArray<NSNumber *> *)quartiles:(NSNumber *(^)(id))predicate {
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

#else

- (double)aggregate:(double(^)(double val, double obj))predicate {
	double val = [self.firstObject doubleValue];
	for (NSUInteger index = 1; index < self.count; index++)
		val = predicate(val, [self[index] doubleValue]);
	return val;
}

- (double)sum:(NSNumber *(^)(id))predicate {
	NSArray *numbers = [self map:predicate];
	return [numbers aggregate:^double(double val, double obj) {
		return val + obj;
	}];
}

- (NSArray<NSNumber *> *)meanAndStandardDeviation:(NSNumber *(^)(id))predicate {
	NSArray *numbers = [self map:predicate];

	if (!numbers.count)
		return Nil;

	double avg = [numbers aggregate:^double(double val, double obj) {
		return val + obj;
	}] / numbers.count;

	double dev = sqrt([numbers aggregate:^double(double val, double obj) {
		return val + pow(obj - avg, 2.0);
	}] / numbers.count);

	return @[ @(avg), @(dev) ];
}

- (NSArray<NSNumber *> *)quartiles:(NSNumber *(^)(id))predicate {
	NSArray<NSNumber *> *numbers = [[self map:predicate] sortedArray];

	NSUInteger count = numbers.count;
	if (count < 5)
		return Nil;

	NSUInteger q1 = count / 4;
	NSUInteger q2 = count / 2;
	NSUInteger q3 = count * 3 / 4;

	double min = numbers[0].doubleValue;
	double quartile1 = q2 % 2 ? numbers[q1].doubleValue : ((numbers[q1 - 1].doubleValue + numbers[q1].doubleValue) / 2.0);
	double median = count % 2 ? numbers[q2].doubleValue : ((numbers[q2 - 1].doubleValue + numbers[q2].doubleValue) / 2.0);
	double quartile3 = q2 % 2 ? numbers[q3].doubleValue : ((numbers[q3 - 1].doubleValue + numbers[q3].doubleValue) / 2.0);
	double max = numbers[count - 1].doubleValue;

	return @[ @(min), @(quartile1), @(median), @(quartile3), @(max) ];
}

#endif

- (double)avg:(NSNumber *(^)(id))predicate {
	return [self meanAndStandardDeviation:predicate].firstObject.doubleValue;
}

- (double)dev:(NSNumber *(^)(id))predicate {
	return [self meanAndStandardDeviation:predicate].lastObject.doubleValue;
}

- (double)min:(NSNumber *(^)(id))predicate {
	return [self quartiles:predicate].firstObject.doubleValue;
}

- (double)med:(NSNumber *(^)(id))predicate {
	return [self quartiles:predicate][2].doubleValue;
}

- (double)max:(NSNumber *(^)(id))predicate {
	return [self quartiles:predicate].lastObject.doubleValue;
}

@end
