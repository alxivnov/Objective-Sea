//
//  NSMutableDictionary+Crypto.m
//  Guardian
//
//  Created by Alexander Ivanov on 09.11.14.
//  Copyright (c) 2014 NATEK. All rights reserved.
//

#import "NSDictionary+Unlock.h"
#import "NSMutableDictionary+Lock.h"

@implementation NSMutableDictionary (Lock)

- (void)setLocked:(BOOL)locked {
	self[DICTIONARY_LOCKED] = [NSNumber numberWithBool:locked];
}

- (void)lock:(NSString *)key data:(NSData *)data with:(CCAESKey *)aes {
	self[key] = aes ? [aes encrypt:data] : data;
}

- (void)lock:(NSString *)key data:(NSData *)data {
	self[key] = [self getLocked] ? [CCAESKey encrypt:data] : data;
}

@end
