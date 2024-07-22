//
//  CCOpenSSL.m
//  Guardian
//
//  Created by Alexander Ivanov on 18.05.15.
//  Copyright (c) 2015 NATEK. All rights reserved.
//

#import "CCOpenSSL.h"
#import "OpenSSL.h"

#import <openssl/evp.h>

@interface CCOpenSSL ()
@property (assign, nonatomic, readonly) EVP_CIPHER_CTX *cryptor;

@property (assign, nonatomic) int final;
@end

@implementation CCOpenSSL

- (instancetype)initWithOperation:(Operation)operation cipher:(const EVP_CIPHER *)cipher key:(CCAESKey *)key {
	self = [super init];
	
	if (self) {
		_cryptor = EVP_CIPHER_CTX_new();
		
		int status = EVP_CipherInit(_cryptor, cipher, key.key.bytes, key.iv.bytes, operation);
		if ([[self class] log:status with:@"EVP_CipherInit"])
			_cryptor = Nil;
	}
	
	return self;
}

- (BOOL)needsFinish {
	if (!self.cryptor)
		return NO;
	
	size_t length = self.final;//CCCryptorGetOutputLength(self.cryptor, 0, YES);
	return length;
}

- (NSData *)update:(NSData *)data {
	if (!self.cryptor)
		return Nil;
	
	size_t bufferLength = data.length + EVP_MAX_BLOCK_LENGTH;//CCCryptorGetOutputLength(self.cryptor, data.length, NO);
	void *buffer = malloc(bufferLength);
	int length = 0;
	
	int status = EVP_CipherUpdate(self.cryptor, buffer, &length, data.bytes, (int)[data length]);
	
	self.final += (int)data.length - length;
	
	if (![[self class] log:status with:@"EVP_CipherUpdate"])
		return [NSData dataWithBytesNoCopy:buffer length:length freeWhenDone:YES];
	
	free(buffer);
	return Nil;
}

- (NSData *)finish {
	if (!self.cryptor)
		return Nil;
	
	size_t bufferLength = self.final + EVP_MAX_BLOCK_LENGTH;//CCCryptorGetOutputLength(self.cryptor, 0, YES);
	void *buffer = malloc(bufferLength);
	int length = 0;
	
	int status = EVP_CipherFinal(self.cryptor, buffer, &length);
	
	self.final = 0;
	
	if (![[self class] log:status with:@"EVP_CipherFinal"])
		return [NSData dataWithBytesNoCopy:buffer length:length freeWhenDone:YES];
	
	free(buffer);
	return Nil;
}

- (void)dealloc {
	if (!self.cryptor)
		return;
	
	int status = EVP_CIPHER_CTX_cleanup(self.cryptor);
	if (![[self class] log:status with:@"EVP_CIPHER_CTX_cleanup"])
		_cryptor = Nil;
}

+ (BOOL)log:(int)status with:(NSString *)format {
	if (status)
		return NO;
	
	NSLog(format ? [format containsString:@"%@"] ? format : [NSString stringWithFormat:@"%@: %@", format, @"%@"] : [@(status) description], @(status));
	return YES;
}

+ (instancetype)aesDecryptor:(CCAESKey *)key mode:(AES_MODE)mode {
	const EVP_CIPHER *cipher = mode > 0 ? EVP_aes_256_ctr() : EVP_aes_256_cbc();
	return [[self alloc] initWithOperation:Decrypt cipher:cipher key:key];
}

+ (instancetype)aesEncryptor:(CCAESKey *)key mode:(AES_MODE)mode {
	const EVP_CIPHER *cipher = mode > 0 ? EVP_aes_256_ctr() : EVP_aes_256_cbc();
	return [[self alloc] initWithOperation:Encrypt cipher:cipher key:key];
}

+ (NSData *)generateRandomData:(NSUInteger)length {
	return [OpenSSL generateRandomData:length];
}

@end
