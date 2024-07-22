//
//  NSCloudDataSource.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 27.03.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSPropertyFile.h"

@interface NSCloudKVStoreDataSource : NSObject <NSPropertyDataSource>

@property (copy, nonatomic) void (^externalChangeHandler)(NSNotification *notification);

@property (assign, nonatomic) BOOL readonly;

+ (instancetype)create:(void (^)(NSNotification *notification))externalChangeHandler readonly:(BOOL)readonly;
+ (instancetype)create:(void (^)(NSNotification *notification))externalChangeHandler;
+ (instancetype)create;

@end
