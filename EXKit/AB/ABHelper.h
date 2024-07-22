//
//  ABHelper.h
//  Done!
//
//  Created by Alexander Ivanov on 03.08.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

@import AddressBook;

@interface ABHelper : NSObject

+ (NSString *)getCompositeName:(ABRecordRef)record;

+ (NSString *)getCompositeNameByRecordID:(NSInteger)recordID;

+ (ABRecordRef)getPersonWithRecordID:(NSInteger)recordID;

+ (NSArray *)getPeopleWithName:(NSString *)name;

+ (NSInteger)getRecordID:(ABRecordRef)record;

+ (BOOL)isAuthorized;

+ (void)requestAuthorization:(ABAddressBookRequestAccessCompletionHandler)completion forAddressBook:(ABAddressBookRef)addressBook;
+ (void)requestAuthorization:(ABAddressBookRequestAccessCompletionHandler)completion;

@end
