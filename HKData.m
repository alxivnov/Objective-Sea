//
//  HKData.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 23.04.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "HKData.h"

@implementation HKData

+ (NSString *)identifier {
	return Nil;	// abstract
}



+ (HKAuthorizationStatus)authorizationStatus {
	return [[HKHealthStore defaultStore] authorizationStatusForIdentifier:[self identifier]];
}

+ (NSNumber *)isAuthorized {
	return [[HKHealthStore defaultStore] isAuthorized:@[ [self identifier] ]];
}

+ (void)requestAuthorizationToShare:(BOOL)share andRead:(BOOL)read completion:(void (^)(BOOL))completion {
	[[HKHealthStore defaultStore] requestAuthorization:[self identifier] share:share read:read completion:completion];
}

+ (void)requestAuthorizationToShare:(BOOL)share andRead:(BOOL)read {
	[self requestAuthorizationToShare:share andRead:read completion:Nil];
}



+ (HKSampleQuery *)querySamplesWithPredicate:(NSPredicate *)predicate limit:(NSUInteger)limit sort:(NSDictionary<NSString *, NSNumber *> *)sort completion:(void(^)(NSArray<__kindof HKSample *> *samples))completion {
	return [[HKHealthStore defaultStore] querySamplesWithIdentifier:[self identifier] predicate:predicate limit:limit sort:sort completion:completion];
}

+ (HKSampleQuery *)querySamplesWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate options:(HKQueryOptions)options limit:(NSUInteger)limit sort:(NSDictionary<NSString *, NSNumber *> *)sort completion:(void (^)(NSArray<__kindof HKSample *> *))completion {
	return [self querySamplesWithPredicate:[HKQuery predicateForSamplesWithDate:startDate date:endDate options:options] limit:limit sort:sort completion:completion];
}

+ (HKSampleQuery *)querySamplesWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate completion:(void (^)(NSArray<__kindof HKSample *> *))completion {
	return [self querySamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone limit:HKObjectQueryNoLimit sort:@{ HKSampleSortIdentifierEndDate : @NO } completion:completion];
}

+ (HKSampleQuery *)querySampleWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate completion:(void (^)(__kindof HKSample *))completion {
	return [self querySamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone limit:1 sort:@{ HKSampleSortIdentifierEndDate : @NO } completion:^(NSArray<HKCategorySample *> *samples) {
		if (completion)
			completion(samples.firstObject);
	}];
}



+ (HKObserverQuery *)observeSamplesWithPredicate:(NSPredicate *)predicate updateHandler:(void(^)(HKObserverQuery *, HKObserverQueryCompletionHandler, NSError *))updateHandler {
	return [[HKHealthStore defaultStore] observeSamplesWithIdentifier:[self identifier] predicate:predicate updateHandler:updateHandler];
}
/*
+ (HKObserverQuery *)observeSamplesWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate updateHandler:(void(^)(HKObserverQuery *, HKObserverQueryCompletionHandler, NSError *))updateHandler {
	return [self observeSamplesWithPredicate:[HKQuery predicateForSamplesWithDate:startDate date:endDate] updateHandler:updateHandler];
}
*/
+ (HKObserverQuery *)observeSamplesWithPredicate:(NSPredicate *)predicate limit:(NSUInteger)limit sort:(NSDictionary<NSString *, NSNumber *> *)sort updateHandler:(void(^)(NSArray<__kindof HKSample *> *samples))updateHandler {
	return [self observeSamplesWithPredicate:predicate updateHandler:^(HKObserverQuery *query, HKObserverQueryCompletionHandler completionHandler, NSError *error) {
		[[HKHealthStore defaultStore] querySamplesWithIdentifier:[self identifier] predicate:predicate limit:limit sort:sort completion:^(NSArray *samples) {
			if (updateHandler)
				updateHandler(samples);

			if (completionHandler)
				completionHandler();
		}];

		[error log:@"observeSamplesWithPredicate:"];
	}];
}

+ (HKObserverQuery *)observeSamplesWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate options:(HKQueryOptions)options limit:(NSUInteger)limit sort:(NSDictionary<NSString *, NSNumber *> *)sort updateHandler:(void (^)(NSArray<__kindof HKSample *> *))updateHandler {
	return [self observeSamplesWithPredicate:[HKQuery predicateForSamplesWithDate:startDate date:endDate options:options] limit:limit sort:sort updateHandler:updateHandler];
}

+ (HKObserverQuery *)observeSamplesWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate updateHandler:(void (^)(NSArray<__kindof HKSample *> *))updateHandler {
	return [self observeSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone limit:HKObjectQueryNoLimit sort:@{ HKSampleSortIdentifierEndDate : @NO } updateHandler:updateHandler];
}

