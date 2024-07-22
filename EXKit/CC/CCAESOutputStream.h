//
//  CCAESOutputStream.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 13.02.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCAESKey.h"
#import "CCRSAKey.h"

@interface CCAESOutputStream : NSObject

@property (strong, nonatomic, readonly) NSOutputStream *stream;

- (void)open;
- (void)close;

- (NSInteger)write:(const uint8_t *)buffer maxLength:(NSUInteger)len;

@property (readonly) BOOL hasSpaceAvailable;

+ (instancetype)createWithKey:(CCAESKey *)key stream:(NSOutputStream *)stream;
+ (instancetype)createWithKey:(CCAESKey *)key URL:(NSURL *)url append:(BOOL)shouldAppend;
+ (instancetype)createWithKey:(CCAESKey *)key URL:(NSURL *)url;
+ (instancetype)createWithKey:(CCAESKey *)key;
+ (instancetype)create;

- (BOOL)encrypt:(CCRSAKey *)key fromStream:(NSInputStream *)encrypted withPrefix:(in NSDictionary *)prefix;

@end
