//
//  ABPersonViewController+Convenience.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 23.06.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@import AddressBookUI;

@interface ABPersonViewController (Convenience)

- (instancetype)initWithPerson:(ABRecordRef)person;
- (instancetype)initWithPersonID:(NSInteger)personID orPersonName:(NSString *)name;
- (instancetype)initWithPersonName:(NSString *)name orPersonID:(NSInteger)personID;

@end
