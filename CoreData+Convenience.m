//
//  CoreData+Convenience.m
//  Trend
//
//  Created by Alexander Ivanov on 03.09.17.
//  Copyright © 2017 Pine 9. All rights reserved.
//

#import "CoreData+Convenience.h"

@implementation NSPersistentContainer (Convenience)

- (void)loadPersistentStores:(void (^)(NSPersistentStoreDescription *))block {
	[self loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *description, NSError *error) {
		[error log:@"loadPersistentStoresWithCompletionHandler:"];

		if (block)
			block(description);
	}];
}

@end

@implementation NSManagedObjectContext (Convenience)

- (NSManagedObject *)insertObjectForName:(NSString *)name {
	return [NSEntityDescription insertNewObjectForEntityForName:@"Block" inManagedObjectContext:self];
}

- (NSArray *)executeFetchRequestWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors fetchLimit:(NSUInteger)fetchLimit {
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	fetchRequest.entity = [NSEntityDescription entityForName:@"Block" inManagedObjectContext:self];
	fetchRequest.predicate = predicate;
	fetchRequest.sortDescriptors = sortDescriptors;
	fetchRequest.fetchLimit = fetchLimit;

	NSError *error = Nil;

	NSArray *fetchedObjects = [self executeFetchRequest:fetchRequest error:&error];

	[error log:@"executeFetchRequest:"];

	return fetchedObjects;
}

- (NSArray *)executeFetchRequestWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate  sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors{
	return [self executeFetchRequestWithEntityName:entityName predicate:predicate sortDescriptors:sortDescriptors fetchLimit:0];
}

- (NSArray *)executeFetchRequestWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate {
	return [self executeFetchRequestWithEntityName:entityName predicate:predicate sortDescriptors:Nil fetchLimit:0];
}

- (NSArray *)executeFetchRequestWithEntityName:(NSString *)entityName predicateWithFormat:(NSString *)format, ... {
	va_list args;

	va_start(args, format);

	NSPredicate *predicate = [NSPredicate predicateWithFormat:format arguments:args];

	va_end(args);

	return [self executeFetchRequestWithEntityName:entityName predicate:predicate];
}

- (NSUInteger)countForFetchRequestWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate {
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	fetchRequest.entity = [NSEntityDescription entityForName:@"Block" inManagedObjectContext:self];
	fetchRequest.predicate = predicate;

	NSError *error = Nil;

	NSUInteger count = [self countForFetchRequest:fetchRequest error:&error];

	[error log:@"countForFetchRequest:"];

	return count;
}

- (NSUInteger)countForFetchRequestWithEntityName:(NSString *)entityName predicateWithFormat:(NSString *)format, ... {
	va_list args;

	va_start(args, format);

	NSPredicate *predicate = [NSPredicate predicateWithFormat:format arguments:args];

	va_end(args);

	return [self countForFetchRequestWithEntityName:entityName predicate:predicate];
}

- (NSManagedObject *)executeFetchRequestWithEntityName:(NSString *)entityName firstObject:(NSString *)attributeName {
	return [self executeFetchRequestWithEntityName:entityName predicate:Nil sortDescriptors:@[ [[NSSortDescriptor alloc] initWithKey:attributeName ascending:YES] ] fetchLimit:1].firstObject;
}

- (NSManagedObject *)executeFetchRequestWithEntityName:(NSString *)entityName lastObject:(NSString *)attributeName {
	return [self executeFetchRequestWithEntityName:entityName predicate:Nil sortDescriptors:@[ [[NSSortDescriptor alloc] initWithKey:attributeName ascending:NO] ] fetchLimit:1].lastObject;
}

- (BOOL)save {
	NSError *error = Nil;

	BOOL save = [self save:&error];

	[error log:@"save:"];

	return save;
}

@end
