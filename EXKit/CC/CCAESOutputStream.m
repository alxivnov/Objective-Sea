//
//  CCAESOutputStream.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 13.02.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>

#import "CCAESOutputStream.h"
#import "CCCryptor.h"
#import "CCHasher.h"
#import "CCOpenSSL.h"
#import "CCRSAHelper.h"

@interface CCAESOutputStream ()
@property (strong, nonatomic) CCAESKey *key;
@property (assign, nonatomic) AES_MODE mode;

@property (strong, nonatomic) CCOpenSSL *cryptor;
@property (strong, nonatomic) CCHasher *hasher;

@property (strong, nonatomic) NSOutputStream *stream;
@end

@implementation CCAESOutputStream

- (CCOpenSSL *)cryptor {
	if (!_cryptor && self.key)
		_cryptor = [CCOpenSSL aesEncryptor:self.key mode:self.mode];
	
	return _cryptor;
}

- (void)open {
	[self.stream open];
}

- (void)close {
	NSData *data = [self.cryptor finish];
	if (data.length)
		[self.stream write:data.bytes maxLength:data.length];
	
	[self.stream close];
}

- (NSInteger)write:(const uint8_t *)buf maxLength:(NSUInteger)len {
	NSData *temp = [NSData dataWithBytes:buf length:len];
	
	[self.hasher update:temp];
	
	NSData *data = [self.cryptor update:temp];
	
	return data.length ? [self.stream write:data.bytes maxLength:data.length] : self.cryptor.needsFinish ? 0 : -1;
}

- (BOOL)hasSpaceAvailable {
	return [self.stream hasSpaceAvailable];
}

- (instancetype)initWithStream:(NSOutputStream *)stream {
	self = [super init];
	
	if (self)
		self.stream = stream;
	
	return self;
}

+ (instancetype)createWithKey:(CCAESKey *)key stream:(NSOutputStream *)stream {
	CCAESOutputStream *instance = [[self alloc] initWithStream:stream ? stream : [NSOutputStream outputStreamToMemory]];
	instance.key = key ? key : [CCAESKey generate];
	return instance;
}

+ (instancetype)createWithKey:(CCAESKey *)key URL:(NSURL *)url append:(BOOL)shouldAppend {
	return [self createWithKey:key stream:[NSOutputStream outputStreamWithURL:url append:shouldAppend]];
}

+ (instancetype)createWithKey:(CCAESKey *)key URL:(NSURL *)url {
	return [self createWithKey:key stream:[NSOutputStream outputStreamWithURL:url append:NO]];
}

+ (instancetype)createWithKey:(CCAESKey *)key {
	return [self createWithKey:key stream:Nil];
}

+ (instancetype)create {
	return [self createWithKey:Nil stream:Nil];
}

//static unsigned char V0 = 0;
//static unsigned char V1 = 1;

- (BOOL)encrypt:(CCRSAKey *)key fromStream:(NSInputStream *)cleartext withPrefix:(in NSDictionary *)prefix {
	if (prefix) {
		self.mode = ((NSNumber *)prefix[PREFIX_FLAG]).unsignedIntValue;
		
		NSData *data = [CCRSAHelper dataFromPrefix:prefix];
		NSData *encData = [key encrypt:data];
//		int prefixLength = (int)[prefix length];
//		[self.stream writeByte:V1];
//		[self.stream writeInt:prefixLength];
		[self.stream writeData:encData];
	} else {
//		[self.stream writeByte:V0];
	}
	
	NSData *aesKey = [key encrypt:self.key.key];
	NSData *aesIV = [key encrypt:self.key.iv];
//	int aesKeyLength = (int)[aesKey length];
//	int aesIVLength = (int)[aesIV length];
//	[self.stream writeInt:aesKeyLength];
//	[self.stream writeInt:aesIVLength];
	[self.stream writeData:aesKey];
	[self.stream writeData:aesIV];
	
	return [cleartext copyToStream:self];
}

@end
