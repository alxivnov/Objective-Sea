//
//  ContactsUI+Convenience.h
//  vCard
//
//  Created by Alexander Ivanov on 07.04.2018.
//  Copyright © 2018 Alexander Ivanov. All rights reserved.
//

#import <ContactsUI/ContactsUI.h>

#import "NSObject+Convenience.h"

@interface CNContact (Convenience)

@property (strong, nonatomic, readonly) NSString *fullName;
@property (strong, nonatomic, readonly) NSString *phoneticFullName;

@property (strong, nonatomic, readonly) UIImage *image;
@property (strong, nonatomic, readonly) UIImage *thumbnailImage;

@end

@interface CNContactVCardSerialization (Convenience)

+ (NSArray<CNContact *> *)contactsWithData:(NSData *)data;

+ (NSData *)dataWithContacts:(NSArray<CNContact *> *)contacts;

@end

@interface UIViewController (ContactsUI)

- (CNContactPickerViewController *)presentContactPickerWithCompletion:(void (^)(CNContact *contact))completion;

@end
