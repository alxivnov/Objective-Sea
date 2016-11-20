//
//  CKDatabase+Convenience.m
//  Ringo
//
//  Created by Alexander Ivanov on 27.06.15.
//  Copyright (c) 2015 Alexander Ivanov. All rights reserved.
//

#import "CKDatabase+Convenience.h"

@implementation CKDatabase (Convenience)

- (void)saveRecordWithType:(NSString *)type name:(NSString *)name fields:(NSDictionary *)fields completionHandler:(void (^)(CKRecord *, NSError *))completionHandler {
	CKRecordID *ID = [[CKRecordID alloc] initWithRecordName:name];
	CKRecord *record = [[CKRecord alloc] initWithRecordType:type recordID:ID];
	for (NSString *key in fields)
		[record setObject:fields[key] forKey:key];
	
	[self saveRecord:record completionHandler:completionHandler];
}

- (void)deleteRecordWithName:(NSString *)name completionHandler:(void (^)(CKRecordID *, NSError *))completionHandler {
	CKRecordID *ID = [[CKRecordID alloc] initWithRecordName:name];
	
	[self deleteRecordWithID:ID completionHandler:completionHandler];
}

- (void)startOperation:(CKDatabaseOperation *)operation allowsCellularAccess:(BOOL)allowsCellularAccess {
	operation.allowsCellularAccess = allowsCellularAccess;
	if (allowsCellularAccess)
		operation.qualityOfService = NSQualityOfServiceUserInitiated;
	operation.database = self;
	[operation start];
}

- (CKModifyRecordsOperation *)deleteRecords:(NSArray<CKRecord *> *)records completionHandler:(void (^)(NSArray<CKRecord *> *, NSArray<CKRecordID *> *, NSError *))completionHandler {
	if (!records.count)
		return Nil;
	
	NSArray<CKRecordID *> *recordIDs = [records map:^id(CKRecord *obj) {
		return obj.recordID;
	}];
	
	CKModifyRecordsOperation *operation = [[CKModifyRecordsOperation alloc] initWithRecordsToSave:Nil recordIDsToDelete:recordIDs];
	operation.modifyRecordsCompletionBlock = completionHandler;
	[self startOperation:operation allowsCellularAccess:YES];
	
	return operation;
}

- (CKModifyRecordsOperation *)updateRecords:(NSArray<CKRecord *> *)records completionHandler:(void (^)(NSArray<CKRecord *> *, NSArray<CKRecordID *> *, NSError *))completionHandler {
	if (!records.count)
		return Nil;
	
	CKModifyRecordsOperation *operation = [[CKModifyRecordsOperation alloc] initWithRecordsToSave:records recordIDsToDelete:Nil];
	operation.modifyRecordsCompletionBlock = completionHandler;
	[self startOperation:operation allowsCellularAccess:YES];
	
	return operation;
}

- (CKModifyRecordsOperation *)deleteRecord:(CKRecord *)record completionHandler:(void (^)(NSArray<CKRecord *> *, NSArray<CKRecordID *> *, NSError *))completionHandler {
	return [self deleteRecords:arr_(record) completionHandler:completionHandler];
}

- (CKModifyRecordsOperation *)updateRecord:(CKRecord *)record completionHandler:(void (^)(NSArray<CKRecord *> *, NSArray<CKRecordID *> *, NSError *))completionHandler {
	return [self updateRecords:arr_(record) completionHandler:completionHandler];
}

- (CKModifySubscriptionsOperation *)saveSubscriptions:(NSArray<CKSubscription *> *)subscriptionsToSave deleteSubscriptionsWithIDs:(NSArray<NSString *> *)subscriptionIDsToDelete completionHandler:(void (^)(NSArray<CKSubscription *> *savedSubscriptions, NSArray<NSString *> *deletedSubscriptionIDs, NSError *operationError))completionHandler {
	if (!subscriptionsToSave.count && !subscriptionIDsToDelete.count)
		return Nil;

	CKModifySubscriptionsOperation *operation = [[CKModifySubscriptionsOperation alloc] initWithSubscriptionsToSave:subscriptionIDsToDelete.count ? Nil : subscriptionsToSave subscriptionIDsToDelete:subscriptionIDsToDelete];
	operation.modifySubscriptionsCompletionBlock = subscriptionsToSave.count && subscriptionIDsToDelete.count ? ^(NSArray<CKSubscription *> * savedSubscriptions, NSArray<NSString *> * deletedSubscriptionIDs, NSError * operationError) {
		CKModifySubscriptionsOperation *operation = [[CKModifySubscriptionsOperation alloc] initWithSubscriptionsToSave:subscriptionsToSave subscriptionIDsToDelete:Nil];
		operation.modifySubscriptionsCompletionBlock = ^(NSArray<CKSubscription *> * savedSubscriptions, NSArray<NSString *> * _deletedSubscriptionIDs, NSError * operationError) {
			if (completionHandler)
				completionHandler(savedSubscriptions, deletedSubscriptionIDs, operationError);

			[operationError log:@"saveSubscriptions:"];
		};
		[self startOperation:operation allowsCellularAccess:YES];

		[operationError log:@"deleteSubscriptions:"];
	} : ^(NSArray<CKSubscription *> * savedSubscriptions, NSArray<NSString *> * deletedSubscriptionIDs, NSError * operationError) {
		if (completionHandler)
			completionHandler(savedSubscriptions, deletedSubscriptionIDs, operationError);

		[operationError log:@"modifySubscriptions:"];
	};
	[self startOperation:operation allowsCellularAccess:YES];

	return operation;
}

