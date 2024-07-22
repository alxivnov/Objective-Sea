//
//  NSUserDefaultsDataSource.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 13.11.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSPropertyFile.h"

@interface NSLocalKVStoreDataSource : NSObject <NSPropertyDataSource>

+ (instancetype)create:(NSString *)suiteName;
+ (instancetype)create;

@end
