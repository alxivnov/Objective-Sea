//
//  Poloniex.h
//  Coins
//
//  Created by Alexander Ivanov on 13.12.2017.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSURLSession+Convenience.h"

@interface Poloniex : NSObject

- (instancetype)initWithApiKey:(NSString *)apiKey secret:(NSString *)secret;

- (NSURLSessionDataTask *)tradingApiCommand:(NSString *)command parameters:(NSDictionary *)parameters handler:(void (^)(NSDictionary *json))handler;

+ (NSURLSessionDataTask *)publicCommand:(NSString *)command handler:(void (^)(NSDictionary *json))handler;

@end
