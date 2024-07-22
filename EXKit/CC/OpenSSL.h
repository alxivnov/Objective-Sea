//
//  OpenSSL.h
//  guardian
//
//  Created by Alexander Ivanov on 26.08.14.
//  Copyright (c) 2014 NATEK. All rights reserved.
//

#import "CCAESKey.h"
#import "CCRSAKey.h"

typedef enum : NSUInteger {
	Decrypt = 0,
	Encrypt = 1,
} Operation;

@interface OpenSSL : NSObject

+ (NSData *)encrypt:(NSData *)data withPublicKey:(CCRSAKey *)key;
+ (NSData *)decrypt:(NSData *)data withPrivateKey:(CCRSAKey *)key;

+ (NSData *)encrypt:(NSData *)data withKey:(CCAESKey *)key;
+ (NSData *)decrypt:(NSData *)data withKey:(CCAESKey *)key;

+ (NSData *)generateRandomData:(NSUInteger)length;

@end
