//
//  NSPropertyArray.h
//  Done!
//
//  Created by Alexander Ivanov on 11.01.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "NSPropertyFile.h"
#import "NSPropertyDictionary.h"

@interface NSPropertyArray : NSPropertyFile

@property (strong, nonatomic, readonly) NSMutableArray *array;

- (NSPropertyDictionary *)createItem;			// abstract
- (NSPropertyDictionary *)loadItem:(id)object;	// abstract (opt)
- (id)saveItem:(NSPropertyDictionary *)item;	// abstract (opt)

- (instancetype)initFromArray:(NSArray *)array;
- (void)loadFromArray:(NSArray *)array;
- (NSArray *)saveToArray;

@end
