//
//  NSDictionary+Crypto.h
//  Guardian
//
//  Created by Alexander Ivanov on 09.11.14.
//  Copyright (c) 2014 NATEK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCAESKey.h"

#define DICTIONARY_LOCKED @"LOCKED"

@interface NSDictionary (Unlock)

- (BOOL)getLocked;

- (NSData *)unlock:(NSString *)key with:(CCAESKey *)aes;
- (NSData *)unlock:(NSString *)key;

@end
