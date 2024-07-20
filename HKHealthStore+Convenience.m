//
//  HKHealthStore+Convenience.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 18.04.15.
//  Copyright (c) 2015 Alexander Ivanov. All rights reserved.
//

#import "HKHealthStore+Convenience.h"

@implementation HKObjectType (Convenience)

+ (HKObjectType *)typeForIdentifier:(NSString *)identifier {
	return [identifier hasPrefix:@"HKQuantityTypeIdentifier"] ? [HKObjectType quantityTypeForIdentifier:identifier]
		: [identifier hasPrefix:@"HKCategoryTypeIdentifier"] ? [HKObjectType categoryTypeForIdentifier:identifier]
		: [identifier hasPrefix:@"HKCharacteristicTypeIdentifier"] ? [HKObjectType characteristicTypeForIdentifier:identifier]
		: [identifier hasPrefix:@"HKCorrelationTypeIdentifier"] ? [HKObjectType correlationTypeForIdentifier:identifier]
		: [identifier hasPrefix:@"HKDocumentTypeIdentifier"] ? [HKObjectType documentTypeForIdentifier:identifier]
		: [identifier isEqualToString:HKWorkoutRouteTypeIdentifier] || [identifier isEqualToString:HKDataTypeIdentifierHeartbeatSeries] ? [HKObjectType seriesTypeForIdentifier:identifier]
	: /*[identifier hasPrefix:@"HKWorkoutTypeIdentifier"] ?*/ [HKObjectType workoutType];
//		: [identifier hasPrefix:@""] ? [HKObjectType activitySummaryType]
//		: [identifier hasPrefix:@""] ? [HKObjectType audiogramSampleType]
//		: [identifier hasPrefix:@""] ? [HKObjectType electrocardiogramType]
//		: Nil;
}

@end

@implementation HKHeartbeatSeriesSample (Convenience)

- (HKHeartbeatSeriesQuery *)queryHeartbeats:(void (^)(NSArray *))completion {
	__block NSMutableArray *beats = [[NSMutableArray alloc] initWithCapacity:self.count];
	__block NSTimeInterval previousBeat = 0.0;
	HKHeartbeatSeriesQuery* query = [[HKHeartbeatSeriesQuery alloc] initWithHeartbeatSeries:self dataHandler:^(HKHeartbeatSeriesQuery * _Nonnull query, NSTimeInterval timeSinceSeriesStart, BOOL precededByGap, BOOL done, NSError * _Nullable error) {
		[error log:@"initWithHeartbeatSeries"];

		NSTimeInterval beat = timeSinceSeriesStart - previousBeat;
		[beats addObject:@(precededByGap ? -beat : beat)];

		previousBeat = timeSinceSeriesStart;

		if (done)
			if (completion)
				completion(beats);
	}];
	[[HKHealthStore defaultStore] executeQuery:query];
	return query;
}

- (HKHeartbeatSeriesQuery *)queryRMSSD:(void (^)(double))completion {
	return [self queryHeartbeats:^(NSArray *heartbeats) {
		double sum = 0.0;
		double len = 0.0;

		for (NSUInteger index = 1; index < heartbeats.count; index++) {
			double prev = [heartbeats[index - 1] doubleValue] * 1000.0;
			double curr = [heartbeats[index] doubleValue] * 1000.0;

			// Skip calculating differences with beats preceded by gap
			if (prev < 0.0 || curr < 0.0)
				continue;

			sum += pow(prev - curr, 2.0);
			len += 1.0;
		}

		// RMSSD
		double rmssd = sqrt(sum / len);

		if (completion)
			completion(rmssd);
	}];
}

@end

@implementation HKHealthStore (Convenience)

__static(HKHealthStore *, defaultStore, [HKHealthStore isHealthDataAvailable] ? [HKHealthStore new] : Nil)

- (BOOL)saveObject:(HKObject *)object completion:(void(^)(BOOL success))completion {
	if (!object)
		return NO;
	
	[self saveObject:object withCompletion:^(BOOL success, NSError *error) {
		[error log:@"saveObject:"];

		if (completion)
			completion(success);
	}];

	return YES;
}

