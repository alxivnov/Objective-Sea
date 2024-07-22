//
//  NSPropertyArray.m
//  Done!
//
//  Created by Alexander Ivanov on 11.01.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "NSPropertyArray.h"

@interface NSPropertyArray ()
@property (strong, nonatomic, readwrite) NSMutableArray *array;
@end

@implementation NSPropertyArray

- (NSMutableArray *)array {
    if (!_array)
        _array = [[NSMutableArray alloc] init];
    
    return _array;
}

- (NSPropertyDictionary *)createItem {
	return Nil;											// abstract
}

- (NSPropertyDictionary *)loadItem:(id)object {
	NSPropertyDictionary *item = [self createItem];
	
	if ([object isKindOfClass:[NSDictionary class]])
		[item fromDictionary:(NSDictionary *)object];
	
	return item;										// abstract
}

- (id)saveItem:(NSPropertyDictionary *)item {
	return [item toDictionary];							// abstract
}

- (instancetype)initFromArray:(NSArray *)array {
	self = [self init];
	
	if (self)
		[self loadFromArray:array];
	
	return self;
}

- (void)loadFromArray:(NSArray *)array {
	[self.array removeAllObjects];
	
	for (id object in array) {
		NSPropertyDictionary *item = [self loadItem:object];
		[self.array addObject:item];
	}
}

- (NSArray *)saveToArray {
	NSMutableArray *array = [[NSMutableArray alloc] init];
    
	for (NSPropertyDictionary *item in self.array)
		[array addObject:[self saveItem:item]];

	return array;
}

- (void)load:(NSString *)key {
	NSArray *data = [self.dataSource loadByKey:key];
    
	[self loadFromArray:data];
}

- (void)save:(NSString *)key {
	NSArray *data = [self saveToArray];
	
	if (![self isChanged])
		return;
	
	[self.dataSource save:data byKey:key];
}

- (void)loadFromFile:(NSURL *)url {
	NSArray *data = [NSArray arrayWithContentsOfURL:url];
	[self loadFromArray:data];
}

- (void)saveToFile:(NSURL *)url {
	NSArray *data = [self saveToArray];
	[data writeToURL:url atomically:YES];
}

@end
