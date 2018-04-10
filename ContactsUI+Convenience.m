//
//  ContactsUI+Convenience.m
//  vCard
//
//  Created by Alexander Ivanov on 07.04.2018.
//  Copyright © 2018 Alexander Ivanov. All rights reserved.
//

#import "ContactsUI+Convenience.h"

@implementation CNContact (Convenience)

- (NSString *)fullName {
	return [CNContactFormatter stringFromContact:self style:CNContactFormatterStyleFullName];
}

- (NSString *)phoneticFullName {
	return [CNContactFormatter stringFromContact:self style:CNContactFormatterStylePhoneticFullName];
}

@end

@interface CNContactPickerViewControllerEx : CNContactPickerViewController <CNContactPickerDelegate>
@property void (^completion)(CNContact *);
@end

@implementation CNContactPickerViewControllerEx

- (instancetype)init {
	self = [super init];

	if (self) {
		self.delegate = self;
	}

	return self;
}

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker {
	if (self.completion)
		self.completion(Nil);

	[picker dismissViewControllerAnimated:YES completion:Nil];
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
	if (self.completion)
		self.completion(contact);

	[picker dismissViewControllerAnimated:YES completion:Nil];
}

@end

@implementation UIViewController (ContactsUI)

- (CNContactPickerViewController *)presentContactPickerWithCompletion:(void (^)(CNContact *))completion {
	CNContactPickerViewControllerEx *picker = [[CNContactPickerViewControllerEx alloc] init];
	picker.completion = completion;

	[self presentViewController:picker animated:YES completion:Nil];

	return picker;
}

@end
