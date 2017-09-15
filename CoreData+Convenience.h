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

@interface NSManagedObjectContext (Convenience)

- (NSArray *)executeFetchRequestWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors fetchLimit:(NSUInteger)fetchLimit;
- (NSArray *)executeFetchRequestWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors;
- (NSArray *)executeFetchRequestWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate;
- (NSArray *)executeFetchRequestWithEntityName:(NSString *)entityName predicateWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(2, 3);

- (NSUInteger)countForFetchRequestWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate;
- (NSUInteger)countForFetchRequestWithEntityName:(NSString *)entityName predicateWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(2, 3);

- (__kindof NSManagedObject *)executeFetchRequestWithEntityName:(NSString *)entityName firstObject:(NSString *)attributeName;
- (__kindof NSManagedObject *)executeFetchRequestWithEntityName:(NSString *)entityName lastObject:(NSString *)attributeName;

- (__kindof NSManagedObject *)insertObjectForName:(NSString *)name;

- (BOOL)save;

@end
