//
//  CommonCrypto+Convenience.h
//  Sleep Diary
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CommonCrypto/CommonDigest.h>

@interface NSData (MD5)

- (NSString *)MD5;

@end

@interface NSString (MD5)

- (NSString *)MD5;

@end

@interface NSData (Hash)

- (NSUUID *)md5;

- (NSData *)md5AsData;

- (NSMutableData *)md5AsMutableData;

- (long)md5AsLong;

@end

@interface NSString (Hash)

- (NSUUID *)md5;

- (NSData *)md5AsData;

- (NSMutableData *)md5AsMutableData;

- (long)md5AsLong;

@end
