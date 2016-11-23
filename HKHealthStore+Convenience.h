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
