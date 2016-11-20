//
//  CKObject.m
//  Ringo
//
//  Created by Alexander Ivanov on 27.06.15.
//  Copyright (c) 2015 Alexander Ivanov. All rights reserved.
//

#import "CKObjectBase.h"

@interface CKObjectBase ()
@property (strong, nonatomic) CKRecord *record;
@end

@implementation CKObjectBase

- (instancetype)initWithRecordFields:(NSDictionary *)fields {
	return [super init];
}

- (NSDictionary *)recordFields {
	return Nil;
}

- (NSString *)recordName {
	return Nil;
}

- (NSString *)recordType {
	return [[self class] description];
}

- (void)load:(void (^)())completion {
	if (completion)
		completion();
}

- (instancetype)initWithRecord:(CKRecord *)record {
	self = [self initWithRecordFields:[record allKeyValuePairs]];
	
	if (self)
		self.record = record;
	
	return self;
}

- (CKRecord *)record {
	if (!_record)
		_record = [self recordName] ? [[CKRecord alloc] initWithRecordType:[self recordType] recordID:[[CKRecordID alloc] initWithRecordName:[self recordName]]] : [[CKRecord alloc] initWithRecordType:[self recordType]];
	
	return _record;
}

- (void)updateRecord {
	NSDictionary *fields = [self recordFields];
	for (NSString *key in fields)
		[self.record setObject:fields[key] forKey:key];
}

- (void)save:(CKDatabase *)database {
	if (!database)
		database = [[CKContainer defaultContainer] publicCloudDatabase];
	
	[self updateRecord];
	[database saveRecord:self.record completionHandler:^(CKRecord *record, NSError *error) {
		[error log:@"saveRecord:"];
	}];
}

- (void)save {
	[self save:Nil];
}

- (CKModifyRecordsOperation *)remove:(CKDatabase *)database completion:(void (^)(NSString *))completion {
	if (!database)
		database = [[CKContainer defaultContainer] publicCloudDatabase];
	
	return [database deleteRecord:self.record completionHandler:^(NSArray<CKRecord *> *savedRecords, NSArray<CKRecordID *> *deletedRecordIDs, NSError *operationError) {
		[operationError log:@"deleteRecord:"];

		if (completion)
			completion(deletedRecordIDs.firstObject.recordName);
	}];
}

- (CKModifyRecordsOperation *)remove:(void (^)(NSString *))completion {
	return [self remove:Nil completion:completion];
}

- (CKModifyRecordsOperation *)update:(CKDatabase *)database completion:(void (^)(__kindof CKObjectBase *))completion {
	if (!database)
		database = [[CKContainer defaultContainer] publicCloudDatabase];
	
	[self updateRecord];
	return [database updateRecord:self.record completionHandler:^(NSArray<CKRecord *> *savedRecords, NSArray<CKRecordID *> *deletedrecordIDs, NSError *operationError) {
		[operationError log:@"updateRecord"];

		if (completion)
			completion([[[self class] alloc] initWithRecord:savedRecords.firstObject]);
	}];
}

- (CKModifyRecordsOperation *)update:(void (^)(__kindof CKObjectBase *))completion {
	return [self update:Nil completion:completion];
}

- (CKReference *)reference:(CKReferenceAction)action {
	return [[CKReference alloc] initWithRecord:[self record] action:action];
}

- (CKReference *)reference {
	return [self reference:CKReferenceActionNone];
}

+ (CKQueryOperation *)fetch:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors resultsLimit:(NSUInteger)resultsLimit allowsCellularAccess:(BOOL)allowsCellularAccess database:(CKDatabase *)database completion:(void(^)(CKRecord *record))completion {
	if (!database)
		database = [[CKContainer defaultContainer] publicCloudDatabase];

	if (!predicate)
		predicate = [NSPredicate truePredicate];

	CKObjectBase *base = [self new];
	CKQuery *query = [[CKQuery alloc] initWithRecordType:[base recordType] predicate:predicate];
	if (sortDescriptors)
		query.sortDescriptors = sortDescriptors;
	CKQueryOperation *operation = [[CKQueryOperation alloc] initWithQuery:query];
	operation.allowsCellularAccess = allowsCellularAccess;
	if (allowsCellularAccess)
		operation.qualityOfService = NSQualityOfServiceUserInitiated;
	operation.recordFetchedBlock = ^(CKRecord *record) {
		if (completion)
			completion(record);
	};
	operation.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error) {
		if (completion)
			completion(Nil);

		[error log:@"queryCompletionBlock:"];
	};
	if (resultsLimit)
		operation.resultsLimit = resultsLimit;
	[database addOperation:operation];

	return operation;
}

+ (CKQueryOperation *)fetch:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors resultsLimit:(NSUInteger)resultsLimit allowsCellularAccess:(BOOL)allowsCellularAccess completion:(void(^)(CKRecord *record))completion {
	return [self fetch:predicate sortDescriptors:sortDescriptors resultsLimit:resultsLimit allowsCellularAccess:allowsCellularAccess database:Nil completion:completion];
}

+ (CKQueryOperation *)fetch:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors resultsLimit:(NSUInteger)resultsLimit completion:(void(^)(CKRecord *record))completion {
	return [self fetch:predicate sortDescriptors:sortDescriptors resultsLimit:resultsLimit allowsCellularAccess:YES database:Nil completion:completion];
}

+ (CKQueryOperation *)fetch:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors completion:(void(^)(CKRecord *record))completion {
	return [self fetch:predicate sortDescriptors:sortDescriptors resultsLimit:0 allowsCellularAccess:YES database:Nil completion:completion];
}

