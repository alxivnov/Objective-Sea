//
//  VKAPI.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 28.05.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import "VKAPI.h"

#define URL_TOKEN @"https://oauth.vk.com/token"
#define URL_METHOD @"https://api.vk.com/method"

#import <VKSdk/VKSdk.h>

@implementation NSError (VKAPI)

+ (instancetype)errorWithUserInfo:(NSDictionary *)dict {
	if (![NSError userInfoValueProviderForDomain:@"VKAPI"])
		[NSError setUserInfoValueProviderForDomain:@"VKAPI" provider:^id _Nullable(NSError * _Nonnull err, NSString * _Nonnull userInfoKey) {
			if ([userInfoKey isEqualToString:NSLocalizedDescriptionKey])
				return err.userInfo[@"error_msg"];

			return Nil;
		}];

	return dict ? [self errorWithDomain:@"VKAPI" code:[dict[@"error_code"] integerValue] userInfo:dict] : Nil;
}

@end

@interface VKAPI ()
@property (strong, nonatomic, readonly) NSUserDefaults *defaults;
@end

@implementation VKAPI

__synthesize(NSUserDefaults *, defaults, [NSUserDefaults standardUserDefaults])

__property(NSString *, version, @"5.64")

- (NSString *)accessToken {
	NSString *vkToken = [VKSdk getAccessToken].accessToken;
	NSString *myToken = [self.defaults objectForKey:@"VKAPI.accessToken"];
	return vkToken ?: myToken;
}

- (void)setAccessToken:(NSString *)accessToken {
	[self.defaults setObject:accessToken forKey:@"VKAPI.accessToken"];
}

- (NSURLSessionDataTask *)authorizeWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret scope:(NSUInteger)scope username:(NSString *)username password:(NSString *)password handler:(void (^)(NSDictionary *))handler {
	return clientID && clientSecret && username && password ? [[[NSURL URLWithString:URL_TOKEN] URLByAppendingQueryDictionary:@{ @"grant_type" : @"password", @"client_id" : clientID, @"client_secret" : clientSecret, @"username" : username, @"password" : password }] sendRequestWithMethod:Nil header:self.userAgent ? @{ @"User-Agent" : self.userAgent } : Nil json:Nil completion:^(id json, NSURLResponse *response) {
		NSDictionary *dic = cls(NSDictionary, json);

		self.accessToken = dic[@"access_token"];

		if (handler)
			handler(dic);
	}] : Nil;
}

- (NSURLSessionDataTask *)executeMethod:(NSString *)method params:(NSDictionary *)params handler:(void(^)(id response, NSError *error))handler {
	if (!method)
		return Nil;

	if (self.accessToken && !params[VK_PARAM_ACCESS_TOKEN])
		params = [params dictionaryWithObject:self.accessToken forKey:VK_PARAM_ACCESS_TOKEN];
	if (self.version && !params[VK_PARAM_V])
		params = [params dictionaryWithObject:self.version forKey:VK_PARAM_V];

	NSDictionary *header = self.userAgent ? @{ @"User-Agent" : self.userAgent } : Nil;

	return [[[[NSURL URLWithString:URL_METHOD] URLByAppendingPathComponent:method] URLByAppendingQueryDictionary:params] sendRequestWithMethod:Nil header:header json:Nil completion:^(id json, NSURLResponse *response) {
		NSDictionary *dic = cls(NSDictionary, json);
		id jsonResponse = dic[@"response"];
		id jsonError = dic[@"error"];

		if (handler)
			handler(jsonResponse, [NSError errorWithUserInfo:jsonError]);
	}];
}

- (NSURLSessionDataTask *)getAudio:(void (^)(NSArray<VKAudioItem *> *))handler {
	return [self executeMethod:VK_METHOD_AUDIO_GET params:@{ } handler:^(id response, NSError *error) {
		NSDictionary *dic = cls(NSDictionary, response);

		if (handler)
			handler([dic[VK_PARAM_ITEMS] map:^id(id obj) {
				return [[VKAudioItem alloc] initWithDictionary:obj];
			}]);

		[error log:VK_METHOD_AUDIO_GET];
	}];
}

- (NSURLSessionDataTask *)searchAudio:(NSString *)query handler:(void(^)(NSArray<VKAudioItem *> *))handler {
/*
	return query ? [self execute:[NSString stringWithFormat:@"return API.audio.get({\"q\":\"beatles\",\"count\":10,\"sort\":2,\"auto_complete\":1,\"offset\":0,\"lang\":\"ru\"});", query] handler:^(id json) {
		NSDictionary *dic = cls(NSDictionary, json);

		if (handler)
		handler([dic[@"items"] map:^id(id obj) {
			return [[VKAudioItem alloc] initWithDictionary:obj];
		}]);
	}] : Nil;
*/
	return query ? [self executeMethod:VK_METHOD_AUDIO_SEARCH params:@{ VK_PARAM_Q : query } handler:^(id response, NSError *error) {
		NSDictionary *dic = cls(NSDictionary, response);

		if (handler)
			handler([dic[VK_PARAM_ITEMS] map:^id(id obj) {
				return [[VKAudioItem alloc] initWithDictionary:obj];
			}]);

		[error log:VK_METHOD_AUDIO_SEARCH];
	}] : Nil;
}

- (NSURLSessionDataTask *)getUsers:(NSArray *)userIDs fields:(NSArray *)fields nameCase:(NSString *)nameCase handler:(void (^)(NSArray<VKUserItem *> *))handler {
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
	if (userIDs)
		params[VK_PARAM_USER_IDS] = [userIDs componentsJoinedByString:STR_COMMA];
	if (fields)
		params[VK_PARAM_FIELDS] = [fields componentsJoinedByString:STR_COMMA];
	if (nameCase)
		params[VK_PARAM_NAME_CASE] = nameCase;

	return [self executeMethod:VK_METHOD_USERS_GET params:params handler:^(id response, NSError *error) {
		NSDictionary *dic = cls(NSDictionary, response);

		if (handler)
			handler([dic[VK_PARAM_ITEMS] map:^id(id obj) {
				return [[VKUserItem alloc] initWithDictionary:obj];
			}]);

		[error log:VK_METHOD_USERS_GET];
	}];
}

- (NSURLSessionDataTask *)executeCode:(NSString *)code handler:(void(^)(id))handler {
	return code ? [self executeMethod:@"execute" params:@{ @"code" : code } handler:^(id response, NSError *error) {
		if (handler)
			handler(response);
	}] : Nil;
}

__static(VKAPI *, api, [[self alloc] init])

@end
