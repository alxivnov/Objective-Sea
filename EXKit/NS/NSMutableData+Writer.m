//
//  NSMutableData+Writer.m
//  Guardian
//
//  Created by Alexander Ivanov on 09.11.14.
//  Copyright (c) 2014 NATEK. All rights reserved.
//

#import "NSMutableData+Writer.h"

@implementation NSMutableData (Writer)

- (void)appendByte:(unsigned char)value {
	[self appendBytes:&value length:sizeof(value)];
}

- (void)appendInt:(int)value {
	[self appendBytes:&value length:sizeof(value)];
}

- (void)appendUnsignedInt:(unsigned int)value {
	[self appendBytes:&value length:sizeof(value)];
}

- (void)appendUUID:(NSUUID *)uuid {
	void *bytes = malloc(NSUUIDSize);
	
	[uuid getUUIDBytes:bytes];
	
	[self appendBytes:bytes length:NSUUIDSize];
	
	free(bytes);
}

- (void)resetBytes {
	[self resetBytesInRange:NSMakeRange(0, self.length)];
}

@end
