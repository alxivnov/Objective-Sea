//
//  ContactsUI+Convenience.h
//  vCard
//
//  Created by Alexander Ivanov on 07.04.2018.
//  Copyright © 2018 Alexander Ivanov. All rights reserved.
//

#import <ContactsUI/ContactsUI.h>

#import "NSArray+Convenience.h"
#import "NSObject+Convenience.h"

@interface CNContactStore (Convenience)

+ (instancetype)defaultStore;

+ (CNAuthorizationStatus)authorizationStatus;

- (void)requestAccess:(void (^)(BOOL granted))completionHandler;

- (BOOL)enumerateContactsWithKeysToFetch:(NSArray <id<CNKeyDescriptor>>*)keysToFetch usingBlock:(BOOL (^)(CNContact *contact))block;

@end

@interface CNContact (Convenience)

@property (strong, nonatomic, readonly) NSString *fullName;
@property (strong, nonatomic, readonly) NSString *phoneticFullName;

@property (strong, nonatomic, readonly) UIImage *image;
@property (strong, nonatomic, readonly) UIImage *thumbnailImage;

- (CNSocialProfile *)socialProfileWithService:(NSString *)service;
- (CNInstantMessageAddress *)instantMessageAddressWithService:(NSString *)service;

@end

@interface CNContactVCardSerialization (Convenience)

+ (NSArray<CNContact *> *)contactsWithData:(NSData *)data;

+ (NSData *)dataWithContacts:(NSArray<CNContact *> *)contacts;

@end

@interface CNSocialProfile (Convenience)

+ (instancetype)facebookProfileWithUsername:(NSString *)username;
+ (instancetype)flickrProfileWithUsername:(NSString *)username;
+ (instancetype)linkedInProfileWithUsername:(NSString *)username;
+ (instancetype)twitterProfileWithUsername:(NSString *)username;

@property (strong, nonatomic, readonly) NSURL *url;

@end

@interface NSArray<ObjectType> (CNLabeledValue)

- (NSArray<ObjectType> *)allLabeled:(NSString *)label;
- (ObjectType)firstLabeled:(NSString *)label;

@end


@interface UIViewController (ContactsUI)

- (CNContactPickerViewController *)presentContactPickerWithCompletion:(void (^)(CNContact *contact))completion;

- (CNContactViewController *)presentUnknownContact:(CNContact *)contact store:(CNContactStore *)contactStore;

@end
