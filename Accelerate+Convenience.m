//
//  Accelerate+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 13.06.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import "Accelerate+Convenience.h"

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

- (double)vSum:(NSNumber *(^)(id))predicate {
	NSData *vector = [self vector:predicate];

	double sum = 0.0;

	if (vector.length)
		vDSP_sveD(vector.bytes, 1, &sum, vector.length / sizeof(double));

	return sum;
}

- (NSArray<NSNumber *> *)meanAndStandardDeviation:(NSNumber *(^)(id))predicate {
	NSData *vector = [self vector:predicate];

	double mean = 0.0;
	double standardDeviation = 0.0;

	if (vector.length)
		vDSP_normalizeD(vector.bytes, 1, NULL, 1, &mean, &standardDeviation, vector.length / sizeof(double));

	return @[ @(mean), @(standardDeviation) ];
}

- (NSArray<NSNumber *> *)quartiles:(NSNumber *(^)(id))predicate {
	NSData *vector = [self vector:predicate];

	NSUInteger count = vector.length / sizeof(double);

	double *bytes = malloc(vector.length);
	[vector getBytes:bytes length:vector.length];

	vDSP_vsortD(bytes, count, 1);

	NSUInteger i1 = count * 0.25;
	NSUInteger i2 = count * 0.5;
	NSUInteger i3 = count * 0.75;

	NSNumber *min = count >= 1 ? @(bytes[0]) : [NSDecimalNumber notANumber];
	NSNumber *q1 = count >= 3 ? @(i2 % 2 ? bytes[i1] : ((bytes[i1 - 1] + bytes[i1]) / 2.0)) : [NSDecimalNumber notANumber];
	NSNumber *q2 = count >= 2 ? @(count % 2 ? bytes[i2] : ((bytes[i2 - 1] + bytes[i2]) / 2.0)) : [NSDecimalNumber notANumber];
	NSNumber *q3 = count >= 3 ? @(i2 % 2 ? bytes[i3] : ((bytes[i3 - 1] + bytes[i3]) / 2.0)) : [NSDecimalNumber notANumber];
	NSNumber *max = count >= 1 ? @(bytes[count - 1]) : [NSDecimalNumber notANumber];
	free(bytes);

	return @[ min, q1, q2, q3, max ];
}

#else

- (double)aggregate:(double(^)(double val, double obj))predicate {
	double val = [self.firstObject doubleValue];
	for (NSUInteger index = 1; index < self.count; index++)
		val = predicate(val, [self[index] doubleValue]);
	return val;
}

- (double)vSum:(NSNumber *(^)(id))predicate {
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

	NSNumber *min = count >= 1 ? numbers[0] : [NSDecimalNumber notANumber];
	NSNumber *quartile1 = count >= 2 ? (q2 % 2 ? numbers[q1] : @((numbers[q1 - 1].doubleValue + numbers[q1].doubleValue) / 2.0)) : [NSDecimalNumber notANumber];
	NSNumber *median = count >= 4 ? (count % 2 ? numbers[q2] : @((numbers[q2 - 1].doubleValue + numbers[q2].doubleValue) / 2.0)) : [NSDecimalNumber notANumber];
	NSNumber *quartile3 = count >= 2 ? (q2 % 2 ? numbers[q3] : @((numbers[q3 - 1].doubleValue + numbers[q3].doubleValue) / 2.0)) : [NSDecimalNumber notANumber];
	NSNumber *max = count >= 1 ? numbers[count - 1] : [NSDecimalNumber notANumber];

	return @[ min, quartile1, median, quartile3, max ];
}

#endif

- (double)vAvg:(NSNumber *(^)(id))predicate {
	return [self meanAndStandardDeviation:predicate].firstObject.doubleValue;
}

- (double)vDev:(NSNumber *(^)(id))predicate {
	return [self meanAndStandardDeviation:predicate].lastObject.doubleValue;
}

- (double)vMin:(NSNumber *(^)(id))predicate {
	NSNumber *obj = [self quartiles:predicate].firstObject;
	return [obj isEqualToNumber:[NSDecimalNumber notANumber]] ? 0.0 : obj.doubleValue;
}

- (double)vMed:(NSNumber *(^)(id))predicate {
	NSNumber *obj = [self quartiles:predicate][2];
	return [obj isEqualToNumber:[NSDecimalNumber notANumber]] ? 0.0 : obj.doubleValue;
}

- (double)vMax:(NSNumber *(^)(id))predicate {
	NSNumber *obj = [self quartiles:predicate].lastObject;
	return [obj isEqualToNumber:[NSDecimalNumber notANumber]] ? 0.0 : obj.doubleValue;
}

@end