- (BOOL)saveObjects:(NSArray *)objects completion:(void(^)(BOOL success))completion {
	if (!objects.count)
		return NO;
	
	[self saveObjects:objects withCompletion:^(BOOL success, NSError *error) {
		[error log:@"saveObjects:"];

		if (completion)
			completion(success);
	}];

	return YES;
}

- (BOOL)deleteObject:(HKObject *)object completion:(void(^)(BOOL success))completion {
	if (!object)
		return NO;
	
	[self deleteObject:object withCompletion:^(BOOL success, NSError *error) {
		[error log:@"deleteObject:"];

		if (completion)
			completion(success);
	}];

	return YES;
}

- (BOOL)deleteObjects:(NSArray<HKObject *> *)objects completion:(void (^)(BOOL))completion {
	if (!objects.count)
		return NO;

	[self deleteObjects:objects withCompletion:^(BOOL success, NSError *error) {
		[error log:@"deleteObjects:"];

		if (completion)
			completion(success);
	}];

	return YES;
}

- (HKAuthorizationStatus)authorizationStatusForIdentifier:(NSString *)identifier {
	id type = [HKObjectType typeForIdentifier:identifier];

	return [self authorizationStatusForType:type];
}

- (HKAuthorizationStatus)authorizationStatusForIdentifiers:(NSArray<NSString *> *)identifiers {
	HKAuthorizationStatus status = HKAuthorizationStatusSharingAuthorized;
	for (NSString *identifier in identifiers)
		status = MIN(status, [self authorizationStatusForIdentifier:identifier]);
	return status;
}

- (NSNumber *)isAuthorized:(NSArray<NSString *> *)identifiers {
	HKAuthorizationStatus status = [self authorizationStatusForIdentifiers:identifiers];
	return status == HKAuthorizationStatusSharingAuthorized ? @YES : status == HKAuthorizationStatusSharingDenied ? @NO : Nil;
}

- (void)requestAuthorizationToShare:(NSArray<NSString *> *)shareIdentifiers read:(NSArray<NSString *> *)readIdentifiers completion:(void (^)(BOOL))completion {
	NSSet *share = shareIdentifiers ? [NSSet setWithArray:[shareIdentifiers map:^id(NSString *obj) {
		return [HKObjectType typeForIdentifier:obj];
	}]] : Nil;
	NSSet *read = readIdentifiers ? [NSSet setWithArray:[readIdentifiers map:^id(NSString *obj) {
		return [HKObjectType typeForIdentifier:obj];
	}]] : Nil;

	[self requestAuthorizationToShareTypes:share readTypes:read completion:^(BOOL success, NSError *error) {
		[error log:@"requestAuthorizationToShareTypes:"];

		if (completion)
			completion(success);
	}];
}

- (void)requestAuthorization:(NSString *)identifier share:(BOOL)share read:(BOOL)read completion:(void (^)(BOOL))completion {
	[self requestAuthorizationToShare:share ? arr_(identifier) : Nil read:read ? arr_(identifier) : Nil completion:completion];
}

- (HKCategorySample *)categotySampleWithIdentifier:(NSString *)identifier value:(NSInteger)value startDate:(NSDate *)startDate endDate:(NSDate *)endDate metadata:(NSDictionary *)metadata {
	if (!startDate || !endDate)
		return Nil;

	id type = [HKObjectType typeForIdentifier:identifier];

	BOOL reverse = startDate.timeIntervalSinceReferenceDate > endDate.timeIntervalSinceReferenceDate;
	HKCategorySample *sample = [HKCategorySample categorySampleWithType:type value:value startDate:reverse ? endDate : startDate endDate:reverse ? startDate : endDate metadata:metadata];
	
	return sample;
}

