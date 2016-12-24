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
@implementation NSData (Hash)

- (NSUUID *)md5 {
	unsigned char buffer[CC_MD5_DIGEST_LENGTH];

	CC_MD5(self.bytes, (CC_LONG)self.length, buffer);

	return [[NSUUID alloc] initWithUUIDBytes:buffer];
}

- (NSData *)md5AsData {
	unsigned char buffer[CC_MD5_DIGEST_LENGTH];

	CC_MD5(self.bytes, (CC_LONG)self.length, buffer);

	return [NSData dataWithBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}

- (NSMutableData *)md5AsMutableData {
	unsigned char buffer[CC_MD5_DIGEST_LENGTH];

	CC_MD5(self.bytes, (CC_LONG)self.length, buffer);

	return [NSMutableData dataWithBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}

- (long)md5AsLong {
	unsigned char buffer[CC_MD5_DIGEST_LENGTH];

	CC_MD5(self.bytes, (CC_LONG)self.length, buffer);

	long md5 = 0;
	memcpy(&md5, buffer, sizeof(md5));
	return md5;
}

@end

@implementation NSString (Hash)

- (NSUUID *)md5 {
	return [[self dataUsingEncoding:NSUnicodeStringEncoding] md5];
}

- (NSData *)md5AsData {
	return [[self dataUsingEncoding:NSUnicodeStringEncoding] md5AsData];
}

- (long)md5AsLong {
	return [[self dataUsingEncoding:NSUnicodeStringEncoding] md5AsLong];
}

- (NSMutableData *)md5AsMutableData {
	return [[self dataUsingEncoding:NSUnicodeStringEncoding] md5AsMutableData];
}

@end
