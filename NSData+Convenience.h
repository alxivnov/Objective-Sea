//
//  NSData+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 19.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Convenience)

+ (NSData *)dataFromHexString:(NSString *)hexString;
- (NSString *)hexString;

- (NSString *)stringUsingDotNetEncoding;

- (NSData *)getDataFromRange:(NSRange)range;
- (NSData *)getDataFromIndex:(NSUInteger)index;

- (void)enumerateByteRangesUsingBlock:(void (^)(const void *bytes, NSRange range, BOOL *stop))block length:(NSUInteger)len;

- (instancetype)cutLeft:(NSUInteger)length;
- (instancetype)cutRight:(NSUInteger)length;

- (instancetype)padLeft:(NSUInteger)length;
- (instancetype)padRight:(NSUInteger)length;

@end

@interface NSData (Reader)

- (unsigned char)getByteFromIndex:(NSUInteger)index;
- (unsigned char)getByte;

- (int)getIntFromIndex:(NSUInteger)index;
- (int)getInt;

- (unsigned int)getUnsignedIntFromIndex:(NSUInteger)index;
- (unsigned int)getUnsignedInt;

- (NSUUID *)getUUIDFromIndex:(NSUInteger)index;
- (NSUUID *)getUUID;

@end

@interface NSData (Writer)

- (instancetype)initWithByte:(unsigned char)value;

- (instancetype)initWithInt:(int)value;

- (instancetype)initWithUnsignedInteger:(NSUInteger)value;

- (instancetype)initWithUUID:(NSUUID *)uuid;

@end
