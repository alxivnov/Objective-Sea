//
//  Poloniex.m
//  Coins
//
//  Created by Alexander Ivanov on 13.12.2017.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import "Poloniex.h"

@interface Poloniex ()
@property (strong, nonatomic, readonly) NSString *apiKey;
@property (strong, nonatomic, readonly) NSString *secret;
@end

@implementation Poloniex

- (instancetype)initWithApiKey:(NSString *)apiKey secret:(NSString *)secret {
	self = [self init];

	if (self) {
		_apiKey = apiKey;
		_secret = secret;
	}

	return self;
}

- (NSURLSessionDataTask *)tradingApiCommand:(NSString *)command parameters:(NSDictionary *)parameters handler:(void (^)(NSDictionary *))handler {
	NSMutableString *body = [NSMutableString stringWithFormat:@"command=%@&nonce=%.0f", command, [NSDate date].timeIntervalSinceReferenceDate * 10];
	for (id key in parameters)
		[body appendFormat:@"&%@=%@", key, parameters[key]];
	NSString *hmac = [[body hmac:kCCHmacAlgSHA512 key:self.secret] hexString];

	return [[NSURL URLWithString:@"https://poloniex.com/tradingApi"] sendRequestWithMethod:@"POST" header:@{ @"Key" : self.apiKey, @"Sign" : hmac } body:[body dataUsingEncoding:NSUTF8StringEncoding] completion:^(NSData *data, NSURLResponse *response) {
		NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data];

		if (handler)
			handler(json[@"error"] ? Nil : json);

		[json[@"error"] log:@"tradingApiCommand:"];
	}];
}

+ (NSURLSessionDataTask *)publicCommand:(NSString *)command handler:(void (^)(NSDictionary *))handler {
	return [[NSURL URLWithString:[NSString stringWithFormat:@"https://poloniex.com/public?command=%@", command]] sendRequestWithMethod:@"GET" header:Nil json:Nil completion:^(id json, NSURLResponse *response) {
		if (handler)
			handler(json[@"error"] ? Nil : json);

		[json[@"error"] log:@"publicCommand:"];
	}];
}

@end
