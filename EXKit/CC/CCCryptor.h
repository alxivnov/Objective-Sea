//
//  CCCryptor.h
//  Guardian
//
//  Created by Alexander Ivanov on 16.02.15.
//  Copyright (c) 2015 NATEK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CommonCrypto/CommonCrypto.h>

@interface CCCryptor : NSObject

@property (assign, nonatomic, readonly) BOOL needsFinish;

- (NSData *)update:(NSData *)data;
- (NSData *)finish;

+ (instancetype)aesDecryptor:(CCAESKey *)key mode:(AES_MODE)mode;
+ (instancetype)aesEncryptor:(CCAESKey *)key mode:(AES_MODE)mode;

+ (NSData *)generateRandomData:(NSUInteger)length;

@end
