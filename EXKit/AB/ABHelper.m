//
//  ABHelper.m
//  Done!
//
//  Created by Alexander Ivanov on 03.08.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ABHelper.h"

@implementation ABHelper

static ABAddressBookRef _addressBook;

+ (ABAddressBookRef)addressBook {
	CFErrorRef error = NULL;
	
	@synchronized(self) {
		if (!_addressBook)
			_addressBook = ABAddressBookCreateWithOptions(NULL, &error);
	}
	
	if (error)
		CFRelease(error);
	
	return _addressBook;
}

+ (NSString *)getFirstName:(ABRecordRef)record {
	return (__bridge_transfer NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty);
}

+ (NSString *)getLastName:(ABRecordRef)record {
	return (__bridge_transfer NSString *)ABRecordCopyValue(record, kABPersonLastNameProperty);
}

+ (NSString *)getCompositeNameDelimiter:(ABRecordRef)record {
	return (__bridge_transfer NSString *)ABPersonCopyCompositeNameDelimiterForRecord(record);
}

+ (BOOL)getCompositeNameFormat:(ABRecordRef)record {
	return ABPersonGetCompositeNameFormatForRecord(record) == kABPersonCompositeNameFormatFirstNameFirst;
}

+ (NSString *)getCompositeName:(ABRecordRef)record {
	return (__bridge_transfer NSString *)ABRecordCopyCompositeName(record);
}

+ (NSString *)getCompositeNameByRecordID:(NSInteger)recordID {
	return [ABHelper getCompositeName:[ABHelper getPersonWithRecordID:recordID]];
}

+ (ABRecordRef)getPersonWithRecordID:(NSInteger)recordID {
	return recordID >= 0 ? ABAddressBookGetPersonWithRecordID([self addressBook], (ABRecordID)recordID) : Nil;
}

+ (NSArray *)getPeopleWithName:(NSString *)name {
	return name.length ? (__bridge_transfer NSArray *)ABAddressBookCopyPeopleWithName([self addressBook], (__bridge CFStringRef)(name)) : Nil;
}

+ (NSInteger)getRecordID:(ABRecordRef)record {
	return ABRecordGetRecordID(record);
}

+ (BOOL)isAuthorized {
	return ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized;
}

+ (void)requestAuthorization:(ABAddressBookRequestAccessCompletionHandler)completion forAddressBook:(ABAddressBookRef)addressBook {
	ABAddressBookRequestAccessWithCompletion(addressBook ? addressBook : [self addressBook], completion);
}

+ (void)requestAuthorization:(ABAddressBookRequestAccessCompletionHandler)completion {
	[self requestAuthorization:completion forAddressBook:Nil];
}

@end