+ (HKObserverQuery *)observeSampleWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate updateHandler:(void (^)(__kindof HKSample *))updateHandler {
	return [self observeSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone limit:1 sort:@{ HKSampleSortIdentifierEndDate : @NO } updateHandler:^(NSArray<HKCategorySample *> *samples) {
		if (updateHandler)
			updateHandler(samples.firstObject);
	}];
}

@end

@implementation HKHeartRate

+ (NSString *)identifier {
	return HKQuantityTypeIdentifierHeartRate;
}

@end

@implementation HKSleepAnalysis

+ (NSString *)identifier {
	return HKCategoryTypeIdentifierSleepAnalysis;
}



+ (HKCategorySample *)sampleWithStartDate:(NSDate *)start endDate:(NSDate *)end value:(HKCategoryValueSleepAnalysis)value metadata:(NSDictionary *)metadata {
	return [[HKHealthStore defaultStore] categotySampleWithIdentifier:[self identifier] value:value startDate:start endDate:end metadata:metadata];
}



+ (BOOL)saveSampleWithStartDate:(NSDate *)start endDate:(NSDate *)end value:(HKCategoryValueSleepAnalysis)value metadata:(NSDictionary *)metadata completion:(void (^)(BOOL))completion {
	return [[HKHealthStore defaultStore] saveCategorySampleWithIdentifier:[self identifier] value:value startDate:start endDate:end metadata:metadata completion:completion];
}

+ (BOOL)saveSampleWithStartDate:(NSDate *)start endDate:(NSDate *)end value:(HKCategoryValueSleepAnalysis)value metadata:(NSDictionary *)metadata {
	return [[HKHealthStore defaultStore] saveCategorySampleWithIdentifier:[self identifier] value:value startDate:start endDate:end metadata:metadata completion:Nil];
}

@end

@implementation HKStepCount

+ (NSString *)identifier {
	return HKQuantityTypeIdentifierStepCount;
}

@end

@implementation HKActiveEnergy

+ (NSString *)identifier {
	return HKQuantityTypeIdentifierActiveEnergyBurned;
}

@end

@implementation HKBasalEnergy

+ (NSString *)identifier {
	return HKQuantityTypeIdentifierBasalEnergyBurned;
}

@end

@implementation HKObject (Convenience)

- (NSString *)sourceBundleIdentifier {
	return [self respondsToSelector:@selector(sourceRevision)] ? self.sourceRevision.source.bundleIdentifier : [[self performSelector:@selector(source)] bundleIdentifier];
}

- (NSString *)sourceName {
	return [self respondsToSelector:@selector(sourceRevision)] ? self.sourceRevision.source.name : [[self performSelector:@selector(source)] name];
}

- (NSString *)sourceVersion {
	return [self respondsToSelector:@selector(sourceRevision)] ? self.sourceRevision.version : Nil;
}

- (BOOL)isOwn {
	return !self.sourceBundleIdentifier || [self.sourceBundleIdentifier isEqualToString:[NSBundle mainBundle].bundleIdentifier];
}

@end

@implementation HKSample (Convenience)

- (NSTimeInterval)duration {
	return [self.endDate timeIntervalSinceDate:self.startDate];
}

@end

@implementation HKQuantitySample (Convenience)

- (double)doubleValueForUnit:(HKUnit *)unit {
	return [self.quantity doubleValueForUnit:unit];
}

static HKUnit *_count;

- (double)count {
	if (!_count)
		_count = [HKUnit countUnit];

	return [self doubleValueForUnit:_count];
}

static HKUnit *_countPerMinute;

- (double)countPerMinute {
	if (!_countPerMinute)
		_countPerMinute = [[HKUnit countUnit] unitDividedByUnit:[HKUnit minuteUnit]];

	return [self doubleValueForUnit:_countPerMinute];
}

static HKUnit *_calorie;

- (double)calorie {
	if (!_calorie)
		_calorie = [HKUnit calorieUnit];

	return [self doubleValueForUnit:_calorie];
}

static HKUnit *_kilocalorie;

- (double)kilocalorie {
	if (!_kilocalorie)
		_kilocalorie = [HKUnit kilocalorieUnit];

	return [self doubleValueForUnit:_kilocalorie];
}

@end

@implementation HKQuery (Convenience)

+ (NSPredicate *)predicateForSamplesWithDate:(NSDate *)date1 date:(NSDate *)date2 options:(HKQueryOptions)options {
	BOOL reverse = date1 && date2 && date1.timeIntervalSinceReferenceDate > date2.timeIntervalSinceReferenceDate;
	return [HKQuery predicateForSamplesWithStartDate:reverse ? date2 : date1 endDate:reverse ? date1 : date2 options:options];
}

+ (NSPredicate *)predicateForSamplesWithDate:(NSDate *)date1 date:(NSDate *)date2 {
	return [self predicateForSamplesWithDate:date1 date:date2 options:HKQueryOptionNone];
}

@end
