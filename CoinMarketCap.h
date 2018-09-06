//
//  CoinMarketCap.h
//  Coins
//
//  Created by Alexander Ivanov on 18.12.2017.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSURLSession+Convenience.h"

@interface CoinMarketCap : NSObject

+ (NSURLSessionDataTask *)ticker:(NSString *)symbol handler:(void(^)(NSArray<NSDictionary *> *ticker))handler;

+ (NSURLSessionDataTask *)tickerWithStart:(NSUInteger)start limit:(NSUInteger)limit handler:(void(^)(NSArray<NSDictionary *> *))handler;

+ (NSURLSessionDataTask *)global:(void(^)(NSDictionary *global))handler;

@end
