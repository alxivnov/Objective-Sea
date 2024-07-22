//
//  NSDictionary+Crypto.m
//  Guardian
//
//  Created by Alexander Ivanov on 09.11.14.
//  Copyright (c) 2014 NATEK. All rights reserved.
//

#import "NSDictionary+Unlock.h"

@implementation NSDictionary (Unlock)

- (BOOL)getLocked {
	return [self[DICTIONARY_LOCKED] boolValue];
}

- (NSData *)unlock:(NSString *)key with:(CCAESKey *)aes {
	id x = self[key];
	
	return aes && [x isKindOfClass:[NSData class]] ? [aes decrypt:x] : x;
}

- (NSData *)unlock:(NSString *)key {
	id x = self[key];
	
	return [self getLocked] && [x isKindOfClass:[NSData class]] ? [CCAESKey decrypt:x] : x;
}

@end
