//
//  CommonCrypto+Convenience.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "CommonCrypto+Convenience.h"
/*
@implementation NSData (MD5)

- (NSString *)MD5 {
	// Create byte array of unsigned chars
	unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];

	// Create 16 byte MD5 hash value, store in buffer
	CC_MD5(self.bytes, (uint) self.length, md5Buffer);

	// Convert unsigned char buffer to NSString of hex values
	NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
		[output appendFormat:@"%02x", md5Buffer[i]];

	return output;
}

@end

@implementation NSString (MD5)

- (NSString *)MD5 {
	// Create pointer to the string as UTF8
	const char *ptr = [self UTF8String];

	// Create byte array of unsigned chars
	unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];

	// Create 16 bytes MD5 hash value, store in buffer
	CC_MD5(ptr, (uint) strlen(ptr), md5Buffer);

	// Convert unsigned char buffer to NSString of hex values
	NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
		[output appendFormat:@"%02x", md5Buffer[i]];

	return output;
}

@end
*/

@implementation NSData (CommonCrypto)

- (NSData *)hash:(COMMON_DIGEST)commonDigest {
	NSUInteger digestLength = commonDigest == MD2 ? CC_MD2_DIGEST_LENGTH : commonDigest == MD4 ? CC_MD4_DIGEST_LENGTH : commonDigest == MD5 ? CC_MD5_DIGEST_LENGTH : commonDigest == SHA1 ? CC_SHA1_DIGEST_LENGTH : commonDigest == SHA224 ? CC_SHA224_DIGEST_LENGTH : commonDigest == SHA256 ? CC_SHA224_DIGEST_LENGTH : commonDigest == SHA384 ? CC_SHA384_DIGEST_LENGTH : commonDigest == SHA512 ? CC_SHA512_DIGEST_LENGTH : 0;

	if (digestLength == 0)
		return Nil;

	unsigned char buffer[digestLength];

	if (commonDigest == MD2)
		CC_MD2(self.bytes, (CC_LONG)self.length, buffer);
	else if (commonDigest == MD4)
		CC_MD4(self.bytes, (CC_LONG)self.length, buffer);
	else if (commonDigest == MD5)
		CC_MD5(self.bytes, (CC_LONG)self.length, buffer);
	else if (commonDigest == SHA1)
		CC_SHA1(self.bytes, (CC_LONG)self.length, buffer);
	else if (commonDigest == SHA224)
		CC_SHA224(self.bytes, (CC_LONG)self.length, buffer);
	else if (commonDigest == SHA256)
		CC_SHA256(self.bytes, (CC_LONG)self.length, buffer);
	else if (commonDigest == SHA384)
		CC_SHA384(self.bytes, (CC_LONG)self.length, buffer);
	else if (commonDigest == SHA512)
		CC_SHA512(self.bytes, (CC_LONG)self.length, buffer);

	return [NSData dataWithBytes:buffer length:digestLength];
}

@end

@implementation NSString (CommonCrypto)

- (NSString *)hash:(COMMON_DIGEST)commonDigest {
	NSData *hash = [[self dataUsingEncoding:NSUTF8StringEncoding] hash:commonDigest];

	NSMutableString *string = [[NSMutableString alloc] initWithCapacity:hash.length * 2];

	unsigned char byte;
	for (NSUInteger index = 0; index < hash.length; index++) {
		[hash getBytes:&byte range:NSMakeRange(index, 1)];

		[string appendFormat:byte < 16 ? @"0%X" : @"%X", byte];
	}

	return string;
}

@end
