//
//  RSAKeyValue.h
//  Guardian
//
//  Created by Alexander Ivanov on 26.08.14.
//  Copyright (c) 2014 NATEK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCKeyBase.h"

@interface CCRSAKey : CCKeyBase

@property (strong, nonatomic) NSData *d;
@property (strong, nonatomic) NSData *dp;
@property (strong, nonatomic) NSData *dq;
@property (strong, nonatomic) NSData *exponent;
@property (strong, nonatomic) NSData *inverseQ;
@property (strong, nonatomic) NSData *modulus;
@property (strong, nonatomic) NSData *p;
@property (strong, nonatomic) NSData *q;

@end
