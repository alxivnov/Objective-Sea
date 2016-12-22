//
//  NSStream+Convenience.h
//  Guardian
//
//  Created by Alexander Ivanov on 16.12.16.
//  Copyright © 2016 NATEK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSObject+Convenience.h"

@interface NSInputStream (Convenience)

- (unsigned char)readByte;
- (int)readInt;
- (NSData *)readData:(NSUInteger)length;
- (NSData *)readData;

- (BOOL)copyToStream:(id)stream withBufferSize:(NSUInteger)size;
- (BOOL)copyToStream:(id)stream;

@end

@interface NSOutputStream (Convenience)

- (void)writeByte:(unsigned char)value;
- (void)writeInt:(int)value;
- (void)writeData:(NSData *)data;

- (BOOL)copyFromStream:(id)stream withBufferSize:(NSUInteger)size;
- (BOOL)copyFromStream:(id)stream;

- (NSData *)memory;

@end