- (CKModifySubscriptionsOperation *)saveSubscriptions:(NSArray<CKSubscription *> *)subscriptions completionHandler:(void (^)(NSArray<CKSubscription *> *, NSArray<NSString *> *, NSError *))completionHandler {
	return [self saveSubscriptions:subscriptions deleteSubscriptionsWithIDs:Nil completionHandler:completionHandler];
}

- (CKModifySubscriptionsOperation *)saveSubscriptions:(NSArray<CKSubscription *> *)subscriptions {
	return [self saveSubscriptions:subscriptions completionHandler:^(NSArray<CKSubscription *> *savedSubscriptions, NSArray<NSString *> *deletedSubscriptionIDs, NSError *operationError) {
		[operationError log:@"saveSubscriptions:"];
	}];
}

- (CKModifySubscriptionsOperation *)saveSubscription:(CKSubscription *)subscription {
	return [self saveSubscriptions:arr_(subscription)];
}

- (CKModifySubscriptionsOperation *)deleteSubscriptionsWithIDs:(NSArray<NSString *> *)subscriptionIDs completionHandler:(void (^)(NSArray <CKSubscription *> *, NSArray <NSString *> *, NSError *))completionHandler {
	return [self saveSubscriptions:Nil deleteSubscriptionsWithIDs:subscriptionIDs completionHandler:completionHandler];
}

- (CKModifySubscriptionsOperation *)deleteSubscriptionsWithIDs:(NSArray<NSString *> *)subscriptionIDs {
	return [self deleteSubscriptionsWithIDs:subscriptionIDs completionHandler:^(NSArray<CKSubscription *> *savedSubscriptions, NSArray<NSString *> *deletedSubscriptionIDs, NSError *operationError) {
		[operationError log:@"deleteSubscriptionsWithIDs:"];
	}];
}

- (CKModifySubscriptionsOperation *)deleteSubscriptionWithID:(NSString *)subscriptionID {
	return [self deleteSubscriptionsWithIDs:arr_(subscriptionID)];
}

- (CKFetchSubscriptionsOperation *)fetchSubscriptionsWithIDs:(NSArray<NSString *> *)subscriptionIDs completionHandler:(void (^)(NSDictionary <NSString *, CKSubscription *> *, NSError *))completionHandler {
	CKFetchSubscriptionsOperation *operation = subscriptionIDs ? [[CKFetchSubscriptionsOperation alloc] initWithSubscriptionIDs:subscriptionIDs] : [CKFetchSubscriptionsOperation fetchAllSubscriptionsOperation];
	operation.fetchSubscriptionCompletionBlock = completionHandler;
	[self startOperation:operation allowsCellularAccess:YES];
	
	return operation;
}

- (CKFetchSubscriptionsOperation *)modifySubscriptions:(NSArray<CKSubscription *> *)subscriptions completionHandler:(void (^)(NSArray<CKSubscription *> *, NSArray<NSString *> *))completionHandler {
	return [self fetchSubscriptionsWithIDs:Nil completionHandler:^(NSDictionary<NSString *,CKSubscription *> *subscriptionsBySubscriptionID, NSError *operationError) {
		NSArray<CKSubscription *> *subscriptionsToSave = [subscriptions query:^BOOL(CKSubscription *obj) {
			return subscriptionsBySubscriptionID[obj.subscriptionID] == Nil;
		}];
		NSArray<NSString *> *subscriptionIDsToDelete = [subscriptionsBySubscriptionID.allKeys query:^BOOL(NSString *subscriptionID) {
			return ![subscriptions any:^BOOL(CKSubscription *subscription) {
				return [subscription.subscriptionID isEqualToString:subscriptionID];
			}];
		}];

		[self saveSubscriptions:subscriptionsToSave deleteSubscriptionsWithIDs:subscriptionIDsToDelete completionHandler:^(NSArray<CKSubscription *> *savedSubscriptions, NSArray<NSString *> *deletedSubscriptionIDs, NSError *operationError) {
			if (completionHandler)
				completionHandler(savedSubscriptions, deletedSubscriptionIDs);
		}];

		[operationError log:@"fetchSubscriptionsWithIDs:"];
	}];
}

- (CKFetchSubscriptionsOperation *)modifySubscriptions:(NSArray<CKSubscription *> *)subscriptions {
	return [self modifySubscriptions:subscriptions completionHandler:Nil];
}

- (CKFetchSubscriptionsOperation *)modifyAllSubscriptions:(NSArray<CKSubscription *> *)subscriptions completionHandler:(void (^)(NSArray<CKSubscription *> *, NSArray<NSString *> *))completionHandler {
	return [self fetchSubscriptionsWithIDs:Nil completionHandler:^(NSDictionary<NSString *,CKSubscription *> *subscriptionsBySubscriptionID, NSError *operationError) {
		[self saveSubscriptions:subscriptions deleteSubscriptionsWithIDs:subscriptionsBySubscriptionID.allKeys completionHandler:^(NSArray<CKSubscription *> *savedSubscriptions, NSArray<NSString *> *deletedSubscriptionIDs, NSError *operationError) {
			if (completionHandler)
				completionHandler(savedSubscriptions, deletedSubscriptionIDs);
		}];

		[operationError log:@"fetchSubscriptionsWithIDs:"];
	}];
}

- (CKFetchSubscriptionsOperation *)modifyAllSubscriptions:(NSArray<CKSubscription *> *)subscriptions {
	return [self modifyAllSubscriptions:subscriptions completionHandler:Nil];
}

@end
