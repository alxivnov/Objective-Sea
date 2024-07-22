//
//  NSString+Crypto.h
//  Guardian
//
//  Created by Alexander Ivanov on 27.08.14.
//  Copyright (c) 2014 NATEK. All rights reserved.
//

#import "CCRSAKey.h"

@interface NSString (RSA)

- (NSString *)encrypt:(CCRSAKey *)key;

- (NSString *)decrypt:(CCRSAKey *)key;

- (NSString *)decryptWithKeys:(NSArray *)collection;

@end
