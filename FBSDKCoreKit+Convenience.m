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

+ (instancetype)startRequestWithGraphPath:(NSString *)graphPath parameters:(NSDictionary *)parameters completion:(FBSDKGraphRequestHandler)completion {
	if (!graphPath || !parameters || ![FBSDKAccessToken currentAccessToken])
		return Nil;

	FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:graphPath parameters:parameters];
	[request startWithCompletionHandler:completion];
	return request;
}

+ (instancetype)requestProfile:(NSString *)userID completion:(void (^)(FBSDKProfile *profile))completion {
	return [self startRequestWithGraphPath:userID ?: @"me" parameters:@{ @"fields" : @"id,first_name,middle_name,last_name,name" } completion:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
		if (completion)
			completion([FBSDKProfile profileWithDictionary:result]);

		[error log:@"requestFriends:"];
	}];
}

+ (instancetype)requestFriends:(NSString *)userID completion:(void (^)(NSArray<FBSDKProfile *> *friends))completion {
	return [self startRequestWithGraphPath:[NSString stringWithFormat:@"%@/friends", userID ?: @"me"] parameters:@{ @"fields" : @"id,first_name,middle_name,last_name,name" } completion:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
		if (completion)
			completion([result[@"data"] map:^id(id obj) {
				return [FBSDKProfile profileWithDictionary:obj];
			}]);

		[error log:@"requestFriends:"];
	}];
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
