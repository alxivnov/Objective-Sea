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
		if (block)
			block(description);

		[error log:@"loadPersistentStoresWithCompletionHandler:"];
	}];
}

+ (void)loadPersistentContainerWithName:(NSString *)name completionHandler:(void (^)(NSPersistentContainer *, NSPersistentStoreDescription *))block {
	NSPersistentContainer *container = [NSPersistentContainer persistentContainerWithName:name];

	[container loadPersistentStores:^(NSPersistentStoreDescription *description) {
		if (block)
			block(container, description);
	}];
}

@end

@implementation NSManagedObject (Convenience)

+ (NSString *)entityName {
	return [self description];
}

+ (instancetype)insertInContext:(NSManagedObjectContext *)context {
	return [NSEntityDescription insertNewObjectForEntityForName:[self description] inManagedObjectContext:context];
}

+ (NSArray *)executeFetchRequestInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors fetchLimit:(NSUInteger)fetchLimit {
	return [context executeFetchRequestWithEntityName:[self entityName] predicate:predicate sortDescriptors:sortDescriptors fetchLimit:fetchLimit];
}

+ (NSArray *)executeFetchRequestInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors {
	return [context executeFetchRequestWithEntityName:[self entityName] predicate:predicate sortDescriptors:sortDescriptors fetchLimit:0];
}

+ (NSArray *)executeFetchRequestInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate {
	return [context executeFetchRequestWithEntityName:[self entityName] predicate:predicate sortDescriptors:Nil fetchLimit:0];
}

+ (NSArray *)executeFetchRequestInContext:(NSManagedObjectContext *)context predicateWithFormat:(NSString *)format, ... {
	va_list args;

	va_start(args, format);

	NSPredicate *predicate = [NSPredicate predicateWithFormat:format arguments:args];

	va_end(args);

	return [context executeFetchRequestWithEntityName:[self entityName] predicate:predicate sortDescriptors:Nil fetchLimit:0];
}

+ (__kindof NSManagedObject *)executeFetchRequestInContext:(NSManagedObjectContext *)context firstObject:(NSString *)attributeName {
	return [context executeFetchRequestWithEntityName:[self entityName] predicate:Nil sortDescriptors:@[ [[NSSortDescriptor alloc] initWithKey:attributeName ascending:YES] ] fetchLimit:1].firstObject;
}

+ (__kindof NSManagedObject *)executeFetchRequestInContext:(NSManagedObjectContext *)context lastObject:(NSString *)attributeName {
	return [context executeFetchRequestWithEntityName:[self entityName] predicate:Nil sortDescriptors:@[ [[NSSortDescriptor alloc] initWithKey:attributeName ascending:NO] ] fetchLimit:1].lastObject;
}

+ (NSUInteger)countForFetchRequestInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate {
	return [context countForFetchRequestWithEntityName:[self entityName] predicate:predicate];
}

+ (NSUInteger)countForFetchRequestInContext:(NSManagedObjectContext *)context predicateWithFormat:(NSString *)format, ... {
	va_list args;

	va_start(args, format);

	NSPredicate *predicate = [NSPredicate predicateWithFormat:format arguments:args];

	va_end(args);

	return [context countForFetchRequestWithEntityName:[self entityName] predicate:predicate];
}

@end

@implementation NSManagedObjectContext (Convenience)

- (BOOL)save {
	NSError *error = Nil;

	BOOL save = [self save:&error];

	[error log:@"save:"];

	return save;
}

- (NSManagedObject *)insertObjectForName:(NSString *)entityName {
	return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self];
}

- (NSArray *)executeFetchRequestWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors fetchLimit:(NSUInteger)fetchLimit {
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	fetchRequest.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
	fetchRequest.predicate = predicate;
	fetchRequest.sortDescriptors = sortDescriptors;
	fetchRequest.fetchLimit = fetchLimit;

	NSError *error = Nil;

	NSArray *fetchedObjects = [self executeFetchRequest:fetchRequest error:&error];

	[error log:@"executeFetchRequest:"];

	return fetchedObjects;
}

- (NSUInteger)countForFetchRequestWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate {
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	fetchRequest.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
	fetchRequest.predicate = predicate;

	NSError *error = Nil;

	NSUInteger count = [self countForFetchRequest:fetchRequest error:&error];

	[error log:@"countForFetchRequest:"];

	return count;
}

@end
