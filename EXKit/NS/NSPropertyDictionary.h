//
//  NSPropertyList.h
//  Done!
//
//  Created by Alexander Ivanov on 06.01.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "NSPropertyFile.h"

@interface NSPropertyDictionary : NSPropertyFile

- (instancetype)initFromDictionary:(NSDictionary *)dictionary;

- (void)fromDictionary:(NSDictionary *)dictionary;	// abstract
- (NSDictionary *)toDictionary;						// abstract

@end
