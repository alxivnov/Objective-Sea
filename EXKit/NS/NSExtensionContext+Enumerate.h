//
//  NSExtensionContext+Enumerate.h
//  Guardian
//
//  Created by Alexander Ivanov on 20.04.15.
//  Copyright (c) 2015 NATEK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSArray+Convenience.h"
#import "NSObject+Convenience.h"

@interface NSExtensionContext (Enumerate)

- (void)enumerateItemsForTypeIdentifiers:(NSArray *)identifiers block:(void(^)(id item, NSString *identifier))block count:(NSUInteger)count;
- (void)enumerateItemsForTypeIdentifiers:(NSArray *)identifiers block:(void(^)(id item, NSString *identifier))block;
- (void)firstItemForTypeIdentifiers:(NSArray *)identifiers block:(void(^)(id item, NSString *identifier))block;

- (void)enumerateItemsForTypeIdentifier:(NSString *)identifier block:(void(^)(id item))block count:(NSUInteger)count;
- (void)enumerateItemsForTypeIdentifier:(NSString *)identifier block:(void(^)(id item))block;
- (void)firstItemForTypeIdentifier:(NSString *)identifier block:(void(^)(id item))block;

@end
