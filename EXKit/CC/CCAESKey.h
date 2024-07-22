//
//  AESKeyValue.h
//  Guardian
//
//  Created by Alexander Ivanov on 28.08.14.
//  Copyright (c) 2014 NATEK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CommonCrypto+Convenience.h"
#import "NSBundle+Convenience.h"
#import "NSData+Convenience.h"
#import "NSStream+Convenience.h"

#import "CCKeyBase.h"

typedef enum : unsigned int {
	AES_MODE_CBC = 0,
	AES_MODE_CTR = 1,
} AES_MODE;

@interface CCAESKey : CCKeyBase

@property (strong, nonatomic) NSData *key;
@property (strong, nonatomic) NSData *iv;

- (instancetype)initWithKey:(NSData *)key andIV:(NSData *)iv;

+ (instancetype)generate:(NSData *)data;
+ (instancetype)generate;

+ (instancetype)keyForVendor;

+ (NSData *)encrypt:(NSData *)data password:(NSString *)password;
+ (NSData *)encrypt:(NSData *)data;
+ (NSData *)decrypt:(NSData *)data password:(NSString *)password;
+ (NSData *)decrypt:(NSData *)data;

@end
