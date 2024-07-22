//
//  ABPersonViewController+Convenience.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 23.06.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "ABHelper.h"
#import "ABPersonViewController+Convenience.h"

@implementation ABPersonViewController (Convenience)

- (instancetype)initWithPerson:(ABRecordRef)person {
	self = [super init];
	
	if (self)
		self.displayedPerson = person;
	
	return self;
}

- (instancetype)initWithPersonID:(NSInteger)personID orPersonName:(NSString *)name {
	ABRecordRef person = [ABHelper getPersonWithRecordID:personID];
	if (!person)
		person = (__bridge ABRecordRef)([ABHelper getPeopleWithName:name].firstObject);
	
	return [self initWithPerson:person];
}

- (instancetype)initWithPersonName:(NSString *)name orPersonID:(NSInteger)personID {
	ABRecordRef person = (__bridge ABRecordRef)[ABHelper getPeopleWithName:name].firstObject;
	if (!person)
		person = [ABHelper getPersonWithRecordID:personID];
	
	return [self initWithPerson:person];
}

@end
