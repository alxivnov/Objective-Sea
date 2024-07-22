//
//  CCAESInputStream.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 13.02.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "CCAESInputStream.h"
#import "CCCryptor.h"
#import "CCHasher.h"
#import "CCOpenSSL.h"
#import "CCRSAHelper.h"

@interface CCAESInputStream ()
@property (strong, nonatomic) CCAESKey *key;
@property (assign, nonatomic) AES_MODE mode;

@property (strong, nonatomic) CCOpenSSL *cryptor;
@property (strong, nonatomic) CCHasher *hasher;

@property (strong, nonatomic) NSInputStream *stream;
@end

@implementation CCAESInputStream

- (CCOpenSSL *)cryptor {
	if (!_cryptor && self.key)
		_cryptor = [CCOpenSSL aesDecryptor:self.key mode:self.mode];
	
	return _cryptor;
}

- (void)open {
	[self.stream open];
}

- (void)close {
	[self.stream close];
}

- (NSInteger)read:(uint8_t *)buf maxLength:(NSUInteger)len {
	uint8_t *buffer = malloc(len);
	NSInteger length = [self.stream read:buffer maxLength:len];
	
	NSData *data = [self.cryptor update:[NSData dataWithBytesNoCopy:buffer length:length freeWhenDone:YES]];
	if (!data)
		return -1;
	else if (!data.length && ![self.stream hasBytesAvailable])
		data = [self.cryptor finish];
	
	[self.hasher update:data];
	
	memcpy(buf, data.bytes, data.length);
	return data.length;
}

- (BOOL)getBuffer:(uint8_t **)buf length:(NSUInteger *)len {
	return NO;
}

- (BOOL)hasBytesAvailable {
	return [self.stream hasBytesAvailable] || self.cryptor.needsFinish;
}

- (instancetype)initWithStream:(NSInputStream *)stream {
	self = [super init];
	
	if (self)
		self.stream = stream;
	
	return self;
}

+ (instancetype)createWithKey:(CCAESKey *)key stream:(NSInputStream *)stream {
	CCAESInputStream *instance = [[self alloc] initWithStream:stream];
	instance.key = key ? key : [[CCAESKey alloc] init];
	return instance;
}

+ (instancetype)createWithKey:(CCAESKey *)key data:(NSData *)data {
	return [self createWithKey:key stream:[NSInputStream inputStreamWithData:data]];
}

+ (instancetype)createWithKey:(CCAESKey *)key URL:(NSURL *)url {
	return [self createWithKey:key stream:[NSInputStream inputStreamWithURL:url]];
}

//static unsigned char V0 = 0;

- (NSDictionary *)getPrefix:(CCRSAKey *)key andLength:(out NSUInteger *)length {
	NSData *data = Nil;
	NSUInteger prefixLenght = 0;
	
//	if ([self.stream readByte] > V0) {
		prefixLenght = key.modulus.length;//[self.stream readInt];
		NSData *prefix = [self.stream readData:prefixLenght];
		data = [key decrypt:prefix];
//	}
	
	if (length)
		*length = prefixLenght + sizeof(int);
	
	return [CCRSAHelper prefixFromData:data];
}

- (BOOL)decrypt:(CCRSAKey *)key toStream:(NSOutputStream *)cleartext withPrefix:(out NSDictionary **)prefix {
	NSUInteger length = 0;
	NSDictionary *data = [self getPrefix:key andLength:&length];
	if (prefix)
		*prefix = data;
	
	NSInteger keyLength = key.modulus.length;//[self.stream readInt];
	NSInteger ivLength = key.modulus.length;//[self.stream readInt];
	NSData *aesKey = [self.stream readData:keyLength];
	NSData *aesIV = [self.stream readData:ivLength];
	
	aesKey = [key decrypt:aesKey];
	aesIV = [key decrypt:aesIV];;
	if (!aesKey || !aesIV)
		return NO;
	
	self.key = [[CCAESKey alloc] initWithKey:aesKey andIV:aesIV];
	self.mode = ((NSNumber *)data[PREFIX_FLAG]).unsignedIntValue;
	return [cleartext copyFromStream:self];
}

@end
