//
//  FBAPIGraph.m
//  Crowd Guard
//
//  Created by Alexander Ivanov on 11.04.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import "FBAPIGraph.h"

#define URL_GRAPH @"https://graph.facebook.com/v2.8/"

@interface FBAPIGraph ()
@property (strong, nonatomic, readonly) NSURL *url;
@end

@implementation FBAPIGraph

__synthesize(NSURL *, url, [NSURL URLWithString:URL_GRAPH])

- (instancetype)initWithAccessToken:(NSString *)accessToken {
	self = [self init];

	if (self)
		_accessToken = accessToken;

	return self;
}

- (NSURLSessionDataTask *)startRequestWithGraphPath:(NSString *)graphPath parameters:(NSDictionary *)parameters completion:(void (^)(NSDictionary *))completion {
	NSURL *url = [[self.url URLByAppendingPathComponent:graphPath] URLByAppendingQueryDictionary:[parameters dictionaryWithObject:self.accessToken forKey:@"access_token"]];
	return [url sendRequestWithMethod:@"GET" header:Nil json:Nil completion:^(id json, NSURLResponse *response) {
		if (completion)
			completion(cls(NSDictionary, json));
	}];
}

@end