- (HKQuantitySample *)quantitySampleWithIdentifier:(NSString *)identifier quantity:(HKQuantity *)quantity startDate:(NSDate *)startDate endDate:(NSDate *)endDate metadata:(NSDictionary *)metadata {
	if (!startDate || !endDate)
		return Nil;

	id type = [HKObjectType typeForIdentifier:identifier];

	BOOL reverse = startDate.timeIntervalSinceReferenceDate > endDate.timeIntervalSinceReferenceDate;
	HKQuantitySample *sample = [HKQuantitySample quantitySampleWithType:type quantity:quantity startDate:reverse ? endDate : startDate endDate:reverse ? startDate : endDate metadata:metadata];
	
	return sample;
}

- (BOOL)saveCategorySampleWithIdentifier:(NSString *)identifier value:(NSInteger)value startDate:(NSDate *)startDate endDate:(NSDate *)endDate metadata:(NSDictionary *)metadata completion:(void (^)(BOOL))completion {
	HKCategorySample *sample = [self categotySampleWithIdentifier:identifier value:value startDate:startDate endDate:endDate metadata:metadata];
	
	return [self saveObject:sample completion:completion];
}

- (BOOL)saveQuantitySampleWithIdentifier:(NSString *)identifier quantity:(HKQuantity *)quantity startDate:(NSDate *)startDate endDate:(NSDate *)endDate metadata:(NSDictionary *)metadata completion:(void (^)(BOOL))completion {
	HKQuantitySample *sample = [self quantitySampleWithIdentifier:identifier quantity:quantity startDate:startDate endDate:endDate metadata:metadata];
	
	return [self saveObject:sample completion:completion];
}

- (HKSampleQuery *)querySamplesWithIdentifier:(NSString *)identifier predicate:(NSPredicate *)predicate limit:(NSUInteger)limit sort:(NSDictionary<NSString *, NSNumber *> *)sort completion:(void(^)(NSArray *samples))completion {
	if (!completion)
		return Nil;

	id type = [HKObjectType typeForIdentifier:identifier];

	NSMutableArray<NSSortDescriptor *> *sortDescriptors = [NSMutableArray arrayWithCapacity:sort.count];
	for (NSString *key in sort.allKeys)
		[sortDescriptors addObject:[NSSortDescriptor sortDescriptorWithKey:key ascending:[sort[key] boolValue]]];

	HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:type predicate:predicate limit:limit sortDescriptors:sortDescriptors resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
		completion(results);
		
		[error log:@"initWithSampleType:"];
	}];
//	[[[self class] defaultStore] executeQuery:query];
	[self executeQuery:query];
	
	return query;
}

- (HKSampleQuery *)querySamplesWithIdentifier:(NSString *)identifier predicate:(NSPredicate *)predicate limit:(NSUInteger)limit completion:(void(^)(NSArray *samples))completion {
	return [self querySamplesWithIdentifier:identifier predicate:predicate limit:limit sort:Nil completion:completion];
}

- (HKSampleQuery *)querySampleWithIdentifier:(NSString *)identifier predicate:(NSPredicate *)predicate sort:(NSDictionary<NSString *, NSNumber *> *)sort completion:(void(^)(NSArray *samples))completion {
	return [self querySamplesWithIdentifier:identifier predicate:predicate limit:HKObjectQueryNoLimit sort:sort completion:completion];
}

- (HKSampleQuery *)querySamplesWithIdentifier:(NSString *)identifier predicate:(NSPredicate *)predicate completion:(void(^)(NSArray *samples))completion {
	return [self querySamplesWithIdentifier:identifier predicate:predicate limit:HKObjectQueryNoLimit sort:Nil completion:completion];
}

- (HKObserverQuery *)observeSamplesWithIdentifier:(NSString *)identifier predicate:(NSPredicate *)predicate updateHandler:(void(^)(HKObserverQuery *, HKObserverQueryCompletionHandler, NSError *))updateHandler {
	id type = [HKObjectType typeForIdentifier:identifier];
	
	HKObserverQuery *query = [[HKObserverQuery alloc] initWithSampleType:type predicate:predicate updateHandler:updateHandler];
//	[[[self class] defaultStore] executeQuery:query];
	[self executeQuery:query];
	
	return query;
}

@end
