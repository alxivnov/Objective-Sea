//
//  CommonCrypto+Convenience.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "CommonCrypto+Convenience.h"

@implementation NSData (CommonCrypto)

+ (instancetype)randomDataWithLength:(NSUInteger)length {
	NSMutableData *data = [NSMutableData dataWithLength:length];

	arc4random_buf(data.mutableBytes, data.length);

	return data;
}

- (void)logCryptorStatus:(CCCryptorStatus)status {
	switch (status) {
		case kCCParamError:
			NSLog(@"kCCParamError");
			break;
		case kCCBufferTooSmall:
			NSLog(@"kCCBufferTooSmall");
			break;
		case kCCMemoryFailure:
			NSLog(@"kCCMemoryFailure");
			break;
		case kCCAlignmentError:
			NSLog(@"kCCAlignmentError");
			break;
		case kCCDecodeError:
			NSLog(@"kCCDecodeError");
			break;
		case kCCUnimplemented:
			NSLog(@"kCCUnimplemented");
			break;
		case kCCOverflow:
			NSLog(@"kCCOverflow");
			break;
		case kCCRNGFailure:
			NSLog(@"kCCRNGFailure");
			break;
		case kCCUnspecifiedError:
			NSLog(@"kCCUnspecifiedError");
			break;
		case kCCCallSequenceError:
			NSLog(@"kCCCallSequenceError");
			break;
		case kCCKeySizeError:
			NSLog(@"kCCKeySizeError");
			break;

		default:
			break;
	}
}

- (NSData *)encrypt:(CCAlgorithm)alg key:(NSData *)key iv:(NSData *)iv options:(CCOptions)options {
	NSUInteger length = ceil((double)self.length / iv.length) * iv.length;
	NSMutableData *data = [NSMutableData dataWithLength:length];
	size_t dataOutMoved = 0;
	CCCryptorStatus status = CCCrypt(kCCEncrypt, alg, options, key.bytes, key.length, iv.bytes, self.bytes, self.length, data.mutableBytes, data.length, &dataOutMoved);
	[self logCryptorStatus:status];
	return status == kCCSuccess ? [data subdataWithRange:NSMakeRange(0, dataOutMoved)] : Nil;
}

- (NSData *)decrypt:(CCAlgorithm)alg key:(NSData *)key iv:(NSData *)iv options:(CCOptions)options {
	NSMutableData *data = [NSMutableData dataWithLength:self.length];
	size_t dataOutMoved = 0;
	CCCryptorStatus status = CCCrypt(kCCDecrypt, alg, options, key.bytes, key.length, iv.bytes, self.bytes, self.length, data.mutableBytes, data.length, &dataOutMoved);
	[self logCryptorStatus:status];
	return status == kCCSuccess ? [data subdataWithRange:NSMakeRange(0, dataOutMoved)] : Nil;
}

- (instancetype)hash:(COMMON_DIGEST)commonDigest {
	NSUInteger digestLength = commonDigest == MD2 ? CC_MD2_DIGEST_LENGTH : commonDigest == MD4 ? CC_MD4_DIGEST_LENGTH : commonDigest == MD5 ? CC_MD5_DIGEST_LENGTH : commonDigest == SHA1 ? CC_SHA1_DIGEST_LENGTH : commonDigest == SHA224 ? CC_SHA224_DIGEST_LENGTH : commonDigest == SHA256 ? CC_SHA256_DIGEST_LENGTH : commonDigest == SHA384 ? CC_SHA384_DIGEST_LENGTH : commonDigest == SHA512 ? CC_SHA512_DIGEST_LENGTH : 0;

	if (digestLength == 0)
		return Nil;

	NSMutableData *data = [NSMutableData dataWithLength:digestLength];

	if (commonDigest == MD2)
		CC_MD2(self.bytes, (CC_LONG)self.length, data.mutableBytes);
	else if (commonDigest == MD4)
		CC_MD4(self.bytes, (CC_LONG)self.length, data.mutableBytes);
	else if (commonDigest == MD5)
		CC_MD5(self.bytes, (CC_LONG)self.length, data.mutableBytes);
	else if (commonDigest == SHA1)
		CC_SHA1(self.bytes, (CC_LONG)self.length, data.mutableBytes);
	else if (commonDigest == SHA224)
		CC_SHA224(self.bytes, (CC_LONG)self.length, data.mutableBytes);
	else if (commonDigest == SHA256)
		CC_SHA256(self.bytes, (CC_LONG)self.length, data.mutableBytes);
	else if (commonDigest == SHA384)
		CC_SHA384(self.bytes, (CC_LONG)self.length, data.mutableBytes);
	else if (commonDigest == SHA512)
		CC_SHA512(self.bytes, (CC_LONG)self.length, data.mutableBytes);

	return data;
}

- (instancetype)hmac:(CCHmacAlgorithm)algorithm key:(NSData *)key {
	NSMutableData *macOut = [NSMutableData dataWithLength:algorithm == kCCHmacAlgSHA1 ? CC_SHA1_DIGEST_LENGTH : algorithm == kCCHmacAlgMD5 ? CC_MD5_DIGEST_LENGTH : algorithm == kCCHmacAlgSHA256 ? CC_SHA256_DIGEST_LENGTH : algorithm == kCCHmacAlgSHA384 ? CC_SHA384_DIGEST_LENGTH : algorithm == kCCHmacAlgSHA512 ? CC_SHA512_DIGEST_LENGTH : algorithm == kCCHmacAlgSHA224 ? CC_SHA224_DIGEST_LENGTH : 0];

	CCHmac(algorithm, key.bytes, key.length, self.bytes, self.length, macOut.mutableBytes);

	return macOut;
}

@end

@implementation NSString (CommonCrypto)

- (NSData *)encrypt:(CCAlgorithm)alg key:(NSData *)key iv:(NSData *)iv options:(CCOptions)options {
	return [[self dataUsingEncoding:NSUTF8StringEncoding] encrypt:alg key:key iv:iv options:options];
}

- (NSData *)decrypt:(CCAlgorithm)alg key:(NSData *)key iv:(NSData *)iv options:(CCOptions)options {
	return [[self dataUsingEncoding:NSUTF8StringEncoding] decrypt:alg key:key iv:iv options:options];
}

- (NSData *)hash:(COMMON_DIGEST)commonDigest {
	return [[self dataUsingEncoding:NSUTF8StringEncoding] hash:commonDigest];
}

- (NSData *)hmac:(CCHmacAlgorithm)algorithm key:(NSString *)key {
	const char *str = [self cStringUsingEncoding:NSUTF8StringEncoding];
	const char *keyStr  = [key cStringUsingEncoding:NSUTF8StringEncoding];

	NSMutableData *macOut = [NSMutableData dataWithLength:algorithm == kCCHmacAlgSHA1 ? CC_SHA1_DIGEST_LENGTH : algorithm == kCCHmacAlgMD5 ? CC_MD5_DIGEST_LENGTH : algorithm == kCCHmacAlgSHA256 ? CC_SHA256_DIGEST_LENGTH : algorithm == kCCHmacAlgSHA384 ? CC_SHA384_DIGEST_LENGTH : algorithm == kCCHmacAlgSHA512 ? CC_SHA512_DIGEST_LENGTH : algorithm == kCCHmacAlgSHA224 ? CC_SHA224_DIGEST_LENGTH : 0];

	CCHmac(algorithm, keyStr, strlen(keyStr), str, strlen(str), macOut.mutableBytes);

	return macOut;
}

@end
