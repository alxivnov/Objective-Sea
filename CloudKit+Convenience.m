//
//  CloudKit+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 19.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "CloudKit+Convenience.h"

@implementation CKContainer (Convenience)

- (void)fetchUserRecordID:(void (^)(CKRecordID *))completionHandler {
	[self fetchUserRecordIDWithCompletionHandler:^(CKRecordID * _Nullable recordID, NSError * _Nullable error) {
		if (completionHandler)
			completionHandler(recordID);

		[error log:@"fetchUserRecordIDWithCompletionHandler:"];
	}];
}

- (void)startOperation:(CKOperation *)operation allowsCellularAccess:(BOOL)allowsCellularAccess {
//	operation.allowsCellularAccess = allowsCellularAccess;
//	operation.container = self;
	[operation start];
}

//- (CKModifyBadgeOperation *)modifyBadge:(NSUInteger)badgeValue completionHandler:(void (^)(BOOL success))completionHandler {
//	CKModifyBadgeOperation *operation = [[CKModifyBadgeOperation alloc] initWithBadgeValue:badgeValue];
//	operation.modifyBadgeCompletionBlock = ^(NSError *operationError) {
//		if (completionHandler)
//			completionHandler(operationError == Nil);
//
//		[operationError log:@"modifyBadge:"];
//	};
//	[self startOperation:operation allowsCellularAccess:YES];
//
//	return operation;
//}

- (CKFetchRecordsOperation *)fetchCurrentUserRecord:(void(^)(CKRecord *record))completionHandler {
	CKFetchRecordsOperation *operation = [CKFetchRecordsOperation fetchCurrentUserRecordOperation];
	operation.fetchRecordsCompletionBlock = ^(NSDictionary<CKRecordID *,CKRecord *> *recordsByRecordID, NSError *operationError) {
		if (completionHandler)
			completionHandler(recordsByRecordID.allValues.firstObject);

		[operationError log:@"fetchCurrentUserRecord:"];
	};
	[self startOperation:operation allowsCellularAccess:YES];

	return operation;
}

@end

@implementation CKNotification (Convenience)

- (NSString *)alertLocalization {
	return self.alertLocalizationKey && self.alertLocalizationArgs ? [NSString stringWithFormat:self.alertLocalizationKey arguments:self.alertLocalizationArgs] : self.alertBody;
}

- (BOOL)hasAlert {
	return self.alertBody.length || self.alertLocalizationKey.length;
}

@end

@implementation CKNotificationInfo (Convenience)

- (BOOL)hasAlert {
	return self.alertBody.length || self.alertLocalizationKey.length;
}

@end

@implementation CKRecord (Comnvenience)

- (NSDictionary *)allKeyValuePairs {
	NSArray *keys = [self allKeys];

	NSMutableDictionary *pairs = [NSMutableDictionary dictionaryWithCapacity:keys.count];

	for (NSString *key in keys)
		pairs[key] = self[key];

	return pairs;
}

@end

@implementation CKReference (Convenience)

- (instancetype)initWithRecord:(CKRecord *)record {
	return [self initWithRecord:record action:CKReferenceActionNone];
}

- (instancetype)initWithRecordID:(CKRecordID *)recordID {
	return [self initWithRecordID:recordID action:CKReferenceActionNone];
}

@end

#define KEY_EQUALS_TO @"%K == %@"
#define KEY_IS_IN @"%K IN %@"
#define KEY_GREATER_THAN @"%K > %@"
#define KEY_LESS_THAN @"%K < %@"

@implementation NSPredicate (Convenience)

+ (NSPredicate *)truePredicate {
	return [self predicateWithValue:YES];
}

+ (NSPredicate *)falsePredicate {
	return [self predicateWithValue:NO];
}

+ (NSPredicate *)predicateWithKeys:(NSDictionary<NSString *, __kindof id <CKRecordValue>> *)keys {
	NSString *format = [[NSArray arrayWithObject:KEY_EQUALS_TO count:keys.count] componentsJoinedByString:@" AND "];
	NSArray *array = [keys array];

	return [self predicateWithFormat:format argumentArray:array];
}

+ (NSPredicate *)predicateWithKey:(NSString *)key value:(__kindof id <CKRecordValue>)value {
	return [self predicateWithKeys:@{ key : value }];
}

+ (NSPredicate *)predicateWithKey:(NSString *)key values:(NSArray<__kindof id<CKRecordValue>> *)values {
	return [self predicateWithFormat:KEY_IS_IN, key, values];
}

+ (NSPredicate *)predicateWithRecordID:(CKRecordID *)recordID {
	return recordID ? [self predicateWithKeys:@{ KEY_RECORD_ID : [[CKReference alloc] initWithRecordID:recordID] }] : Nil;
}

+ (NSPredicate *)predicateWithCreatorUserRecordID:(CKRecordID *)recordID {
	return recordID ? [self predicateWithKey:KEY_CREATOR_USER_RECORD_ID value:[[CKReference alloc] initWithRecordID:recordID]] : Nil;
}

+ (NSPredicate *)predicateWithCreatorUserRecordIDs:(NSArray<CKRecordID *> *)recordIDs {
	return recordIDs.count ? [self predicateWithKey:KEY_CREATOR_USER_RECORD_ID values:[recordIDs map:^id(CKRecordID *obj) {
		return [[CKReference alloc] initWithRecordID:obj];
	}]] : Nil;
}

+ (NSPredicate *)predicateWithKey:(NSString *)key greaterThan:(__kindof id <CKRecordValue>)value {
	return [self predicateWithFormat:KEY_GREATER_THAN, key, value];
}

+ (NSPredicate *)predicateWithKey:(NSString *)key lessThan:(__kindof id <CKRecordValue>)value {
	return [self predicateWithFormat:KEY_LESS_THAN, key, value];
}

+ (NSPredicate *)predicateWithCreationDateGreaterThan:(NSDate *)date {
	return [self predicateWithKey:KEY_CREATION_DATE greaterThan:date ? date : [NSDate date]];
}

+ (NSPredicate *)predicateWithCreationDateLessThan:(NSDate *)date {
	return [self predicateWithKey:KEY_CREATION_DATE lessThan:date ? date : [NSDate date]];
}

+ (NSPredicate *)predicateWithModificationDateGreaterThan:(NSDate *)date {
	return [self predicateWithKey:KEY_MODIFICATION_DATE greaterThan:date ? date : [NSDate date]];
}

+ (NSPredicate *)predicateWithModificationDateLessThan:(NSDate *)date {
	return [self predicateWithKey:KEY_MODIFICATION_DATE lessThan:date ? date : [NSDate date]];
}

- (NSPredicate *)notPredicate {
	return [NSCompoundPredicate notPredicateWithSubpredicate:self];
}

@end
