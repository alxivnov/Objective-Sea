//
//  CloudKit+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 19.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <CloudKit/CloudKit.h>

#import "NSDictionary+Convenience.h"
#import "NSObject+Convenience.h"
#import "NSString+Convenience.h"

#define CKDefaultOwnerRecordName @"__defaultOwner__"

@interface CKContainer (Convenience)

- (void)fetchUserRecordID:(void (^)(CKRecordID *recordID))completionHandler;

//- (CKModifyBadgeOperation *)modifyBadge:(NSUInteger)badgeValue completionHandler:(void (^)(BOOL success))completionHandler;

- (CKFetchRecordsOperation *)fetchCurrentUserRecord:(void(^)(CKRecord *record))completionHandler;

@end

@interface CKNotification (Convenience)

- (NSString *)alertLocalization;

@property (assign, nonatomic, readonly) BOOL hasAlert;

@end

#define CKNotificationInfoSoundNameDefault @"default"

@interface CKNotificationInfo (Convenience)

- (BOOL)hasAlert;

@end

@interface CKRecord (Comnvenience)

- (NSDictionary *)allKeyValuePairs;

@end

@interface CKReference (Convenience)

- (instancetype)initWithRecord:(CKRecord *)record;
- (instancetype)initWithRecordID:(CKRecordID *)recordID;

@end

#define KEY_RECORD_ID @"recordID"
#define KEY_CREATOR_USER_RECORD_ID @"creatorUserRecordID"
#define KEY_LAST_MODIFIED_USER_RECORD_ID @"lastModifiedUserRecordID"

#define KEY_CREATION_DATE @"creationDate"
#define KEY_MODIFICATION_DATE @"modificationDate"

@interface NSPredicate (Convenience)

+ (NSPredicate *)truePredicate;
+ (NSPredicate *)falsePredicate;

+ (NSPredicate *)predicateWithKeys:(NSDictionary<NSString *, __kindof id <CKRecordValue>> *)keys;
+ (NSPredicate *)predicateWithKey:(NSString *)key value:(__kindof id <CKRecordValue>)value;
+ (NSPredicate *)predicateWithKey:(NSString *)key values:(NSArray<__kindof id <CKRecordValue>> *)values;

+ (NSPredicate *)predicateWithRecordID:(CKRecordID *)recordID;
+ (NSPredicate *)predicateWithCreatorUserRecordID:(CKRecordID *)recordID;
+ (NSPredicate *)predicateWithCreatorUserRecordIDs:(NSArray<CKRecordID *> *)recordIDs;

+ (NSPredicate *)predicateWithKey:(NSString *)key greaterThan:(__kindof id <CKRecordValue>)value;
+ (NSPredicate *)predicateWithKey:(NSString *)key lessThan:(__kindof id <CKRecordValue>)value;

+ (NSPredicate *)predicateWithCreationDateGreaterThan:(NSDate *)date;
+ (NSPredicate *)predicateWithCreationDateLessThan:(NSDate *)date;
+ (NSPredicate *)predicateWithModificationDateGreaterThan:(NSDate *)date;
+ (NSPredicate *)predicateWithModificationDateLessThan:(NSDate *)date;

- (NSPredicate *)notPredicate;

@end
