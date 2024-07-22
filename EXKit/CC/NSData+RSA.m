//
//  NSData+Crypto.m
//  Guardian
//
//  Created by Alexander Ivanov on 27.08.14.
//  Copyright (c) 2014 NATEK. All rights reserved.
//

#import "CCAESKey.h"
#import "CCAESInputStream.h"
#import "CCAESOutputStream.h"
#import "CCHasher.h"
#import "CCRSAHelper.h"
#import "NSData+RSA.h"
#import "NSMutableData+Writer.h"

@implementation NSData (RSA)

- (NSData *)encrypt:(CCRSAKey *)key withPrefix:(in NSDictionary *)prefix {
	NSInputStream *input = [NSInputStream inputStreamWithData:self];
	CCAESOutputStream *output = [CCAESOutputStream create];
	[input open];
	[output open];
	BOOL success = [output encrypt:key fromStream:input withPrefix:prefix];
	[output close];
	[input close];
	
	NSData *encrypted = success ? [output.stream memory] : Nil;
	return encrypted;
}

- (NSDictionary *)getPrefix:(CCRSAKey *)key andLength:(out NSUInteger *)length {
	CCAESInputStream *input = [CCAESInputStream createWithKey:Nil data:self];
	[input open];
	NSDictionary *prefix = [input getPrefix:key andLength:length];
	[input close];
	return prefix;
}

- (NSData *)decrypt:(CCRSAKey *)key withPrefix:(out NSDictionary **)prefix {
	CCAESInputStream *input = [CCAESInputStream createWithKey:Nil data:self];
	NSOutputStream *output = [NSOutputStream outputStreamToMemory];
	[input open];
	[output open];
	BOOL success = [input decrypt:key toStream:output withPrefix:prefix];
	[output close];
	[input close];
	
	NSData *cleartext = success ? [output memory] : Nil;
	
	NSData *hash = [CCHasher hash:HASH_ALGORITHM_SHA256 fromData:cleartext];
	if (![hash isEqualToData:(*prefix)[PREFIX_HASH]])
		return Nil;
	
	return cleartext;
}

@end
