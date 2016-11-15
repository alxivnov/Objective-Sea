//
//  CoreSpotlight+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 15.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "CoreSpotlight+Convenience.h"

@implementation CSSearchableIndex (Convenience)

- (void)indexSearchableItems:(NSArray<CSSearchableItem *> *)items {
	if (!items.count)
		return;

	[self indexSearchableItems:items completionHandler:^(NSError * _Nullable error) {
		[error log:@"indexSearchableItems:"];
	}];
}

- (void)indexSearchableItem:(CSSearchableItem *)item {
	[self indexSearchableItems:arr_(item)];
}

- (void)deleteSearchableItemsWithIdentifiers:(NSArray<NSString *> *)identifiers {
	if (!identifiers.count)
		return;

	[self deleteSearchableItemsWithIdentifiers:identifiers completionHandler:^(NSError * _Nullable error) {
		[error log:@"deleteSearchableItemsWithIdentifiers:"];
	}];
}
- (void)deleteSearchableItemsWithIdentifier:(NSString *)identifier {
	[self deleteSearchableItemsWithIdentifiers:arr_(identifier)];
}

- (void)deleteSearchableItemsWithDomainIdentifiers:(NSArray<NSString *> *)domainIdentifiers {
	if (!domainIdentifiers.count)
		return;

	[self deleteSearchableItemsWithDomainIdentifiers:domainIdentifiers completionHandler:^(NSError * _Nullable error) {
		[error log:@"deleteSearchableItemsWithDomainIdentifiers:"];
	}];
}

- (void)deleteSearchableItemsWithDomainIdentifier:(NSString *)domainIdentifier {
	[self deleteSearchableItemsWithDomainIdentifiers:arr_(domainIdentifier)];
}

- (void)deleteAllSearchableItems {
	[self deleteAllSearchableItemsWithCompletionHandler:^(NSError * _Nullable error) {
		[error log:@"deleteAllSearchableItemsWithCompletionHandler:"];
	}];
}

- (void)reindexSearchableItems:(NSArray<CSSearchableItem *> *)items {
	if (!items.count)
		return;

	[self deleteSearchableItemsWithIdentifiers:[items map:^id(CSSearchableItem *obj) {
		return obj.uniqueIdentifier;
	}] completionHandler:^(NSError * _Nullable error) {
		[error log:@"deleteSearchableItemsWithIdentifiers:"];

		[self indexSearchableItems:items completionHandler:^(NSError * _Nullable error) {
			[error log:@"indexSearchableItems:"];
		}];
	}];
}

- (void)reindexSearchableItem:(CSSearchableItem *)item {
	[self reindexSearchableItems:arr_(item)];
}

- (void)reindexAllSearchableItems:(NSArray<CSSearchableItem *> *)items {
	if (!items.count)
		return;

	[self deleteAllSearchableItemsWithCompletionHandler:^(NSError * _Nullable error) {
		[error log:@"deleteAllSearchableItemsWithCompletionHandler:"];

		[self indexSearchableItems:items completionHandler:^(NSError * _Nullable error) {
			[error log:@"indexSearchableItems:"];
		}];
	}];
}

@end
