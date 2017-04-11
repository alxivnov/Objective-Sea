//
//  FBAPIGraph.h
//  Crowd Guard
//
//  Created by Alexander Ivanov on 11.04.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSDictionary+Convenience.h"
#import "NSURLSession+Convenience.h"

@interface FBAPIGraph : NSObject

@property (strong, nonatomic, readonly) NSString *accessToken;

- (instancetype)initWithAccessToken:(NSString *)accessToken;

- (NSURLSessionDataTask *)startRequestWithGraphPath:(NSString *)graphPath parameters:(NSDictionary *)parameters completion:(void (^)(NSDictionary *json))completion;

@end
