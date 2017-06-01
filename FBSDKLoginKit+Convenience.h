//
//  FBSDKLoginKit+Convenience.h
//  Crowd Guard
//
//  Created by Alexander Ivanov on 07.04.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "NSArray+Convenience.h"
#import "NSObject+Convenience.h"

@interface FBSDKLoginButton (Convenience)

- (void)fit;

@end

@interface FBSDKLoginManager (Convenience)

+ (BOOL)isLoggedIn:(NSArray<NSString *> *)permissions;

+ (instancetype)defaultManager;

@end

@interface UIViewController (FBSDKLoginKit)

- (BOOL)presentLogInWithReadPermissions:(NSArray *)permissions completion:(void (^)(FBSDKAccessToken *token))completion;
- (BOOL)presentLogInWithPublishPermissions:(NSArray *)permissions completion:(void (^)(FBSDKAccessToken *token))completion;

@end
