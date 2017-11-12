//
//  Compression+Convenience.m
//  Trend
//
//  Created by Alexander Ivanov on 11.10.2017.
//  Copyright © 2017 Pine 9. All rights reserved.
//

#import "Compression+Convenience.h"

typedef enum : NSUInteger {
	COMPRESSION_ENCODE,
	COMPRESSION_DECODE,
} compression_operation;

@implementation NSData (Compression)

- (NSData *)compression:(compression_operation)operation algorithm:(compression_algorithm)algorithm {
	uint8_t *dst = malloc(self.length);

	size_t len = operation == COMPRESSION_DECODE ? compression_decode_buffer(dst, self.length, self.bytes, self.length, NULL, algorithm) : compression_encode_buffer(dst, self.length, self.bytes, self.length, NULL, algorithm);

	NSData *data = [NSData dataWithBytes:dst length:len];

	free(dst);

	return data;
}

- (NSData *)compress:(compression_algorithm)algorithm {
	return [self compression:COMPRESSION_ENCODE algorithm:algorithm];
}

- (NSData *)decompress:(compression_algorithm)algorithm {
	return [self compression:COMPRESSION_DECODE algorithm:algorithm];
}

@end
