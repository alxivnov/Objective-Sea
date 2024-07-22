//
//  NSMutableDictionary+Crypto.h
//  Guardian
//
//  Created by Alexander Ivanov on 09.11.14.
//  Copyright (c) 2014 NATEK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCAESKey.h"

@interface NSMutableDictionary (Lock)

- (void)setLocked:(BOOL)locked;

- (void)lock:(NSString *)key data:(NSData *)data with:(CCAESKey *)aes;
- (void)lock:(NSString *)key data:(NSData *)data;

@end
