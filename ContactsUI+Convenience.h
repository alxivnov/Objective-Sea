//
//  ContactsUI+Convenience.h
//  vCard
//
//  Created by Alexander Ivanov on 07.04.2018.
//  Copyright © 2018 Alexander Ivanov. All rights reserved.
//

#import <ContactsUI/ContactsUI.h>

@interface CNContact (Convenience)

@property (strong, nonatomic, readonly) NSString *fullName;
@property (strong, nonatomic, readonly) NSString *phoneticFullName;

@end

@interface UIViewController (ContactsUI)

- (CNContactPickerViewController *)presentContactPickerWithCompletion:(void (^)(CNContact *contact))completion;

@end
