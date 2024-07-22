//
//  NSString+Crypto.m
//  Guardian
//
//  Created by Alexander Ivanov on 27.08.14.
//  Copyright (c) 2014 NATEK. All rights reserved.
//

#import "CCAESKey.h"
#import "CCHasher.h"
#import "CCRSAHelper.h"
#import "NSData+RSA.h"
#import "NSString+RSA.h"
#import "NSString+Data.h"

@implementation NSString (RSA)

- (NSString *)encrypt:(CCRSAKey *)key {
	NSData *data = [self dataUsingDotNetEncoding];
	
	NSData *hash = [CCHasher hash:HASH_ALGORITHM_SHA256 fromData:data];
	NSDictionary *prefix = @{
		PREFIX_LEVEL : [NSNumber numberWithChar:RSA_UNCLASSIFIED],
		PREFIX_FLAG : [NSNumber numberWithUnsignedInt:AES_MODE_CTR],
		PREFIX_GUID : [NSUUID UUID],
		PREFIX_HASH : hash,
	};
//	NSData *prefix = [CCRSAHelper dataFromPrefix:p];
	
	NSData *encrypted = [data encrypt:key withPrefix:prefix];
	NSString *string = encrypted ? [encrypted hexString] : Nil;
	return string;
}

- (NSString *)decrypt:(CCRSAKey *)key {
	NSDictionary *prefix = Nil;
	
	NSData *data = [self toData];
	NSData *decrypted = [data decrypt:key withPrefix:&prefix];
	
//	NSDictionary *p = [CCRSAHelper prefixFromData:prefix];

	NSString *string = decrypted ? [decrypted stringUsingDotNetEncoding] : Nil;
	return string;
}

- (NSString *)decryptWithKeys:(NSArray *)collection {
	NSString *string = Nil;
	
	for (CCRSAKey *key in collection) {
		string = [self decrypt:key];
		if (string)
			return string;
	}
	
	return string;
}

@end
