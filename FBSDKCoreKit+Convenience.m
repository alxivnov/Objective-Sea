//
//  FBSDKCoreKit+Convenience.m
//  Crowd Guard
//
//  Created by Alexander Ivanov on 07.04.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import "FBSDKCoreKit+Convenience.h"

@implementation FBNode

- (instancetype)initWithFields:(NSDictionary *)fields {
	self = [self init];

	if (self)
		_fields = fields;

	return self;
}

+ (instancetype)nodeWithFields:(NSDictionary *)fields {
	return fields ? [[self alloc] initWithDictionary:fields] : Nil;
}

+ (NSArray *)nodesFromArray:(NSArray *)array {
	return [array map:^id(id obj) {
		return [self nodesFromArray:obj];
	}];
}

- (NSString *)description {
	return [self.fields description];
}

@end

@implementation FBUser

- (NSString *)ID {
	return self.fields[@"id"];
}

- (NSString *)name {
	return self.fields[@"name"];
}

- (NSURL *)picture {
	return [NSURL URLWithString:self.fields[@"picture"][@"data"][@"url"]];
}

- (BOOL)isSilhouette {
	return [self.fields[@"picture"][@"data"][@"is_silhouette"] boolValue];
}

- (void)pictureWithScale:(CGFloat)scale completion:(void (^)(UIImage *))completion {
	[self.picture cache:^(NSURL *url) {
		if (completion)
			completion(url ? [UIImage imageWithData:[NSData dataWithContentsOfURL:url] scale:scale] : Nil);
	}];
}

@end

@implementation FBSDKGraphRequest (Convenience)

+ (instancetype)startRequestWithGraphPath:(NSString *)graphPath parameters:(NSDictionary *)parameters HTTPMethod:(NSString *)HTTPMethod completion:(FBSDKGraphRequestHandler)completion {
	if (!graphPath || !parameters || ![FBSDKAccessToken currentAccessToken])
		return Nil;

	FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:graphPath parameters:parameters HTTPMethod:HTTPMethod];
	[request startWithCompletionHandler:completion];
	return request;
}

+ (instancetype)requestProfile:(NSString *)userID completion:(void (^)(FBSDKProfile *profile))completion {
	return [self startRequestWithGraphPath:userID ?: @"me" parameters:@{ @"fields" : @"id,first_name,middle_name,last_name,name" } HTTPMethod:Nil completion:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
		if (completion)
			completion([FBSDKProfile profileWithDictionary:result]);

		[error log:@"requestFriends:"];
	}];
}

+ (instancetype)requestFriends:(NSString *)userID limit:(NSUInteger)limit completion:(void (^)(NSArray<FBSDKProfile *> *friends))completion {
	return [self startRequestWithGraphPath:[NSString stringWithFormat:@"%@/friends", userID ?: @"me"] parameters:limit > 0 ? @{ @"fields" : @"id,first_name,middle_name,last_name,name", @"limit" : @(limit) } : @{ @"fields" : @"id,first_name,middle_name,last_name,name" } HTTPMethod:Nil completion:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
		if (completion)
			completion([result[@"data"] map:^id(id obj) {
				return [FBSDKProfile profileWithDictionary:obj];
			}]);

		[error log:@"requestFriends:"];
	}];
}

//	https://developers.facebook.com/docs/graph-api/reference/v2.9/user/feed

+ (instancetype)publishMessage:(NSString *)message link:(NSURL *)link place:(NSString *)place tags:(NSArray<NSString *> *)tags privacyValue:(NSString *)value privacyAllow:(NSArray<NSString *> *)allow privacyDeny:(NSArray<NSString *> *)deny completion:(void (^)(NSString *))completion {
	if (!message && !link && !place)
		return Nil;

	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
	params[@"message"] = message;
	params[@"link"] = link.absoluteString;
	params[@"place"] = place;
	params[@"tags"] = [tags componentsJoinedByString:STR_COMMA];
	if ([value isEqualToAnyString:@[ FBSDKPrivacyEveryone, FBSDKPrivacyAllFriends, FBSDKPrivacyFriendsOfFriends, FBSDKPrivacyCustom, FBSDKPrivacySelf ]]) {
		NSMutableDictionary *privacy = [NSMutableDictionary dictionaryWithCapacity:3];
		privacy[@"value"] = value;
		privacy[@"allow"] = [allow componentsJoinedByString:STR_COMMA];
		privacy[@"deny"] = [deny componentsJoinedByString:STR_COMMA];
		params[@"privacy"] = [NSJSONSerialization stringWithJSONObject:privacy];
	}

	return [self startRequestWithGraphPath:@"me/feed" parameters:params HTTPMethod:@"POST" completion:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
		if (completion)
			completion(result[@"id"]);

		[error log:@"publishMessage"];
	}];
}

+ (instancetype)publishMessage:(NSString *)message link:(NSURL *)link place:(NSString *)place tags:(NSArray<NSString *> *)tags privacy:(NSString *)privacy completion:(void (^)(NSString *))completion {
	return [privacy isEqualToAnyString:@[ FBSDKPrivacyEveryone, FBSDKPrivacyAllFriends, FBSDKPrivacyFriendsOfFriends, FBSDKPrivacySelf ]] ? [self publishMessage:message link:link place:place tags:tags privacyValue:privacy privacyAllow:Nil privacyDeny:Nil completion:completion] : Nil;
}

+ (instancetype)publishMessage:(NSString *)message link:(NSURL *)link place:(NSString *)place tags:(NSArray<NSString *> *)tags allow:(NSArray<NSString *> *)allow completion:(void (^)(NSString *))completion {
	return allow.count ? [self publishMessage:message link:link place:place tags:tags privacyValue:FBSDKPrivacyCustom privacyAllow:allow privacyDeny:Nil completion:completion] : Nil;
}

+ (instancetype)publishMessage:(NSString *)message link:(NSURL *)link place:(NSString *)place tags:(NSArray<NSString *> *)tags deny:(NSArray<NSString *> *)deny completion:(void (^)(NSString *))completion {
	return deny.count ? [self publishMessage:message link:link place:place tags:tags privacyValue:FBSDKPrivacyCustom privacyAllow:Nil privacyDeny:deny completion:completion] : Nil;
}

@end

@implementation FBSDKProfile (Convenience)

+ (instancetype)profileWithDictionary:(NSDictionary *)dictionary {
	return [[FBSDKProfile alloc] initWithUserID:dictionary[@"id"] firstName:dictionary[@"first_name"] middleName:dictionary[@"middle_name"] lastName:dictionary[@"last_name"] name:dictionary[@"name"] linkURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://facebook.com/%@", dictionary[@"id"]]] refreshDate:Nil];
}

- (NSURL *)imageForPictureMode:(FBSDKProfilePictureMode)mode size:(CGSize)size scale:(CGFloat)scale completion:(void (^)(UIImage *))completion {
	NSURL *url = [self imageURLForPictureMode:mode size:scale > 0.0 ? CGSizeMake(size.width * scale, size.height * scale) : size];

	[url cache:^(NSURL *url) {
		if (completion)
			completion([UIImage imageWithContentsOfURL:url scale:scale]);
	}];

	return url;
}

@end
