//
//  CKObject.h
//  Ringo
//
//  Created by Alexander Ivanov on 27.06.15.
//  Copyright (c) 2015 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CKDatabase+Convenience.h"
#import "CloudKit+Convenience.h"

@import CloudKit;

@protocol CKObjectBase <NSObject>

- (instancetype)initWithRecordFields:(NSDictionary *)recordFields;
- (NSDictionary *)recordFields;

@optional

- (NSString *)recordName;
- (NSString *)recordType;

- (void)load:(void(^)())completion;

@end

@interface CKObjectBase : NSObject <CKObjectBase>

@property (strong, nonatomic, readonly) CKRecord *record;

- (instancetype)initWithRecord:(CKRecord *)record;

//- (void)save:(CKDatabase *)database;
//- (void)save;

- (CKModifyRecordsOperation *)remove:(CKDatabase *)database completion:(void (^)(NSString *deletedRecordName))completion;
- (CKModifyRecordsOperation *)remove:(void (^)(NSString *deletedRecordName))completion;

- (CKModifyRecordsOperation *)update:(CKDatabase *)database completion:(void (^)(__kindof CKObjectBase *savedObject))completion;
- (CKModifyRecordsOperation *)update:(void (^)(__kindof CKObjectBase *savedObject))completion;

- (CKReference *)reference:(CKReferenceAction)action;
- (CKReference *)reference;

+ (CKQueryOperation *)fetch:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors resultsLimit:(NSUInteger)resultsLimit allowsCellularAccess:(BOOL)allowsCellularAccess database:(CKDatabase *)database completion:(void(^)(CKRecord *record))completion;
+ (CKQueryOperation *)fetch:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors resultsLimit:(NSUInteger)resultsLimit allowsCellularAccess:(BOOL)allowsCellularAccess completion:(void(^)(CKRecord *record))completion;
+ (CKQueryOperation *)fetch:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors resultsLimit:(NSUInteger)resultsLimit completion:(void(^)(CKRecord *record))completion;
+ (CKQueryOperation *)fetch:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors completion:(void(^)(CKRecord *record))completion;
+ (CKQueryOperation *)fetch:(NSPredicate *)predicate completion:(void(^)(CKRecord *record))completion;

+ (CKQueryOperation *)query:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors resultsLimit:(NSUInteger)resultsLimit allowsCellularAccess:(BOOL)allowsCellularAccess database:(CKDatabase *)database completion:(void(^)(NSArray<__kindof CKObjectBase *> *results))completion;
+ (CKQueryOperation *)query:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors resultsLimit:(NSUInteger)resultsLimit allowsCellularAccess:(BOOL)allowsCellularAccess completion:(void(^)(NSArray<__kindof CKObjectBase *> *results))completion;
+ (CKQueryOperation *)query:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors resultsLimit:(NSUInteger)resultsLimit completion:(void(^)(NSArray<__kindof CKObjectBase *> *results))completion;
+ (CKQueryOperation *)query:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors completion:(void(^)(NSArray<__kindof CKObjectBase *> *results))completion;
+ (CKQueryOperation *)query:(NSPredicate *)predicate completion:(void(^)(NSArray<__kindof CKObjectBase *> *results))completion;

+ (CKQueryOperation *)findByRecordID:(CKRecordID *)recordID allowsCellularAccess:(BOOL)allowsCellularAccess completion:(void(^)(__kindof CKObjectBase *result))completion;
+ (CKQueryOperation *)findByRecordID:(CKRecordID *)recordID completion:(void(^)(__kindof CKObjectBase *result))completion;
+ (CKQueryOperation *)loadByRecordID:(CKRecordID *)recordID allowsCellularAccess:(BOOL)allowsCellularAccess completion:(void(^)(__kindof CKObjectBase *result))completion;
+ (CKQueryOperation *)loadByRecordID:(CKRecordID *)recordID completion:(void(^)(__kindof CKObjectBase *result))completion;

+ (CKSubscription *)subscriptionWithPredicate:(NSPredicate *)predicate ID:(NSString *)ID options:(CKQuerySubscriptionOptions)options notificationInfo:(CKNotificationInfo *)notificationInfo;

+ (CKSubscription *)saveSubscriptionWithPredicate:(NSPredicate *)predicate options:(CKQuerySubscriptionOptions)options database:(CKDatabase *)database notificationInfo:(CKNotificationInfo *)notificationInfo;
+ (CKSubscription *)saveSubscriptionWithPredicate:(NSPredicate *)predicate options:(CKQuerySubscriptionOptions)options notificationInfo:(CKNotificationInfo *)notificationInfo;

@end
