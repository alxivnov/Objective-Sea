//
//  RSAKeyValue.m
//  Guardian
//
//  Created by Alexander Ivanov on 26.08.14.
//  Copyright (c) 2014 NATEK. All rights reserved.
//

#import "OpenSSL.h"
#import "CCRSAKey.h"

@implementation CCRSAKey

- (NSData *)d {
	return [self value:@"D"];
}

- (NSData *)dp {
	return [self value:@"DP"];
}

- (NSData *)dq {
	return [self value:@"DQ"];
}

- (NSData *)exponent {
	return [self value:@"Exponent"];
}

- (NSData *)inverseQ {
	return [self value:@"InverseQ"];
}

- (NSData *)modulus {
	return [self value:@"Modulus"];
}

- (NSData *)p {
	return [self value:@"P"];
}

- (NSData *)q {
	return [self value:@"Q"];
}

- (NSData *)encrypt:(NSData *)data {
	return [OpenSSL encrypt:data withPublicKey:self];
}

- (NSData *)decrypt:(NSData *)data {
	return [OpenSSL decrypt:data withPrivateKey:self];
}

@end
