//
//  HKData.h
//  Sleep Diary
//
//  Created by Alexander Ivanov on 23.04.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <HealthKit/HealthKit.h>

#import "HKHealthStore+Convenience.h"

@interface HKData : NSObject

+ (NSString *)identifier;

+ (HKAuthorizationStatus)authorizationStatus;
+ (NSNumber *)isAuthorized;
+ (void)requestAuthorizationToShare:(BOOL)share andRead:(BOOL)read completion:(void (^)(BOOL success))completion;
+ (void)requestAuthorizationToShare:(BOOL)share andRead:(BOOL)read;

+ (HKSampleQuery *)querySamplesWithPredicate:(NSPredicate *)predicate limit:(NSUInteger)limit sort:(NSDictionary<NSString *, NSNumber *> *)sort completion:(void(^)(NSArray<__kindof HKSample *> *samples))completion;
+ (HKSampleQuery *)querySamplesWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate options:(HKQueryOptions)options limit:(NSUInteger)limit sort:(NSDictionary<NSString *, NSNumber *> *)sort completion:(void (^)(NSArray<__kindof HKSample *> *))completion;
+ (HKSampleQuery *)querySamplesWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate completion:(void(^)(NSArray<__kindof HKSample *> *samples))completion;
+ (HKSampleQuery *)querySampleWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate completion:(void(^)(__kindof HKSample *sample))completion;

//+ (HKObserverQuery *)observeSamplesWithPredicate:(NSPredicate *)predicate updateHandler:(void(^)(HKObserverQuery *query, HKObserverQueryCompletionHandler completionHandler, NSError *error))updateHandler;
//+ (HKObserverQuery *)observeSamplesWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate updateHandler:(void(^)(HKObserverQuery *query, HKObserverQueryCompletionHandler completionHandler, NSError *error))updateHandler;

+ (HKObserverQuery *)observeSamplesWithPredicate:(NSPredicate *)predicate limit:(NSUInteger)limit sort:(NSDictionary<NSString *, NSNumber *> *)sort updateHandler:(void(^)(NSArray<__kindof HKSample *> *samples))updateHandler;
+ (HKObserverQuery *)observeSamplesWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate options:(HKQueryOptions)options limit:(NSUInteger)limit sort:(NSDictionary<NSString *, NSNumber *> *)sort updateHandler:(void (^)(NSArray<__kindof HKSample *> *))updateHandler;
+ (HKObserverQuery *)observeSamplesWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate updateHandler:(void (^)(NSArray<__kindof HKSample *> *))updateHandler;
+ (HKObserverQuery *)observeSampleWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate updateHandler:(void (^)(__kindof HKSample *))updateHandler;

@end

@interface HKHeartRate : HKData

@end

@interface HKDataSleepAnalysis : HKData

+ (HKCategorySample *)sampleWithStartDate:(NSDate *)start endDate:(NSDate *)end value:(HKCategoryValueSleepAnalysis)value metadata:(NSDictionary *)metadata;

+ (BOOL)saveSampleWithStartDate:(NSDate *)start endDate:(NSDate *)end value:(HKCategoryValueSleepAnalysis)value metadata:(NSDictionary *)metadata completion:(void(^)(BOOL success))completion;
+ (BOOL)saveSampleWithStartDate:(NSDate *)start endDate:(NSDate *)end value:(HKCategoryValueSleepAnalysis)value metadata:(NSDictionary *)metadata;

@end

@interface HKStepCount : HKData

@end

@interface HKActiveEnergy : HKData

@end

@interface HKBasalEnergy : HKData

@end

@interface HKObject (Convenience)

@property (strong, nonatomic, readonly) NSString *sourceBundleIdentifier;
@property (strong, nonatomic, readonly) NSString *sourceName;
@property (strong, nonatomic, readonly) NSString *sourceVersion;

@property (assign, nonatomic, readonly) BOOL isOwn;

@end

@interface HKSample (Convenience)

- (NSTimeInterval)duration;

@end

@interface HKQuantitySample (Convenience)

- (double)doubleValueForUnit:(HKUnit *)unit;

@property (assign, nonatomic, readonly) double count;
@property (assign, nonatomic, readonly) double countPerMinute;

@property (assign, nonatomic, readonly) double calorie;
@property (assign, nonatomic, readonly) double kilocalorie;

@end

@interface HKQuery (Convenience)

+ (NSPredicate *)predicateForSamplesWithDate:(NSDate *)date1 date:(NSDate *)date2 options:(HKQueryOptions)options;
+ (NSPredicate *)predicateForSamplesWithDate:(NSDate *)date1 date:(NSDate *)date2;

@end
