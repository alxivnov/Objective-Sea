//
//  CKDatabase+Convenience.h
//  Ringo
//
//  Created by Alexander Ivanov on 27.06.15.
//  Copyright (c) 2015 Alexander Ivanov. All rights reserved.
//

#import <CloudKit/CloudKit.h>

#import "NSArray+Convenience.h"
#import "NSObject+Convenience.h"

@interface CKDatabase (Convenience)

//- (void)saveRecordWithType:(NSString *)type name:(NSString *)name fields:(NSDictionary *)fields completionHandler:(void (^)(CKRecord *record, NSError *error))completionHandler;
//- (void)deleteRecordWithName:(NSString *)name completionHandler:(void (^)(CKRecordID * recordID, NSError * error))completionHandler;

- (CKModifyRecordsOperation *)deleteRecords:(NSArray<CKRecord *> *)records completionHandler:(void (^)(NSArray<CKRecord *> *savedRecords, NSArray<CKRecordID *> *deletedRecordIDs, NSError *operationError))completionHandler;
- (CKModifyRecordsOperation *)updateRecords:(NSArray<CKRecord *> *)records completionHandler:(void (^)(NSArray<CKRecord *> *savedRecords, NSArray<CKRecordID *> *deletedRecordIDs, NSError *operationError))completionHandler;

- (CKModifyRecordsOperation *)deleteRecord:(CKRecord *)record completionHandler:(void (^)(NSArray<CKRecord *> *savedRecords, NSArray<CKRecordID *> *deletedRecordIDs, NSError *operationError))completionHandler;
- (CKModifyRecordsOperation *)updateRecord:(CKRecord *)record completionHandler:(void (^)(NSArray<CKRecord *> *savedRecords, NSArray<CKRecordID *> *deletedRecordIDs, NSError *operationError))completionHandler;

- (CKModifySubscriptionsOperation *)saveSubscriptions:(NSArray<CKSubscription *> *)subscriptions completionHandler:(void (^)(NSArray <CKSubscription *> *savedSubscriptions, NSArray <NSString *> *deletedSubscriptionIDs, NSError *operationError))completionHandler;
- (CKModifySubscriptionsOperation *)saveSubscriptions:(NSArray<CKSubscription *> *)subscriptions;
- (CKModifySubscriptionsOperation *)saveSubscription:(CKSubscription *)subscription;

- (CKModifySubscriptionsOperation *)deleteSubscriptionsWithIDs:(NSArray<NSString *> *)subscriptionIDs completionHandler:(void (^)(NSArray <CKSubscription *> *savedSubscriptions, NSArray <NSString *> *deletedSubscriptionIDs, NSError *operationError))completionHandler;
- (CKModifySubscriptionsOperation *)deleteSubscriptionsWithIDs:(NSArray<NSString *> *)subscriptionIDs;
- (CKModifySubscriptionsOperation *)deleteSubscriptionWithID:(NSString *)subscriptionID;

- (CKFetchSubscriptionsOperation *)fetchSubscriptionsWithIDs:(NSArray<NSString *> *)subscriptionIDs completionHandler:(void (^)(NSDictionary <NSString *, CKSubscription *> * subscriptionsBySubscriptionID, NSError * operationError))completionHandler;

- (CKFetchSubscriptionsOperation *)modifySubscriptions:(NSArray<CKSubscription *> *)subscriptions completionHandler:(void (^)(NSArray<CKSubscription *> *savedSubscriptions, NSArray<NSString *> *deletedSubscriptionIDs))completionHandler;
- (CKFetchSubscriptionsOperation *)modifySubscriptions:(NSArray<CKSubscription *> *)subscriptions;

- (CKFetchSubscriptionsOperation *)modifyAllSubscriptions:(NSArray<CKSubscription *> *)subscriptions completionHandler:(void (^)(NSArray<CKSubscription *> *savedSubscriptions, NSArray<NSString *> *deletedSubscriptionIDs))completionHandler;
- (CKFetchSubscriptionsOperation *)modifyAllSubscriptions:(NSArray<CKSubscription *> *)subscriptions;

@end
