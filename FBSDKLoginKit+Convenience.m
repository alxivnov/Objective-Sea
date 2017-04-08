//
//  FBSDKLoginKit+Convenience.m
//  Crowd Guard
//
//  Created by Alexander Ivanov on 07.04.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import "FBSDKLoginKit+Convenience.h"

@implementation FBSDKLoginManager (Convenience)

+ (BOOL)isLoggedIn:(NSArray<NSString *> *)permissions {
	return [FBSDKAccessToken currentAccessToken] != Nil && (permissions == Nil || [permissions all:^BOOL(NSString *obj) {
		return [[FBSDKAccessToken currentAccessToken] hasGranted:obj];
	}]);
}

__static(FBSDKLoginManager *, defaultManager, [self new])

@end

@implementation UIViewController (FBSDKLoginKit)

- (void)presentLogInWithReadPermissions:(NSArray *)permissions completion:(void (^)(BOOL))completion {
	if (![FBSDKLoginManager isLoggedIn:permissions])
		[[FBSDKLoginManager defaultManager] logInWithReadPermissions:permissions fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
			if (completion)
				completion(error != Nil);

			[error log:@"logInWithReadPermissions:"];
		}];
}

- (void)presentLogInWithPublishPermissions:(NSArray *)permissions completion:(void (^)(BOOL))completion {
	if (![FBSDKLoginManager isLoggedIn:permissions])
		[[FBSDKLoginManager defaultManager] logInWithPublishPermissions:permissions fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
			if (completion)
				completion(error != Nil);

			[error log:@"logInWithPublishPermissions:"];
		}];
}

@end
