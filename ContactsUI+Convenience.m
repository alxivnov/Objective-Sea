//
//  ContactsUI+Convenience.m
//  vCard
//
//  Created by Alexander Ivanov on 07.04.2018.
//  Copyright © 2018 Alexander Ivanov. All rights reserved.
//

#import "ContactsUI+Convenience.h"

@implementation CNContactStore (Convenience)

__static(CNContactStore *, defaultStore, [[CNContactStore alloc] init])

+ (CNAuthorizationStatus)authorizationStatus {
	return [self authorizationStatusForEntityType:CNEntityTypeContacts];
}

- (void)requestAccess:(void (^)(BOOL))completionHandler {
	[self requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
		if (completionHandler)
			completionHandler(granted);

		[error log:@"requestAccessForEntityType:"];
	}];
}

- (BOOL)enumerateContactsWithKeysToFetch:(NSArray <id<CNKeyDescriptor>>*)keysToFetch usingBlock:(BOOL (^)(CNContact *))block {
	if (!block)
		return NO;

	CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
	NSError *error = Nil;
	BOOL result = [self enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact *contact, BOOL *stop) {
		BOOL result = block(contact);
		
		*stop = result;
	}];
	[error log:@"enumerateContactsWithFetchRequest:"];
	return result;
}

@end

@implementation CNContact (Convenience)

- (NSString *)fullName {
	return [CNContactFormatter stringFromContact:self style:CNContactFormatterStyleFullName];
}

- (NSString *)phoneticFullName {
	return [CNContactFormatter stringFromContact:self style:CNContactFormatterStylePhoneticFullName];
}

- (UIImage *)image {
	return self.imageData ? [UIImage imageWithData:self.imageData] : Nil;
}

- (UIImage *)thumbnailImage {
	return self.imageData ? [UIImage imageWithData:self.thumbnailImageData] : Nil;
}

- (CNSocialProfile *)socialProfileWithService:(NSString *)service {
	return service ? [self.socialProfiles firstObject:^BOOL(CNLabeledValue<CNSocialProfile *> *obj) {
		return [obj.value.service isEqualToString:service];
	}].value : Nil;
}

- (CNInstantMessageAddress *)instantMessageAddressWithService:(NSString *)service {
	return service ? [self.instantMessageAddresses firstObject:^BOOL(CNLabeledValue<CNInstantMessageAddress *> *obj) {
		return [obj.value.service isEqualToString:service];
	}].value : Nil;
}

@end

@implementation CNContactVCardSerialization (Convenience)

+ (NSArray<CNContact *> *)contactsWithData:(NSData *)data {
	if (!data)
		return Nil;

	NSError *error = Nil;
	NSArray<CNContact *> *contacts = [self contactsWithData:data error:&error];
	[error log:@"dataWithContacts:"];
	return contacts;
}

+ (NSData *)dataWithContacts:(NSArray<CNContact *> *)contacts {
	if (!contacts)
		return Nil;

	NSError *error = Nil;
	NSData *data = [self dataWithContacts:contacts error:&error];
	[error log:@"dataWithContacts:"];
	return data;
}

@end

@implementation CNSocialProfile (Convenience)

+ (instancetype)facebookProfileWithUsername:(NSString *)username {
	return [[CNSocialProfile alloc] initWithUrlString:[NSString stringWithFormat:@"http://www.facebook.com/%@", username] username:username userIdentifier:Nil service:CNSocialProfileServiceFacebook];
}

+ (instancetype)flickrProfileWithUsername:(NSString *)username {
	return [[CNSocialProfile alloc] initWithUrlString:[NSString stringWithFormat:@"http://www.flickr.com/photos/%@", username] username:username userIdentifier:Nil service:CNSocialProfileServiceFlickr];
}

+ (instancetype)linkedInProfileWithUsername:(NSString *)username {
	return [[CNSocialProfile alloc] initWithUrlString:[NSString stringWithFormat:@"http://www.linkedin.com/in/%@", username] username:username userIdentifier:Nil service:CNSocialProfileServiceLinkedIn];
}

+ (instancetype)twitterProfileWithUsername:(NSString *)username {
	return [[CNSocialProfile alloc] initWithUrlString:[NSString stringWithFormat:@"http://twitter.com/%@", username] username:username userIdentifier:Nil service:CNSocialProfileServiceTwitter];
}

- (NSURL *)url {
	return [NSURL URLWithString:self.urlString];
}

@end

@implementation NSArray (CNLabeledValue)

- (NSArray *)allLabeled:(NSString *)label {
	return [self query:^BOOL(id obj) {
		return [obj isKindOfClass:[CNLabeledValue class]] ? [((CNLabeledValue *)obj).label isEqualToString:label] : NO;
	}];
}

- (id)firstLabeled:(NSString *)label {
	return [self firstObject:^BOOL(id obj) {
		return [obj isKindOfClass:[CNLabeledValue class]] ? [((CNLabeledValue *)obj).label isEqualToString:label] : NO;
	}];
}

@end


@interface CNContactNavigationController : UINavigationController <CNContactViewControllerDelegate>
@property (strong, nonatomic, readonly) CNContactViewController *contactViewController;
@end

@implementation CNContactNavigationController

- (CNContactViewController *)contactViewController {
	return self.viewControllers.firstObject;
}

+ (instancetype)viewControllerForUnknownContact:(CNContact *)contact {
	CNContactViewController *vc = [CNContactViewController viewControllerForUnknownContact:contact];

	CNContactNavigationController *nav = [[CNContactNavigationController alloc] initWithRootViewController:vc];

	vc.delegate = nav;

	vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nav action:@selector(done:)];

	return nav;
}

- (IBAction)done:(UIBarButtonItem *)sender {
	[self dismissViewControllerAnimated:YES completion:Nil];
}

- (BOOL)contactViewController:(CNContactViewController *)viewController shouldPerformDefaultActionForContactProperty:(CNContactProperty *)property {
	return YES;
}

- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(nullable CNContact *)contact {
	[viewController.navigationController dismissViewControllerAnimated:YES completion:Nil];
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

- (CNContactViewController *)presentUnknownContact:(CNContact *)contact store:(CNContactStore *)contactStore {
	if (!contact)
		return Nil;

	CNContactNavigationController *vc = [CNContactNavigationController viewControllerForUnknownContact:contact];
	vc.contactViewController.contactStore = contactStore;

	[self presentViewController:vc animated:YES completion:Nil];

	return vc.contactViewController;
}

@end
