//
//  ABPeoplePicker.h
//  Done!
//
//  Created by Alexander Ivanov on 10.08.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

@import AddressBookUI;

typedef void (^ABPeoplePickerCompletion)(ABRecordRef person, BOOL completed);

@interface ABPeoplePicker : ABPeoplePickerNavigationController <ABPersonViewControllerDelegate, ABPeoplePickerNavigationControllerDelegate>

//+ (instancetype)create:(ABPeoplePickerCompletion)completion withPerson:(ABRecordRef)person;

+ (instancetype)create:(ABPeoplePickerCompletion)completion withPersonID:(NSInteger)recordID;

@end
