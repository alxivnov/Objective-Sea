//
//  HKActiveEnergy+CMMotionActivitySample.h
//  Sleep Diary
//
//  Created by Alexander Ivanov on 07.03.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import "HKData.h"

#import "CMMotionActivitySample.h"

@interface HKActiveEnergy (CMMotionActivitySample)

+ (void)queryActivityStartingFromDate:(NSDate *)start toDate:(NSDate *)end /*within:(NSTimeInterval)within*/ withHandler:(void (^)(NSArray<CMMotionActivitySample *> *activities))handler;

@end
