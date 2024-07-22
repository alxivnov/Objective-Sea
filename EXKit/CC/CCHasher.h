//
//  CCHasher.h
//  Guardian
//
//  Created by Alexander Ivanov on 08.05.15.
//  Copyright (c) 2015 NATEK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSFileManager+Convenience.h"

typedef enum : NSUInteger {
	HASH_ALGORITHM_NONE,
	HASH_ALGORITHM_SHA256,
} HASH_ALGORITHM;

@interface CCHasher : NSObject

- (instancetype)initWithAlgorithm:(HASH_ALGORITHM)algorithm;

- (void)update:(NSData *)data;

- (NSData *)final;

+ (NSData *)hash:(HASH_ALGORITHM)algorithm fromStream:(NSInputStream *)stream;
+ (NSData *)hash:(HASH_ALGORITHM)algorithm fromData:(NSData *)data;
+ (NSData *)hash:(HASH_ALGORITHM)algorithm fromURL:(NSURL *)url;

@end
