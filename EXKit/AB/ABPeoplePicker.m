//
//  ABPeoplePicker.m
//  Done!
//
//  Created by Alexander Ivanov on 10.08.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "ABHelper.h"
#import "ABPeoplePicker.h"
#import "NSObject+Convenience.h"
#import "UIView+Convenience.h"

@interface ABPeoplePicker ()
@property (copy, nonatomic) ABPeoplePickerCompletion completion;
@end

@implementation ABPeoplePicker

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
	return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
	[self pushPersonViewController:person];
	
	return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
	return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
	[self cancel:peoplePicker];
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person {
	if (!self.completion)
		return;
	
	self.completion(person, YES);
}

- (void)pushPersonViewController:(ABRecordRef)person {
	if (!person)
		return;
	
	ABPersonViewController *vc = [[ABPersonViewController alloc] init];
	
	vc.allowsEditing = NO;
	vc.displayedPerson = person;
	vc.personViewDelegate = self;
	
	if (VER(8, 0)) {
		vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(change:)];
		vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancel:)];
	} else {
		vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
	}
	
	[self pushViewController:vc animated:YES];
}

- (IBAction)change:(id)sender {
	if (!self.completion)
		return;

	self.completion(Nil, YES);
}

- (IBAction)cancel:(id)sender {
	if (!self.completion)
		return;
	
	self.completion(Nil, NO);
}

- (IBAction)done:(id)sender {
	if (!self.completion)
		return;
	
	ABPersonViewController *vc = cls(ABPersonViewController, self.topViewController);
	self.completion(vc.displayedPerson, YES);
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (motion == UIEventSubtypeMotionShake)
		[self cancel:self];
}

+ (instancetype)create:(ABPeoplePickerCompletion)completion withPerson:(ABRecordRef)person {
	ABPeoplePicker *instance = [[ABPeoplePicker alloc] init];
	instance.peoplePickerDelegate = instance;
	
	instance.completion = completion;
	
	[instance pushPersonViewController:person];
	
	return instance;
}

+ (instancetype)create:(ABPeoplePickerCompletion)completion withPersonID:(NSInteger)recordID {
	return [self create:completion withPerson:[ABHelper getPersonWithRecordID:recordID]];
}

@end
