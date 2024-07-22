//
//  CCCryptor.m
//  Guardian
//
//  Created by Alexander Ivanov on 16.02.15.
//  Copyright (c) 2015 NATEK. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>

#import "CCAESKey.h"
#import "CCCryptor.h"

@interface CCCryptor ()
@property (assign, nonatomic, readonly) CCCryptorRef cryptor;
@end

@implementation CCCryptor

- (instancetype)initWithOperation:(CCOperation)operation algorithm:(CCAlgorithm)algorithm options:(CCOptions)options key:(CCAESKey *)key {
	self = [super init];
	
	if (self) {
		CCCryptorStatus status = CCCryptorCreate(operation, algorithm, options, key.key.bytes, key.key.length, key.iv.bytes, &_cryptor);
		if ([[self class] log:status with:@"CCCryptorCreate"])
			_cryptor = Nil;
	}
	
	return self;
}

- (instancetype)initWithOperation:(CCOperation)operation mode:(CCMode)mode algorithm:(CCAlgorithm)algorithm padding:(CCPadding)padding key:(CCAESKey *)key {
	self = [super init];
	
	if (self) {
		CCCryptorStatus status = CCCryptorCreateWithMode(operation, mode, algorithm, padding, key.iv.bytes, key.key.bytes, key.key.length, Nil, 0, 0, 0, &_cryptor);
		if ([[self class] log:status with:@"CCCryptorCreateWithMode"])
			_cryptor = Nil;
	}
	
	return self;
}

- (BOOL)needsFinish {
	if (!self.cryptor)
		return NO;
	
	size_t length = CCCryptorGetOutputLength(self.cryptor, 0, YES);
	return length;
}

- (NSData *)update:(NSData *)data {
	if (!self.cryptor)
		return Nil;
	
	size_t bufferLength = CCCryptorGetOutputLength(self.cryptor, data.length, NO);
	void *buffer = malloc(bufferLength);
	size_t length = 0;
	
	CCCryptorStatus status = CCCryptorUpdate(self.cryptor, data.bytes, data.length, buffer, bufferLength, &length);
	
	if (![[self class] log:status with:@"CCCryptorUpdate"])
		return [NSData dataWithBytesNoCopy:buffer length:length freeWhenDone:YES];
	
	free(buffer);
	return Nil;
}

- (NSData *)finish {
	if (!self.cryptor)
		return Nil;
	
	size_t bufferLength = CCCryptorGetOutputLength(self.cryptor, 0, YES);
	void *buffer = malloc(bufferLength);
	size_t length = 0;
	
	CCCryptorStatus status = CCCryptorFinal(self.cryptor, buffer, bufferLength, &length);
	if (![[self class] log:status with:@"CCCryptorFinal"])
		return [NSData dataWithBytesNoCopy:buffer length:length freeWhenDone:YES];
	
	free(buffer);
	return Nil;
}

- (void)dealloc {
	if (!self.cryptor)
		return;
	
	CCCryptorStatus status = CCCryptorRelease(self.cryptor);
	if (![[self class] log:status with:@"CCCryptorRelease"])
		_cryptor = Nil;
}

+ (BOOL)log:(CCCryptorStatus)status with:(NSString *)format {
	if (!status)
		return NO;
	
	NSLog(format ? [format containsString:@"%@"] ? format : [NSString stringWithFormat:@"%@: %@", format, @"%@"] : [@(status) description], @(status));
	return YES;
}

+ (instancetype)aesDecryptor:(CCAESKey *)key mode:(AES_MODE)mode {
	CCMode m = mode > 0 ? kCCModeCTR : kCCModeCBC;
	CCPadding p = mode > 0 ? ccNoPadding : ccPKCS7Padding;
	
	return [[self alloc] initWithOperation:kCCDecrypt mode:m algorithm:kCCAlgorithmAES padding:p key:key];
}

+ (instancetype)aesEncryptor:(CCAESKey *)key mode:(AES_MODE)mode {
	CCMode m = mode > 0 ? kCCModeCTR : kCCModeCBC;
	CCPadding p = mode > 0 ? ccNoPadding : ccPKCS7Padding;
	
	return [[self alloc] initWithOperation:kCCEncrypt mode:m algorithm:kCCAlgorithmAES padding:p key:key];
}

+ (NSData *)generateRandomData:(NSUInteger)length {
	unsigned char *random = malloc(length);
	
	arc4random_buf(random, length);
	
	return [NSData dataWithBytesNoCopy:random length:length freeWhenDone:YES];
}

@end
