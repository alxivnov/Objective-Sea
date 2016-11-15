//
//  CMMotionActivitySample.h
//  Sleep Diary
//
//  Created by Alexander Ivanov on 02.10.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CoreMotion+Convenience.h"
#import "Dispatch+Convenience.h"
#import "NSArray+Convenience.h"
#import "NSObject+Convenience.h"

#define HKMetadataKeyActivities @"HKMetadataKeyActivities"
#define HKMetadataKeySampleActivities @"HKMetadataKeySampleActivities"

@interface CMMotionActivitySample : NSObject

@property (strong, nonatomic, readonly) NSDate *startDate;
@property (strong, nonatomic, readonly) NSDate *endDate;
@property (assign, nonatomic, readonly) CMMotionActivityType type;
@property (assign, nonatomic, readonly) CMMotionActivityConfidence confidence;

@property (assign, nonatomic, readonly) NSTimeInterval duration;

+ (void)queryActivityStartingFromDate:(NSDate *)start toDate:(NSDate *)end within:(NSTimeInterval)within withHandler:(void (^)(NSArray<CMMotionActivitySample *> *activities))handler;

+ (NSData *)samplesToData:(NSArray<CMMotionActivitySample *> *)samples date:(NSDate *)date;
+ (NSArray<CMMotionActivitySample *> *)samplesFromData:(NSData *)data date:(NSDate *)date;

+ (NSString *)samplesToString:(NSArray<CMMotionActivitySample *> *)samples date:(NSDate *)date;
+ (NSArray<CMMotionActivitySample *> *)samplesFromString:(NSString *)data date:(NSDate *)date;

@end
