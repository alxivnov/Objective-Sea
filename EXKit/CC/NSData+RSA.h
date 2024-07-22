//
//  NSData+Crypto.h
//  Guardian
//
//  Created by Alexander Ivanov on 27.08.14.
//  Copyright (c) 2014 NATEK. All rights reserved.
//

#import "CCRSAKey.h"

@interface NSData (RSA)

- (NSData *)encrypt:(CCRSAKey *)key withPrefix:(in NSDictionary *)prefix;

- (NSDictionary *)getPrefix:(CCRSAKey *)key andLength:(out NSUInteger *)length;

- (NSData *)decrypt:(CCRSAKey *)key withPrefix:(out NSDictionary **)prefix;

@end
