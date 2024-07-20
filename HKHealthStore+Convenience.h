//
//  HKHealthStore+Convenience.h
//  Sleep Diary
//
//  Created by Alexander Ivanov on 18.04.15.
//  Copyright (c) 2015 Alexander Ivanov. All rights reserved.
//

#import <HealthKit/HealthKit.h>

#import "NSArray+Convenience.h"
#import "NSObject+Convenience.h"

#define CategoryValueSleepAnalysisInBed					0
#define CategoryValueSleepAnalysisAsleepUnspecified		1
#define CategoryValueSleepAnalysisAsleep				1
#define CategoryValueSleepAnalysisAwake   				2
#define CategoryValueSleepAnalysisAsleepCore			3
#define CategoryValueSleepAnalysisAsleepDeep			4
#define CategoryValueSleepAnalysisAsleepREM				5
#define IS_ASLEEP(value) (value == 1 || value == 3 || value == 4 || value == 5)

@interface HKHealthStore (Convenience)

+ (HKHealthStore *)defaultStore;

- (BOOL)saveObject:(HKObject *)object completion:(void (^)(BOOL success))completion;
- (BOOL)saveObjects:(NSArray<HKObject *> *)objects completion:(void (^)(BOOL success))completion;
- (BOOL)deleteObject:(HKObject *)object completion:(void (^)(BOOL success))completion;
- (BOOL)deleteObjects:(NSArray<HKObject *> *)objects completion:(void (^)(BOOL success))completion;

- (HKAuthorizationStatus)authorizationStatusForIdentifier:(NSString *)identifier;
- (HKAuthorizationStatus)authorizationStatusForIdentifiers:(NSArray<NSString *> *)identifiers;
- (NSNumber *)isAuthorized:(NSArray<NSString *> *)identifiers;
- (void)requestAuthorizationToShare:(NSArray<NSString *> *)shareIdentifiers read:(NSArray<NSString *> *)readIdentifiers completion:(void (^)(BOOL success))completion;
- (void)requestAuthorization:(NSString *)identifier share:(BOOL)share read:(BOOL)read completion:(void (^)(BOOL success))completion;

- (HKCategorySample *)categotySampleWithIdentifier:(NSString *)identifier value:(NSInteger)value startDate:(NSDate *)startDate endDate:(NSDate *)endDate metadata:(NSDictionary *)metadata;
- (HKQuantitySample *)quantitySampleWithIdentifier:(NSString *)identifier quantity:(HKQuantity *)quantity startDate:(NSDate *)startDate endDate:(NSDate *)endDate metadata:(NSDictionary *)metadata;

- (BOOL)saveCategorySampleWithIdentifier:(NSString *)identifier value:(NSInteger)value startDate:(NSDate *)startDate endDate:(NSDate *)endDate metadata:(NSDictionary *)metadata completion:(void(^)(BOOL success))completion;
- (BOOL)saveQuantitySampleWithIdentifier:(NSString *)identifier quantity:(HKQuantity *)quantity startDate:(NSDate *)startDate endDate:(NSDate *)endDate metadata:(NSDictionary *)metadata completion:(void(^)(BOOL success))completion;

- (HKSampleQuery *)querySamplesWithIdentifier:(NSString *)identifier predicate:(NSPredicate *)predicate limit:(NSUInteger)limit sort:(NSDictionary<NSString *, NSNumber *> *)sort completion:(void(^)(NSArray *samples))completion;
- (HKSampleQuery *)querySamplesWithIdentifier:(NSString *)identifier predicate:(NSPredicate *)predicate limit:(NSUInteger)limit completion:(void(^)(NSArray *samples))completion;
- (HKSampleQuery *)querySampleWithIdentifier:(NSString *)identifier predicate:(NSPredicate *)predicate sort:(NSDictionary<NSString *, NSNumber *> *)sort completion:(void(^)(NSArray *samples))completion;
- (HKSampleQuery *)querySamplesWithIdentifier:(NSString *)identifier predicate:(NSPredicate *)predicate completion:(void(^)(NSArray *samples))completion;

- (HKObserverQuery *)observeSamplesWithIdentifier:(NSString *)identifier predicate:(NSPredicate *)predicate updateHandler:(void(^)(HKObserverQuery *query, HKObserverQueryCompletionHandler completionHandler, NSError * error))updateHandler;

@end

@interface HKObjectType (Convenience)

+ (HKObjectType *)typeForIdentifier:(NSString *)identifier;

@end

@interface HKHeartbeatSeriesSample (Convenience)

- (HKHeartbeatSeriesQuery *)queryHeartbeats:(void (^)(NSArray *heartbeats))completion;
- (HKHeartbeatSeriesQuery *)queryRMSSD:(void (^)(double rmssd))completion;

@end
