//
//  CCRSAHelper.m
//  Guardian
//
//  Created by Alexander Ivanov on 08.05.15.
//  Copyright (c) 2015 NATEK. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "CCRSAHelper.h"
#import "NSMutableData+Writer.h"
#import "NSString+Data.h"

@implementation CCRSAHelper

+ (NSData *)dataFromPrefix:(NSDictionary *)prefix {
	if (!prefix.count)
		return Nil;
	
	NSMutableData *data = [NSMutableData data];
	
	[data appendByte:((NSNumber *)prefix[PREFIX_LEVEL]).unsignedCharValue];
	[data appendUnsignedInt:((NSNumber *)prefix[PREFIX_FLAG]).unsignedIntValue];
	[data appendUUID:prefix[PREFIX_GUID]];
	[data appendData:prefix[PREFIX_HASH]];
	NSString *extension = prefix[PREFIX_EXTENSION];
	if (extension)
		[data appendData:[[STR_DOT stringByAppendingString:extension] dataUsingDotNetEncoding]];
	
	return data;
}

+ (NSDictionary *)prefixFromData:(NSData *)data {
	if (!data.length)
		return Nil;
	
	unsigned char level = [data getByte];
	unsigned int flag = [data getUnsignedIntFromIndex:1];
	NSUUID *uuid = [data getUUIDFromIndex:1 + sizeof(int)];
	NSData *hash = [data getDataFromRange:NSMakeRange(1 + sizeof(int) + NSUUIDSize, CC_SHA256_DIGEST_LENGTH)];
	NSString *extension = [[[data getDataFromIndex:1 + sizeof(int) + NSUUIDSize + CC_SHA256_DIGEST_LENGTH] stringUsingDotNetEncoding] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:STR_DOT]];
	
	return extension ? @{
		PREFIX_LEVEL : [NSNumber numberWithUnsignedChar:level],
		PREFIX_FLAG : [NSNumber numberWithUnsignedInt:flag],
		PREFIX_GUID : uuid,
		PREFIX_HASH : hash,
		PREFIX_EXTENSION : extension,
	} : @{
		PREFIX_LEVEL : [NSNumber numberWithUnsignedChar:level],
		PREFIX_FLAG : [NSNumber numberWithUnsignedInt:flag],
		PREFIX_GUID : uuid,
		PREFIX_HASH : hash,
	};
}

@end
