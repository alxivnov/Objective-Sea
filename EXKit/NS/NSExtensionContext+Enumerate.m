//
//  NSExtensionContext+Enumerate.m
//  Guardian
//
//  Created by Alexander Ivanov on 20.04.15.
//  Copyright (c) 2015 NATEK. All rights reserved.
//

#import "NSExtensionContext+Enumerate.h"

@implementation NSExtensionContext (Enumerate)

- (void)enumerateItemsForTypeIdentifiers:(NSArray *)identifiers block:(void(^)(id item, NSString *identifier))block count:(NSUInteger)count {
	__block NSUInteger index = 0;
	
	for (NSExtensionItem *item in self.inputItems)
		for (NSItemProvider *itemProvider in item.attachments) {
			NSString *identifier = [identifiers firstObject:^BOOL(id item) {
				return [itemProvider hasItemConformingToTypeIdentifier:item];
			}];
			
			if (!identifier)
				continue;
			
			[itemProvider loadItemForTypeIdentifier:identifier options:Nil completionHandler:^(id  item, NSError *error) {
				[error log:@"loadItemForTypeIdentifier:"];
				
				[[NSOperationQueue mainQueue] addOperationWithBlock:^{
					block(item, identifier);
				}];
			}];
			
			index++;
			if (count != 0 && count == index)
				return;
		}
}

- (void)enumerateItemsForTypeIdentifiers:(NSArray *)identifiers block:(void(^)(id item, NSString *identifier))block {
	[self enumerateItemsForTypeIdentifiers:identifiers block:block count:0];
}

- (void)firstItemForTypeIdentifiers:(NSArray *)identifiers block:(void(^)(id item, NSString *identifier))block {
	[self enumerateItemsForTypeIdentifiers:identifiers block:block count:1];
}

- (void)enumerateItemsForTypeIdentifier:(NSString *)identifier block:(void(^)(id item))block count:(NSUInteger)count {
	[self enumerateItemsForTypeIdentifiers:arr_(identifier) block:^(id item, NSString *identifier) {
		block(identifier);
	} count:count];
}

- (void)enumerateItemsForTypeIdentifier:(NSString *)identifier block:(void(^)(id item))block {
	[self enumerateItemsForTypeIdentifier:identifier block:block count:0];
}

- (void)firstItemForTypeIdentifier:(NSString *)identifier block:(void(^)(id item))block {
	[self enumerateItemsForTypeIdentifier:identifier block:block count:1];
}

@end
