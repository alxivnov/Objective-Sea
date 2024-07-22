//
//  NSFileDataSource.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 27.03.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSPropertyFile.h"

@interface NSLocalFileDataSource : NSObject <NSPropertyDataSource>

- (NSURL *)urlFromKey:(NSString *)key;

+ (instancetype)create:(NSString *)suiteName;
+ (instancetype)create;

@end
