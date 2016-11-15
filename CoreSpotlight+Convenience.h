//
//  CoreSpotlight+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 15.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <CoreSpotlight/CoreSpotlight.h>

#import "NSObject+Convenience.h"
#import "NSArray+Convenience.h"

@interface CSSearchableIndex (Convenience)

- (void)indexSearchableItems:(NSArray<CSSearchableItem *> *)items;
- (void)indexSearchableItem:(CSSearchableItem *)item;

- (void)deleteSearchableItemsWithIdentifiers:(NSArray<NSString *> *)identifiers;
- (void)deleteSearchableItemsWithIdentifier:(NSString *)identifier;

- (void)deleteSearchableItemsWithDomainIdentifiers:(NSArray<NSString *> *)domainIdentifiers;
- (void)deleteSearchableItemsWithDomainIdentifier:(NSString *)domainIdentifier;

- (void)deleteAllSearchableItems;

- (void)reindexSearchableItems:(NSArray<CSSearchableItem *> *)items;
- (void)reindexSearchableItem:(CSSearchableItem *)item;

- (void)reindexAllSearchableItems:(NSArray<CSSearchableItem *> *)items;

@end
