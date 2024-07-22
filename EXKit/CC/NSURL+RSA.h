//
//  NSURL+Crypto.h
//  Guardian
//
//  Created by Alexander Ivanov on 26.09.14.
//  Copyright (c) 2014 NATEK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSCalendar+Convenience.h"
#import "NSDictionary+Convenience.h"

#import "CCRSAHelper.h"
#import "CCRSAKey.h"

#define EXT_ATOMIC @"grd"
#define EXT_ATOMIC_X @"grdx"

@interface NSURL (RSA)

- (BOOL)isGRD;
- (BOOL)isGRDX;

- (NSURL *)encrypt:(CCRSAKey *)key prefix:(NSDictionary *)prefix path:(NSURL *)path delete:(BOOL)flag;
- (NSURL *)encrypt:(CCRSAKey *)key guid:(NSUUID *)uuid level:(NSUInteger)level path:(NSURL *)path delete:(BOOL)flag;

- (NSDictionary *)getPrefix:(CCRSAKey *)key;
- (NSDictionary *)getPrefixWithKeys:(NSArray *)keys;

- (NSURL *)decrypt:(CCRSAKey *)key prefix:(out NSDictionary **)prefix level:(NSUInteger)level path:(NSURL *)path delete:(BOOL)flag;
- (NSURL *)decryptWithKeys:(NSArray *)keys prefix:(out NSDictionary **)prefix level:(NSUInteger)level path:(NSURL *)path delete:(BOOL)flag;

@end
