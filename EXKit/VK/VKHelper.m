//
//  VKHelper.m
//  Ringo
//
//  Created by Alexander Ivanov on 29.08.15.
//  Copyright (c) 2015 Alexander Ivanov. All rights reserved.
//

#import "VKHelper.h"

@implementation VKHelper

+ (VKRequest *)isMember:(NSUInteger)userID ofGroup:(NSUInteger)groupID handler:(void(^)(BOOL isMember))handler {
	if (!groupID)
		return Nil;

	NSMutableDictionary *paramters = [NSMutableDictionary new];
	paramters[VK_PARAM_GROUP_ID] = @(groupID);
	if (userID)
		paramters[VK_PARAM_USER_IDS] = [@(userID) description];
	VKRequest *request = [VKApi requestWithMethod:VK_METHOD_GROUPS_IS_MEMBER andParameters:paramters andHttpMethod:VK_HTTP_METHOD_GET];
	void(^block)(VKResponse *response, NSError *error) = ^(VKResponse *response, NSError *error) {
		if (handler)
			handler([response.json isKindOfClass:[NSArray class]] ? [[[response.json objectAtIndex:0] objectForKey:VK_PARAM_MEMBER] boolValue] : [response.json boolValue]);
	};
	if (userID)
		[self executeRequest:request handler:block];
	else
		[[self instance] executeRequest:request handler:block];
	return request;
}

+ (VKRequest *)joinGroup:(NSUInteger)ID handler:(void(^)(BOOL success))handler {
	if (!ID)
		return Nil;

	VKRequest *request = [VKApi requestWithMethod:VK_METHOD_GROUPS_JOIN andParameters:@{ VK_PARAM_GROUP_ID : @(ID) } andHttpMethod:VK_HTTP_METHOD_GET];
	[[self instance] executeRequest:request handler:^(VKResponse *response, NSError *error) {
		if (handler)
			handler([response.json boolValue]);
	}];
	return request;
}

+ (VKRequest *)searchNews:(NSString *)text handler:(void (^)(NSArray<VKWallItem *> *))handler {
	if (!text.length)
		return Nil;

	VKRequest *request = [VKApi requestWithMethod:VK_METHOD_NEWSFEED_SEARCH andParameters:@{ VK_PARAM_Q : text } andHttpMethod:VK_HTTP_METHOD_GET];
	[self executeRequest:request handler:^(VKResponse *response, NSError *error) {
		if (handler)
			handler([response.json[VK_PARAM_ITEMS] map:^id(id obj) {
				return [[VKWallItem alloc] initWithDictionary:obj];
			}]);
	}];
	return request;
}

+ (VKRequest *)searchAudio:(NSString *)text handler:(void(^)(NSArray<VKAudioItem *> *items))handler {
	if (!text.length)
		return Nil;

	NSString *v = [VKSdk instance].apiVersion;
	VKRequest *request = [VKApi requestWithMethod:VK_METHOD_AUDIO_SEARCH andParameters:v ? @{ VK_PARAM_Q : text, VK_PARAM_V : v } : @{ VK_PARAM_Q : text } andHttpMethod:VK_HTTP_METHOD_GET];
	[[self instance] executeRequest:request handler:^(VKResponse *response, NSError *error) {
		if (handler)
			handler([response.json[VK_PARAM_ITEMS] map:^id(id obj) {
				return [[VKAudioItem alloc] initWithDictionary:obj];
			}]);
	}];
	return request;
}

+ (VKRequest *)getAudio:(void (^)(NSArray<VKAudioItem *> *))handler {
	NSString *v = [VKSdk instance].apiVersion;
	VKRequest *request = [VKApi requestWithMethod:VK_METHOD_AUDIO_GET andParameters:v ? @{ VK_PARAM_V : v } : Nil andHttpMethod:VK_HTTP_METHOD_GET];
	[[self instance] executeRequest:request handler:^(VKResponse *response, NSError *error) {
		if (handler)
			handler([response.json[VK_PARAM_ITEMS] map:^id(id obj) {
				return [[VKAudioItem alloc] initWithDictionary:obj];
			}]);
	}];
	return request;
}

+ (VKRequest *)postMessage:(NSString *)message attachments:(NSArray *)attachments ownerID:(NSInteger)ownerID handler:(void (^)(NSUInteger postID))handler {
	if (!message.length && !attachments.count)
		return Nil;

	NSMutableDictionary *parameters = [NSMutableDictionary new];
	if (message)
		parameters[VK_PARAM_MESSAGE] = message;
	if (attachments)
		parameters[VK_PARAM_ATTACHMENTS] = [attachments componentsJoinedByString:STR_COMMA];
	if (ownerID)
		parameters[VK_PARAM_OWNER_ID] = @(ownerID);

	VKRequest *request = [VKApi requestWithMethod:VK_METHOD_WALL_POST andParameters:parameters andHttpMethod:VK_HTTP_METHOD_GET];
	[[self instance] executeRequest:request handler:^(VKResponse *response, NSError *error) {
		if (handler)
			handler([response.json[VK_PARAM_POST_ID] unsignedIntegerValue]);
	}];
	return request;
}

