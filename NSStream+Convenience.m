//
//  NSStream+Convenience.m
//  Guardian
//
//  Created by Alexander Ivanov on 16.12.16.
//  Copyright © 2016 NATEK. All rights reserved.
//

#import "NSStream+Convenience.h"

@implementation NSInputStream (Convenience)

- (NSData *)readData:(NSUInteger)length {
	if (length == 0)
		return Nil;

	void *bytes = malloc(length);
	NSInteger read = [self read:bytes maxLength:length];
	return [NSData dataWithBytesNoCopy:bytes length:read freeWhenDone:YES];
}

- (NSData *)readData {
	NSMutableData *data = [NSMutableData new];
	while ([self hasBytesAvailable])
		[data appendData:[self readData:MEM_PAGE_SIZE]];
	return data;
}

- (unsigned char)readByte {
	unsigned char value = 0;

	void *buffer = &value;
	NSUInteger size = sizeof(value);
	if ([self read:buffer maxLength:size] < size)
		return 0;

	return value;
}

- (int)readInt {
	int value = 0;

	void *buffer = &value;
	NSUInteger size = sizeof(value);
	if ([self read:buffer maxLength:size] < size)
		return 0;

	return value;
}

- (BOOL)copyToStream:(id)stream withBufferSize:(NSUInteger)size {
	NSInteger length = 0;

	uint8_t *buffer = malloc(size);

	while ([self hasBytesAvailable] && [stream hasSpaceAvailable]) {
		length = [self read:buffer maxLength:size];
		if (length <= 0)
			break;

		length = [stream write:buffer maxLength:length];
		if (length <= 0)
			break;
	}

	free(buffer);

	return length >= 0;
}

- (BOOL)copyToStream:(id)stream {
	return [self copyToStream:stream withBufferSize:MEM_PAGE_SIZE];
}

@end

@implementation NSOutputStream (Convenience)

- (void)writeByte:(unsigned char)value {
	void *buffer = &value;
	[self write:buffer maxLength:sizeof(value)];
}

- (void)writeInt:(int)value {
	void *buffer = &value;
	[self write:buffer maxLength:sizeof(value)];
}

- (void)writeData:(NSData *)data {
	[self write:data.bytes maxLength:data.length];
}

- (BOOL)copyFromStream:(id)stream withBufferSize:(NSUInteger)size {
	NSInteger length = 0;

	uint8_t *buffer = malloc(size);

	while ([self hasSpaceAvailable] && [stream hasBytesAvailable]) {
		length = [stream read:buffer maxLength:size];
		if (length <= 0)
			break;

		length = [self write:buffer maxLength:length];
		if (length <= 0)
			break;
	}

	free(buffer);

	return length >= 0;
}

- (BOOL)copyFromStream:(id)stream {
	return [self copyFromStream:stream withBufferSize:MEM_PAGE_SIZE];
}

- (NSData *)memory {
	return [self propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
}

@end
