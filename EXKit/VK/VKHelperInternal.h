//
//  VKHelperInternal.h
//  Ringo
//
//  Created by Alexander Ivanov on 20.10.15.
//  Copyright © 2015 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <VKSdk/VKSdk.h>

#import "VKItem.h"

#import "NSObject+Convenience.h"
#import "UIAlertController+Convenience.h"
#import "UIApplication+Convenience.h"
#import "UIViewController+Convenience.h"

@interface VKHelperInternal : NSObject <VKSdkDelegate>

@property (strong, nonatomic, readonly) NSArray *permissions;

- (void)executeRequest:(VKRequest *)request handler:(void(^)(VKResponse *response, NSError *error))handler;

+ (void)executeRequest:(VKRequest *)request handler:(void(^)(VKResponse *response, NSError *error))handler;

+ (void)initializeWithAppId:(NSString *)appId apiVersion:(NSString *)apiVersion permissions:(NSArray *)permissions;
- (void)authorize;
- (VKAccessToken *)wakeUpSession;

+ (instancetype)instance;

@end

@interface VKApiObject (Convenience)

@property (strong, nonatomic, readonly) NSURL *url;

@end

@interface VKUser (Convenience)

- (NSString *)fullName;

- (NSInteger)friendsCount;

@end
