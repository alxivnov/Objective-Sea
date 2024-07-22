//
//  NSMutableData+Writer.h
//  Guardian
//
//  Created by Alexander Ivanov on 09.11.14.
//  Copyright (c) 2014 NATEK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSUUID+Guid.h"

@interface NSMutableData (Writer)

- (void)appendByte:(unsigned char)value;

- (void)appendInt:(int)value;

- (void)appendUnsignedInt:(unsigned int)value;

- (void)appendUUID:(NSUUID *)uuid;

- (void)resetBytes;

@end
