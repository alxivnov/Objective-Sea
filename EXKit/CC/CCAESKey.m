//
//  AESKeyValue.m
//  Guardian
//
//  Created by Alexander Ivanov on 28.08.14.
//  Copyright (c) 2014 NATEK. All rights reserved.
//

#import "CCAESKey.h"
#import "CCAESInputStream.h"
#import "CCAESOutputStream.h"
#import "CCCryptor.h"
#import "NSMutableData+Writer.h"

#if TARGET_OS_IPHONE
@import UIKit;
#else
#import "LocalAuthentication+Convenience.h"
#endif

@implementation CCAESKey

- (instancetype)initWithKey:(NSData *)key andIV:(NSData *)iv {
	return [self initWithDictionary:@{ @"Key" : key, @"IV" : iv }];
}

- (NSData *)key {
	return [self value:@"Key"];
}

- (NSData *)iv {
	return [self value:@"IV"];
}

+ (instancetype)generate:(NSData *)data {
	NSData *key = data.length ? data.length > 32 ? [data cutRight:32] : data.length < 32 ? [data padRight:32] : data : [CCCryptor generateRandomData:kCCKeySizeAES256];
	NSData *iv = data.length ? [[key hash:MD5] mutableCopy] : [CCCryptor generateRandomData:kCCBlockSizeAES128];
	
	return [[self alloc] initWithKey:key andIV:iv];
}

+ (instancetype)generate {
	return [self generate:Nil];
}

+ (instancetype)keyForVendor {
/*	NSMutableData *data = [NSMutableData data];

#if TARGET_OS_IPHONE
	#ifndef NDEBUG
	NSString *model = [[UIDevice currentDevice] model];
	[data appendData:[model dataUsingEncoding:NSUnicodeStringEncoding]];
	#else
	NSUUID *vendor = [[UIDevice currentDevice] identifierForVendor];
	[data appendUUID:vendor];
	#endif
#else
	unsigned int uid = 0;
	unsigned int gid = 0;
	NSString *user = [SCHelper consoleUser];
	[data appendData:[user dataUsingEncoding:NSUnicodeStringEncoding]];
	[data appendUnsignedInt:uid];
	[data appendUnsignedInt:gid];
#endif
*/
	return [self generate:[[NSBundle bundleIdentifier] dataUsingEncoding:NSUnicodeStringEncoding]/*data*/];
}

+ (NSData *)encrypt:(NSData *)data password:(NSString *)password {
	CCAESKey *aes = password.length ? [self generate:[password dataUsingEncoding:NSUnicodeStringEncoding]] : [self keyForVendor];
	
	NSData *encrypted = [aes encrypt:data];
	
	[aes reset];
	
	return encrypted;
}

+ (NSData *)encrypt:(NSData *)data {
	return [self encrypt:data password:Nil];
}

+ (NSData *)decrypt:(NSData *)data password:(NSString *)password {
	CCAESKey *aes = password.length ? [self generate:[password dataUsingEncoding:NSUnicodeStringEncoding]] : [self keyForVendor];
	
	NSData *decrypted = [aes decrypt:data];
	
	[aes reset];
	
	return decrypted;
}

+ (NSData *)decrypt:(NSData *)data {
	return [self decrypt:data password:Nil];
}

- (NSData *)encrypt:(NSData *)data {
	if (!data)
		return Nil;
	
	NSInputStream *input = [NSInputStream inputStreamWithData:data];
	CCAESOutputStream *output = [CCAESOutputStream createWithKey:self];
	[input open];
	[output open];
	[input copyToStream:output];
	[output close];
	[input close];
	
	NSData *encrypted = [output.stream memory];
	
	return encrypted;
}

- (NSData *)decrypt:(NSData *)data {
	if (!data)
		return Nil;
	
	CCAESInputStream *input = [CCAESInputStream createWithKey:self data:data];
	NSOutputStream *output = [NSOutputStream outputStreamToMemory];
	[input open];
	[output open];
	[output copyFromStream:input];
	[output close];
	[input close];
	
	NSData *decrypted = [output memory];
	
	return decrypted;
}

@end