+ (VKRequest *)getPosts:(NSUInteger)ID offset:(NSUInteger)offset count:(NSUInteger)count query:(NSString *)query handler:(void (^)(NSArray<VKWallItem *> *))handler {
	NSMutableDictionary *parameters = [NSMutableDictionary new];
	if (ID)
		parameters[VK_PARAM_OWNER_ID] = @(0 - (NSInteger)ID);
	if (offset)
		parameters[VK_PARAM_OFFSET] = @(offset);
	if (count)
		parameters[VK_PARAM_COUNT] = @(count);
	if (query)
		parameters[VK_PARAM_QUERY] = query;

	VKRequest *request = [VKApi requestWithMethod:query ? VK_METHOD_WALL_SEARCH : VK_METHOD_WALL_GET andParameters:parameters andHttpMethod:VK_HTTP_METHOD_GET];
	void(^block)(VKResponse *response, NSError *error) = ^void(VKResponse *response, NSError *error) {
		if (handler)
			handler([response.json[VK_PARAM_ITEMS] map:^id(id obj) {
				return [[VKWallItem alloc] initWithDictionary:obj];
			}]);
	};
	if (ID && !query)
		[self executeRequest:request handler:block];
	else
		[[self instance] executeRequest:request handler:block];
	return request;
}

+ (VKRequest *)uploadWallPhoto:(UIImage *)image handler:(void (^)(VKPhoto *photo))handler {
	if (!image)
		return Nil;

	VKRequest *request = [VKApi uploadWallPhotoRequest:image parameters:[VKImageParameters jpegImageWithQuality:0.85] userId:0 groupId:0];
	[[self instance] executeRequest:request handler:^(VKResponse *response, NSError *error) {
		if (handler)
			handler([response.json firstObject] ? [[VKPhoto alloc] initWithDictionary:[response.json firstObject]] : Nil);
	}];
	return request;
}

+ (VKRequest *)getUsers:(NSArray *)IDs fields:(NSArray<NSString *> *)fields handler:(void(^)(NSArray<VKUser *> *users))handler {
	NSMutableDictionary *parameters = [NSMutableDictionary new];
	if (IDs)
		parameters[VK_PARAM_USER_IDS] = [IDs componentsJoinedByString:STR_COMMA];
	if (fields)
		parameters[VK_PARAM_FIELDS] = [fields componentsJoinedByString:STR_COMMA];

	VKRequest *request = [VKApi requestWithMethod:VK_METHOD_USERS_GET andParameters:parameters andHttpMethod:VK_HTTP_METHOD_GET];
	void(^block)(VKResponse *response, NSError *error) = ^void(VKResponse *response, NSError *error) {
		NSArray *array = cls(NSArray, response.json);
		if (handler)
			handler([array map:^id(id obj) {
				return [VKUser createWithDictionary:obj];
			}]);
	};
	if (IDs)
		[self executeRequest:request handler:block];
	else
		[[self instance] executeRequest:request handler:block];
	return request;
}

+ (VKRequest *)getGroups:(NSUInteger)ID fields:(NSArray<NSString *> *)fields filter:(NSArray<NSString *> *)filter handler:(void(^)(NSArray<VKGroup *> *groups))handler {
	if (!handler)
		return Nil;

	NSMutableDictionary *parameters = [NSMutableDictionary new];
	if (ID)
		parameters[VK_PARAM_USER_ID] = @(ID);
	if (fields)
		parameters[VK_PARAM_FIELDS] = [fields componentsJoinedByString:STR_COMMA];
	if (filter)
		parameters[VK_PARAM_FILTER] = [filter componentsJoinedByString:STR_COMMA];
	parameters[VK_PARAM_EXTENDED] = @1;

	VKRequest *request = [VKApi requestWithMethod:VK_METHOD_GROUPS_GET andParameters:parameters andHttpMethod:VK_HTTP_METHOD_GET];
	[[self instance] executeRequest:request handler:^void(VKResponse *response, NSError *error) {
		handler([[VKGroups alloc] initWithArray:response.json[VK_PARAM_ITEMS] objectClass:[VKGroup class]].items);
	}];
	return request;
}

+ (VKRequest *)getGroupsByIDs:(NSArray<NSNumber *> *)IDs fields:(NSArray<NSString *> *)fields handler:(void(^)(NSArray<VKGroup *> *groups))handler {
	if (!IDs.count)
		return Nil;
	if (!handler)
		return Nil;

	NSMutableDictionary *parameters = [NSMutableDictionary new];
	if (IDs)
		parameters[VK_PARAM_GROUP_IDS] = [IDs componentsJoinedByString:STR_COMMA];
	if (fields)
		parameters[VK_PARAM_FIELDS] = [fields componentsJoinedByString:STR_COMMA];

	VKRequest *request = [VKApi requestWithMethod:VK_METHOD_GROUPS_GET_BY_ID andParameters:parameters andHttpMethod:VK_HTTP_METHOD_GET];
	[self executeRequest:request handler:^void(VKResponse *response, NSError *error) {
		handler([[VKGroups alloc] initWithArray:response.json objectClass:[VKGroup class]].items);
	}];
	return request;
}

+ (VKRequest *)getFriends:(NSUInteger)ID fields:(NSArray<NSString *> *)fields handler:(void(^)(NSArray<VKUser *> *groups))handler {
	NSMutableDictionary *parameters = [NSMutableDictionary new];
	if (ID)
		parameters[VK_PARAM_USER_ID] = @(ID);
	if (fields)
		parameters[VK_PARAM_FIELDS] = [fields componentsJoinedByString:STR_COMMA];
	
	VKRequest *request = [VKApi requestWithMethod:VK_METHOD_FRIENDS_GET andParameters:parameters andHttpMethod:VK_HTTP_METHOD_GET];
	void(^block)(VKResponse *response, NSError *error) = ^void(VKResponse *response, NSError *error) {
		if (handler)
			handler([[VKUsersArray alloc] initWithDictionary:response.json objectClass:[VKUser class]].items);
	};
	if (ID)
		[self executeRequest:request handler:block];
	else
		[[self instance] executeRequest:request handler:block];
	return request;
}

@end
