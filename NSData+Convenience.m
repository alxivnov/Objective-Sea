//
//  NSData+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 19.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "NSData+Convenience.h"

#define NSUUIDSize 16

@implementation NSData (Convenience)

+ (NSData *)dataWithBase64EncodedString:(NSString *)base64String {
	return base64String ? [[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters] : Nil;
}

+ (NSData *)dataFromHexString:(NSString *)hexString {
	NSUInteger length = [hexString length] / 2;

	NSMutableData *data = [[NSMutableData alloc] initWithCapacity:length];

	unsigned char byte;
	char *end;
	for (NSUInteger index = 0; index < length; index++) {
		NSString *str = [hexString substringWithRange:NSMakeRange(index * 2, 2)];
		byte = strtoul([str UTF8String], &end, 16);
		if (*end != '\0')
			break;

		[data appendBytes:&byte length:1];
	}

	return data;
}

- (NSString *)hexString {
	NSMutableString *string = [[NSMutableString alloc] initWithCapacity:self.length * 2];

	unsigned char byte;
	for (NSUInteger index = 0; index < self.length; index++) {
		[self getBytes:&byte range:NSMakeRange(index, 1)];

		[string appendFormat:byte < 16 ? @"0%X" : @"%X", byte];
	}

	return string;
}

- (NSString *)stringUsingDotNetEncoding {
	return [[NSString alloc] initWithData:self encoding:NSUTF16LittleEndianStringEncoding];
}

- (NSData *)getDataFromRange:(NSRange)range {
	NSUInteger length = self.length;

	if (range.location >= length || range.length == 0)
		return Nil;

	if (range.location + range.length > length)
		range = NSMakeRange(range.location, length - range.location);

	void *bytes = malloc(range.length);
	[self getBytes:bytes range:range];
	return [NSData dataWithBytesNoCopy:bytes length:range.length freeWhenDone:YES];
}

- (NSData *)getDataFromIndex:(NSUInteger)index {
	return [self getDataFromRange:NSMakeRange(index, self.length - index)];
}

- (void)enumerateByteRangesUsingBlock:(void (^)(const void *bytes, NSRange range, BOOL *stop))block length:(NSUInteger)len {
	NSUInteger loc = 0;
	while (loc < self.length) {
		const void *bytes = self.bytes + loc;
		NSRange range = NSMakeRange(loc, loc + len > self.length ? self.length - loc : len);
		BOOL stop = NO;

		block(bytes, range, &stop);

		loc = stop ? self.length : loc + range.length;
	}
}

- (instancetype)cutLeft:(NSUInteger)length {
	return self.length > length ? [NSMutableData dataWithBytes:self.bytes + (self.length - length) length:length] : self;
}

- (instancetype)cutRight:(NSUInteger)length {
	return self.length > length ? [NSMutableData dataWithBytes:self.bytes length:length] : self;
}

- (instancetype)padLeft:(NSUInteger)length {
	if (self.length >= length)
		return self;

	NSMutableData *data = [NSMutableData dataWithCapacity:length];
	[data setLength:length - self.length];
	[data appendData:self];
	return data;
}

- (instancetype)padRight:(NSUInteger)length {
	if (self.length >= length)
		return self;

	NSMutableData *data = [NSMutableData dataWithCapacity:length];
	[data appendData:self];
	[data setLength:length];
	return data;
}

@end

@implementation NSData (Reader)

- (unsigned char)getByteFromIndex:(NSUInteger)index {
	unsigned char value = 0;

	NSUInteger size = sizeof(value);
	if (index + size <= self.length)
		[self getBytes:&value range:NSMakeRange(index, size)];

	return value;
}

- (unsigned char)getByte {
	return [self getByteFromIndex:0];
}

- (int)getIntFromIndex:(NSUInteger)index {
	int value = 0;

	NSUInteger size = sizeof(value);
	if (index + size <= self.length)
		[self getBytes:&value range:NSMakeRange(index, size)];

	return value;
}

- (int)getInt {
	return [self getIntFromIndex:0];
}

- (unsigned int)getUnsignedIntFromIndex:(NSUInteger)index {
	unsigned int value = 0;

	NSUInteger size = sizeof(value);
	if (index + size <= self.length)
		[self getBytes:&value range:NSMakeRange(index, size)];

	return value;
}

- (unsigned int)getUnsignedInt {
	return [self getUnsignedIntFromIndex:0];
}

- (NSUUID *)getUUIDFromIndex:(NSUInteger)index {
	NSUUID *value = Nil;

	if (index + NSUUIDSize <= self.length) {
		void *bytes = malloc(NSUUIDSize);

		[self getBytes:bytes range:NSMakeRange(index, NSUUIDSize)];

		value = [[NSUUID alloc] initWithUUIDBytes:bytes];

		free(bytes);
	}

	return value;
}

- (NSUUID *)getUUID {
	return [self getUUIDFromIndex:0];
}

@end

@implementation NSData (Writer)

- (instancetype)initWithByte:(unsigned char)value {
	return [self initWithBytes:&value length:sizeof(value)];
}

- (instancetype)initWithInt:(int)value {
	return [self initWithBytes:&value length:sizeof(value)];
}

- (instancetype)initWithUnsignedInteger:(NSUInteger)value {
	return [self initWithBytes:&value length:sizeof(value)];
}

- (instancetype)initWithUUID:(NSUUID *)uuid {
	void *bytes = malloc(NSUUIDSize);

	[uuid getUUIDBytes:bytes];

	NSData *value = [self initWithBytesNoCopy:bytes length:NSUUIDSize];

	return value;
}

@end
