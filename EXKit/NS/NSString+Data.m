//
//  NSString+Data.m
//  Guardian
//
//  Created by Alexander Ivanov on 28.08.14.
//  Copyright (c) 2014 NATEK. All rights reserved.
//

#import "NSString+Data.h"

@implementation NSString (Data)

- (NSData *)toData {
	NSUInteger length = [self length] / 2;
	NSMutableData *data = [[NSMutableData alloc] initWithCapacity:length];
	
	unsigned char byte;
	char *end;
	for (NSUInteger index = 0; index < length; index++) {
		NSString *str = [self substringWithRange:NSMakeRange(index * 2, 2)];
		byte = strtoul([str UTF8String], &end, 16);
		if (*end != '\0')
			break;
		
		[data appendBytes:&byte length:1];
	}
	
	return data;
}

- (NSData *)dataUsingDotNetEncoding {
	return [self dataUsingEncoding:NSUTF16LittleEndianStringEncoding];
}

@end

@implementation NSMutableString (Reset)

- (void)reset {
	[self replaceCharactersInRange:NSMakeRange(0, [self length]) withString:@""];
}

@end