+ (CKQueryOperation *)fetch:(NSPredicate *)predicate completion:(void(^)(CKRecord *record))completion {
	return [self fetch:predicate sortDescriptors:Nil resultsLimit:0 allowsCellularAccess:YES database:Nil completion:completion];
}

+ (CKQueryOperation *)query:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors resultsLimit:(NSUInteger)resultsLimit allowsCellularAccess:(BOOL)allowsCellularAccess database:(CKDatabase *)database completion:(void(^)(NSArray<__kindof CKObjectBase *> *results))completion {
	__block NSMutableArray<__kindof CKObjectBase *> *results = [self conformsToProtocol:@protocol(CKObjectBase)] ? [NSMutableArray new] : Nil;

	return results ? [self fetch:predicate sortDescriptors:sortDescriptors resultsLimit:resultsLimit allowsCellularAccess:allowsCellularAccess database:database completion:^(CKRecord *record) {
		if (record)
			[results addObject:[[self alloc] initWithRecord:record]];
		else if (completion)
			completion(results);
	}] : Nil;
}

+ (CKQueryOperation *)query:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors resultsLimit:(NSUInteger)resultsLimit allowsCellularAccess:(BOOL)allowsCellularAccess completion:(void(^)(NSArray<__kindof CKObjectBase *> *results))completion {
	return [self query:predicate sortDescriptors:sortDescriptors resultsLimit:resultsLimit allowsCellularAccess:allowsCellularAccess database:Nil completion:completion];
}

+ (CKQueryOperation *)query:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors resultsLimit:(NSUInteger)resultsLimit completion:(void(^)(NSArray<__kindof CKObjectBase *> *results))completion {
	return [self query:predicate sortDescriptors:sortDescriptors resultsLimit:resultsLimit allowsCellularAccess:YES database:Nil completion:completion];
}

+ (CKQueryOperation *)query:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors completion:(void(^)(NSArray<__kindof CKObjectBase *> *results))completion {
	return [self query:predicate sortDescriptors:sortDescriptors resultsLimit:0 allowsCellularAccess:YES database:Nil completion:completion];
}

+ (CKQueryOperation *)query:(NSPredicate *)predicate completion:(void(^)(NSArray<__kindof CKObjectBase *> *results))completion {
	return [self query:predicate sortDescriptors:Nil resultsLimit:0 allowsCellularAccess:YES database:Nil completion:completion];
}

+ (CKQueryOperation *)findByRecordID:(CKRecordID *)recordID allowsCellularAccess:(BOOL)allowsCellularAccess completion:(void(^)(__kindof CKObjectBase *result))completion {
	return completion ? [self query:[NSPredicate predicateWithRecordID:recordID] sortDescriptors:Nil resultsLimit:0 allowsCellularAccess:allowsCellularAccess completion:^(NSArray<__kindof CKObjectBase *> *results) {
		completion(results.firstObject);
	}] : Nil;
}

+ (CKQueryOperation *)findByRecordID:(CKRecordID *)recordID completion:(void (^)(__kindof CKObjectBase *))completion {
	return [self findByRecordID:recordID allowsCellularAccess:YES completion:completion];
}

+ (CKQueryOperation *)loadByRecordID:(CKRecordID *)recordID allowsCellularAccess:(BOOL)allowsCellularAccess completion:(void(^)(__kindof CKObjectBase *result))completion {
	return completion ? [self findByRecordID:recordID allowsCellularAccess:allowsCellularAccess completion:^(__kindof CKObjectBase *result) {
		if (result)
			[result load:^{
				completion(result);
			}];
		else
			completion(result);
	}] : Nil;
}

+ (CKQueryOperation *)loadByRecordID:(CKRecordID *)recordID completion:(void (^)(__kindof CKObjectBase *))completion {
	return [self loadByRecordID:recordID allowsCellularAccess:YES completion:completion];
}

+ (CKSubscription *)subscriptionWithPredicate:(NSPredicate *)predicate ID:(NSString *)ID options:(CKQuerySubscriptionOptions)options notificationInfo:(CKNotificationInfo *)notificationInfo {
	if (!predicate)
		predicate = [NSPredicate truePredicate];
	if (!options)
		options = CKQuerySubscriptionOptionsFiresOnRecordCreation | CKQuerySubscriptionOptionsFiresOnRecordDeletion | CKQuerySubscriptionOptionsFiresOnRecordUpdate;

	NSString *recordType = [[self new] recordType];
//	NSString *subscriptionID = [NSString stringWithFormat:@"%@+%@+%@", recordType, predicate , @(options)];

	CKQuerySubscription *subscription = [[CKQuerySubscription alloc] initWithRecordType:recordType predicate:predicate subscriptionID:ID options:options];
	subscription.notificationInfo = notificationInfo;

//	subscription.zoneID = Nil;

	return subscription;
}

+ (CKSubscription *)saveSubscriptionWithPredicate:(NSPredicate *)predicate options:(CKQuerySubscriptionOptions)options database:(CKDatabase *)database notificationInfo:(CKNotificationInfo *)notificationInfo {
	if (!database)
		database = [[CKContainer defaultContainer] publicCloudDatabase];

	CKSubscription *subscription = [self subscriptionWithPredicate:predicate ID:Nil options:options notificationInfo:notificationInfo];

	[database saveSubscription:subscription];

	return subscription;
}

+ (CKSubscription *)saveSubscriptionWithPredicate:(NSPredicate *)predicate options:(CKQuerySubscriptionOptions)options notificationInfo:(CKNotificationInfo *)notificationInfo {
	return [self saveSubscriptionWithPredicate:predicate options:options database:Nil notificationInfo:notificationInfo];
}

@end
