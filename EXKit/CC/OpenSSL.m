//
//  OpenSSL.m
//  guardian
//
//  Created by Alexander Ivanov on 26.08.14.
//  Copyright (c) 2014 NATEK. All rights reserved.
//

#import "OpenSSL.h"

#import <openssl/bn.h>
#import <openssl/evp.h>
#import <openssl/rand.h>
#import <openssl/rsa.h>

@implementation OpenSSL

+ (NSData *)asymmetric:(Operation)operation data:(NSData *)data withKey:(CCRSAKey *)key {
	RSA *rsa = RSA_new();
	rsa->d = BN_bin2bn(key.d.bytes, (int)key.d.length, Nil);
	rsa->dmp1 = BN_bin2bn(key.dp.bytes, (int)key.dp.length, Nil);
	rsa->dmq1 = BN_bin2bn(key.dq.bytes, (int)key.dq.length, Nil);
	rsa->e = BN_bin2bn(key.exponent.bytes, (int)key.exponent.length, Nil);
	rsa->iqmp = BN_bin2bn(key.inverseQ.bytes, (int)key.inverseQ.length, Nil);
	rsa->n = BN_bin2bn(key.modulus.bytes, (int)key.modulus.length, Nil);
	rsa->p = BN_bin2bn(key.p.bytes, (int)key.p.length, Nil);
	rsa->q = BN_bin2bn(key.q.bytes, (int)key.q.length, Nil);
	
	unsigned char *buffer = (unsigned char *)malloc(RSA_size(rsa));
	
	NSInteger length = operation == Encrypt
		? RSA_public_encrypt((int)data.length, data.bytes, buffer, rsa, RSA_PKCS1_OAEP_PADDING)
		: RSA_private_decrypt((int)data.length, data.bytes, buffer, rsa, RSA_PKCS1_OAEP_PADDING);
	
	RSA_free(rsa);

	NSData *r = length < 0 ? Nil : [NSData dataWithBytes:buffer length:length];
	
	free(buffer);
	
	return r;
}

+ (NSData *)encrypt:(NSData *)data withPublicKey:(CCRSAKey *)key {
	return [self asymmetric:Encrypt data:data withKey:key];
}

+ (NSData *)decrypt:(NSData *)data withPrivateKey:(CCRSAKey *)key {
	return [self asymmetric:Decrypt data:data withKey:key];
}

+ (NSData *)symmetric:(Operation)operation data:(NSData *)data withKey:(CCAESKey *)key {
	NSUInteger capacity = [data length] + EVP_MAX_BLOCK_LENGTH;
	NSMutableData *r = [NSMutableData dataWithCapacity:capacity];
	
	unsigned char *buffer = malloc(capacity);
	int length = 0;
	
	EVP_CIPHER_CTX *aes = EVP_CIPHER_CTX_new();
	
	EVP_CipherInit(aes, EVP_aes_256_ctr(), key.key.bytes, key.iv.bytes, operation);
	
	EVP_CipherUpdate(aes, buffer, &length, data.bytes, (int)[data length]);
	[r appendBytes:buffer length:length];
	
	EVP_CipherFinal(aes, buffer, &length);
	[r appendBytes:buffer length:length];
	
	EVP_CIPHER_CTX_cleanup(aes);
	
	free(buffer);
	
	return r;
}

+ (NSData *)encrypt:(NSData *)data withKey:(CCAESKey *)key {
	return [self symmetric:Encrypt data:data withKey:key];
}

+ (NSData *)decrypt:(NSData *)data withKey:(CCAESKey *)key {
	return [self symmetric:Decrypt data:data withKey:key];
}

+ (NSData *)generateRandomData:(NSUInteger)length {
	unsigned char *random = malloc(length);
	
	if (!RAND_bytes(random, (int)length))
		RAND_pseudo_bytes(random, (int)length);
	
	return [NSData dataWithBytesNoCopy:random length:length freeWhenDone:YES];
}

@end
