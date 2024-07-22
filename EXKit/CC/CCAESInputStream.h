//
//  CCAESInputStream.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 13.02.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCAESKey.h"
#import "CCRSAKey.h"

@interface CCAESInputStream : NSObject

@property (strong, nonatomic, readonly) NSInputStream *stream;

- (void)open;
- (void)close;

- (NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len;

- (BOOL)getBuffer:(uint8_t **)buffer length:(NSUInteger *)len;

@property (readonly) BOOL hasBytesAvailable;

+ (instancetype)createWithKey:(CCAESKey *)key stream:(NSInputStream *)stream;
+ (instancetype)createWithKey:(CCAESKey *)key data:(NSData *)data;
+ (instancetype)createWithKey:(CCAESKey *)key URL:(NSURL *)url;

- (NSDictionary *)getPrefix:(CCRSAKey *)key andLength:(out NSUInteger *)length;
- (BOOL)decrypt:(CCRSAKey *)key toStream:(NSOutputStream *)cleartext withPrefix:(out NSDictionary **)prefix;

@end
