//
//  CoreData+Convenience.h
//  Trend
//
//  Created by Alexander Ivanov on 03.09.17.
//  Copyright © 2017 Pine 9. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "NSObject+Convenience.h"

@interface NSPersistentContainer (Convenience)

- (void)loadPersistentStores:(void (^)(NSPersistentStoreDescription *description))block;

@end

@interface NSManagedObject (Convenience)

+ (instancetype)insertInContext:(NSManagedObjectContext *)context;

+ (NSArray *)executeFetchRequestInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors fetchLimit:(NSUInteger)fetchLimit;
+ (NSArray *)executeFetchRequestInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors;
+ (NSArray *)executeFetchRequestInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate;
+ (NSArray *)executeFetchRequestInContext:(NSManagedObjectContext *)context predicateWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(2, 3);

+ (__kindof NSManagedObject *)executeFetchRequestInContext:(NSManagedObjectContext *)context firstObject:(NSString *)attributeName;
+ (__kindof NSManagedObject *)executeFetchRequestInContext:(NSManagedObjectContext *)context lastObject:(NSString *)attributeName;

+ (NSUInteger)countForFetchRequestInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate;
+ (NSUInteger)countForFetchRequestInContext:(NSManagedObjectContext *)context predicateWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(2, 3);

@end

@interface NSManagedObjectContext (Convenience)

- (BOOL)save;

- (__kindof NSManagedObject *)insertObjectForName:(NSString *)entityName;

- (NSArray *)executeFetchRequestWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors fetchLimit:(NSUInteger)fetchLimit;

- (NSUInteger)countForFetchRequestWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate;

@end
