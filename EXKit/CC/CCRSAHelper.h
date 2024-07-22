//
//  CCRSAHelper.h
//  Guardian
//
//  Created by Alexander Ivanov on 08.05.15.
//  Copyright (c) 2015 NATEK. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "NSUUID+Guid.h"

#import "NSData+Convenience.h"
#import "NSObject+Convenience.h"
#import "NSString+Convenience.h"

#define PREFIX_INDEX @"index"
#define PREFIX_URL @"url"

#define PREFIX_LEVEL @"level"
#define PREFIX_FLAG @"flag"
#define PREFIX_GUID @"guid"
#define PREFIX_HASH @"hash"
#define PREFIX_EXTENSION @"extension"

typedef enum : unsigned char {
	RSA_UNCLASSIFIED = 0,
	RSA_CLASSIFIED = 1,
} RSA_LEVEL;

@interface CCRSAHelper : NSObject

+ (NSData *)dataFromPrefix:(NSDictionary *)prefix;

+ (NSDictionary *)prefixFromData:(NSData *)data;

@end
