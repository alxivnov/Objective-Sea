//
//  NSURL+Crypto.m
//  Guardian
//
//  Created by Alexander Ivanov on 26.09.14.
//  Copyright (c) 2014 NATEK. All rights reserved.
//

#import "CCAESInputStream.h"
#import "CCAESOutputStream.h"
#import "CCHasher.h"
#import "NSFormatter+Convenience.h"
#import "NSData+RSA.h"
#import "NSDictionary+Convenience.h"
#import "NSURL+RSA.h"

@implementation NSURL (RSA)

- (BOOL)isGRD {
	return [[self pathExtension] isEqualToString:EXT_ATOMIC];
}

- (BOOL)isGRDX {
	return [[self pathExtension] isEqualToString:EXT_ATOMIC_X];
}

- (NSURL *)encrypt:(CCRSAKey *)key prefix:(NSDictionary *)prefix path:(NSURL *)path delete:(BOOL)flag {
	if (![self checkResourceIsReachableAndReturnError:Nil])
		return Nil;
	
	if (!key)
		return Nil;
	
	if ([path isExistingDirectory])
		path = [[self URLByChangingPathExtension:[prefix[PREFIX_LEVEL] unsignedIntegerValue] > 0 ? EXT_ATOMIC_X : EXT_ATOMIC] URLByChangingPath:path];
	
	NSInputStream *input = [NSInputStream inputStreamWithURL:self];
	CCAESOutputStream *output = [CCAESOutputStream createWithKey:Nil URL:path];
	[input open];
	[output open];
	BOOL success = [output encrypt:key fromStream:input withPrefix:prefix];
	[output close];
	[input close];
	
	if (flag)
		[self removeItem];
	
	return success ? path : Nil;
}

- (NSURL *)encrypt:(CCRSAKey *)key guid:(NSUUID *)uuid level:(NSUInteger)level path:(NSURL *)path delete:(BOOL)flag {
	if (![self checkResourceIsReachableAndReturnError:Nil])
		return Nil;

	if (!key)
		return Nil;

	if (!uuid)
		uuid = [NSUUID UUID];

//	if ([path isExistingDirectory])
//		path = [[self URLByChangingPathExtension:level > 0 ? EXT_ATOMIC_X : EXT_ATOMIC] URLByChangingPath:path];

	NSString *extension = [self pathExtension];
	NSData *hash = [CCHasher hash:HASH_ALGORITHM_SHA256 fromURL:self];
	NSDictionary *prefix = extension ? @{
		PREFIX_LEVEL : [NSNumber numberWithUnsignedChar:level],
		PREFIX_FLAG : [NSNumber numberWithUnsignedInt:AES_MODE_CTR],
		PREFIX_GUID : uuid,
		PREFIX_HASH : hash,
		PREFIX_EXTENSION : extension,
	} : @{
		PREFIX_LEVEL : [NSNumber numberWithUnsignedChar:level],
		PREFIX_FLAG : [NSNumber numberWithUnsignedInt:AES_MODE_CTR],
		PREFIX_GUID : uuid,
		PREFIX_HASH : hash,
	};
	
//	NSData *data = [CCRSAHelper dataFromPrefix:p];
//	[data writeToURL:path atomically:YES];
	
	return [self encrypt:key prefix:prefix path:path delete:flag];
}

- (NSDictionary *)getPrefix:(CCRSAKey *)key {
	CCAESInputStream *stream = [CCAESInputStream createWithKey:Nil URL:self];

	NSUInteger length = 0;
	NSDictionary *prefix = [stream getPrefix:key andLength:&length];

	return prefix && length ? prefix : Nil;
}

- (NSDictionary *)getPrefixWithKeys:(NSArray *)keys {
	NSUInteger length = 0;
	NSDictionary *prefix = Nil;

	for (CCRSAKey *key in keys) {
		CCAESInputStream *stream = [CCAESInputStream createWithKey:Nil URL:self];
		[stream open];
		prefix = [stream getPrefix:key andLength:&length];
		[stream close];
		if (prefix && length)
			return prefix;
	}

	return Nil;
}

- (NSURL *)decryptWithSomething:(id)something prefix:(out NSDictionary *__autoreleasing *)prefix level:(NSUInteger)level path:(NSURL *)path delete:(BOOL)flag {
	if (!something)
		return Nil;

	if (![self checkResourceIsReachableAndReturnError:Nil])
		return Nil;

	if (![self isGRD] && ![self isGRDX])
		return Nil;

	if (level == 0 && [self isGRDX])
		return [[NSURL alloc] init];

	NSURL *temp = [(path ? path : [NSFileManager URLForDirectory:NSDocumentDirectory]) URLByAppendingPathComponent:[[NSDate date] timestampDescription]];
	BOOL success = NO;
	NSDictionary *p = Nil;
	if ([something isKindOfClass:[CCRSAKey class]]) {
		CCRSAKey *key = something;
		
		CCAESInputStream *input = [CCAESInputStream createWithKey:Nil URL:self];
		NSOutputStream *output = [NSOutputStream outputStreamWithURL:temp append:NO];
		[input open];
		[output open];
		success = [input decrypt:key toStream:output withPrefix:&p];
		[output close];
		[input close];
	} else if ([something isKindOfClass:[NSArray class]]) {
		NSArray *keys = something;

		for (NSUInteger index = 0; index < keys.count; index++) {
			CCRSAKey *key = keys[index];
			
			CCAESInputStream *input = [CCAESInputStream createWithKey:Nil URL:self];
			NSOutputStream *output = [NSOutputStream outputStreamWithURL:temp append:NO];
			[input open];
			[output open];
			success = [input decrypt:key toStream:output withPrefix:&p];
			[output close];
			[input close];
			
			if (success && p) {
				p = [p dictionaryWithObjects:@[ @(index), self ] forKeys:@[ PREFIX_INDEX, PREFIX_URL ]];
				
				break;
			}
		}
	}

	if (!success || !p)
		return [NSURL new];

//	NSDictionary *p = [CCRSAHelper prefixFromData:data];
	if (prefix)
		*prefix = p;

	NSData *hash = [CCHasher hash:HASH_ALGORITHM_SHA256 fromURL:temp];
	if (([p[PREFIX_LEVEL] unsignedIntegerValue] > RSA_UNCLASSIFIED && level == RSA_UNCLASSIFIED) || ![hash isEqualToData:p[PREFIX_HASH]]) {
		[temp removeItem];
		
		return [[NSURL alloc] init];
	}

	path = [[self URLByChangingPathExtension:p[PREFIX_EXTENSION]] URLByChangingPath:path];

	path = [temp moveItem:path overwrite:YES];

	if (flag)
		[self removeItem];

	return path;
}

- (NSURL *)decrypt:(CCRSAKey *)key prefix:(out NSDictionary *__autoreleasing *)prefix level:(NSUInteger)level path:(NSURL *)path delete:(BOOL)flag {
	return [self decryptWithSomething:key prefix:prefix level:level path:path delete:flag];
}

- (NSURL *)decryptWithKeys:(NSArray *)keys prefix:(out NSDictionary *__autoreleasing *)prefix level:(NSUInteger)level path:(NSURL *)path delete:(BOOL)flag {
	return [self decryptWithSomething:keys prefix:prefix level:level path:path delete:flag];
}

@end
