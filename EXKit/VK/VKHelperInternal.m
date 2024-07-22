//
//  VKHelperInternal.m
//  Ringo
//
//  Created by Alexander Ivanov on 20.10.15.
//  Copyright © 2015 Alexander Ivanov. All rights reserved.
//

#import "VKHelperInternal.h"

@interface VKHelperInternal ()
@property (strong, nonatomic, readonly) UIViewController *viewController;

@property (strong, nonatomic) NSArray *permissions;

@property (strong, nonatomic) NSMutableArray *requests;
@property (strong, nonatomic) NSMutableArray *handlers;
@end

@implementation VKHelperInternal

- (UIViewController *)viewController {
	return [UIApplication sharedApplication].rootViewController.lastViewController;
}

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
//	[@"vkSdkNeedCaptchaEnter:" log:[captchaError description]];

	if ([self.viewController isKindOfClass:[VKCaptchaViewController class]])
		return;

	[[VKCaptchaViewController captchaControllerWithError:captchaError] presentIn:self.viewController];
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
//	[@"vkSdkShouldPresentViewController:" log:[[controller.lastViewController description]];

	[self.viewController presentViewController:controller animated:YES completion:Nil];
}

- (void)vkSdkReceivedNewToken:(VKAccessToken *)newToken {
	[self executeRequests];

	if (newToken)
		[[UIApplication sharedApplication].rootViewController forwardSelector:@selector(vkSdkReceivedNewToken:) withObject:newToken nextTarget:UIViewControllerNextTarget(NO)];

//	PERFORM_SELECTOR_1(self.viewController, @selector(vkSdkReceivedNewToken:), newToken);
}

- (void)vkSdkUserDeniedAccess:(VKError *)authorizationError {
	[self executeRequests];

	[self.viewController presentAlertWithError:authorizationError.httpError cancelActionTitle:loc(@"Cancel")];
	
	if (authorizationError)
		[[UIApplication sharedApplication].rootViewController forwardSelector:@selector(vkSdkUserDeniedAccess:) withObject:authorizationError nextTarget:UIViewControllerNextTarget(NO)];
}

- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken {
	[@"vkSdkTokenHasExpired:" log:[expiredToken description]];

	[self authorize];
}

- (NSMutableArray *)requests {
	if (!_requests)
		_requests = [NSMutableArray new];

	return _requests;
}

- (NSMutableArray *)handlers {
	if (!_handlers)
		_handlers = [NSMutableArray new];

	return _handlers;
}

- (void)executeRequest:(VKRequest *)request handler:(void(^)(VKResponse *response, NSError *error))handler {
	if (!request || !handler)
		return;

	[self.requests addObject:request];
	[self.handlers addObject:handler];

	NSArray *components = [request.methodName componentsSeparatedByString:STR_DOT];
	if ([VKSdk wakeUpSession:components.count > 1 && ![@"users" isEqualToString:components[0]] ? @[ components[0] ] : Nil])
		[self vkSdkReceivedNewToken:Nil];
	else
		[self authorize];
}

- (void)executeRequests {
	NSArray *requests = self.requests;
	NSArray *handlers = self.handlers;
	self.requests = [NSMutableArray new];
	self.handlers = [NSMutableArray new];

	for (NSUInteger index = 0; index < requests.count && index < handlers.count; index++)
		[[self class] executeRequest:requests[index] handler:handlers[index]];
}

+ (void)executeRequest:(VKRequest *)request handler:(void(^)(VKResponse *response, NSError *error))handler {
	[request executeWithResultBlock:^(VKResponse *response) {
		if (handler)
			handler(response, Nil);
	} errorBlock:^(NSError *error) {
		[error log:@"executeWithResultBlock:"];

		if (handler)
			handler(Nil, error);
	}];
}

+ (void)initializeWithAppId:(NSString *)appId apiVersion:(NSString *)apiVersion permissions:(NSArray *)permissions {
	_instance = [self new];

	[VKSdk initializeWithDelegate:[self instance] andAppId:appId apiVersion:apiVersion];

	[[self instance] setPermissions:permissions];
}

- (void)authorize {
	[VKSdk authorize:self.permissions revokeAccess:NO forceOAuth:YES inApp:YES display:VK_DISPLAY_MOBILE];
}

- (VKAccessToken *)wakeUpSession {
	return [VKSdk wakeUpSession:self.permissions] ? [VKSdk getAccessToken] : Nil;
}

static id _instance;

+ (instancetype)instance {
/*	@synchronized(self) {
		if (!_instance)
			_instance = [self new];
	}
*/
	return _instance;
}

@end

@implementation VKApiObject (Convenience)

- (NSURL *)url {
	NSString *screenName = self.fields[VK_PARAM_SCREEN_NAME];
	NSNumber *ID = self.fields[VK_PARAM_ID];
	NSString *url = screenName.length ? [NSString stringWithFormat:@"https://vk.com/%@", screenName] : ID.integerValue ? [NSString stringWithFormat:@"https://vk.com/id%ld", labs(ID.integerValue)] : Nil;
	return [NSURL URLWithString:url];
}

@end

#define VK_KEY_COUNTERS @"counters"
#define VK_KEY_FRIENDS @"friends"

@implementation VKUser (Convenience)

- (NSString *)fullName {
	return [[NSArray arrayWithObject:self.first_name withObject:self.last_name withObject:Nil] componentsJoinedByString:STR_SPACE];
}

- (NSInteger)friendsCount {
	return [self.fields[VK_KEY_COUNTERS][VK_KEY_FRIENDS] integerValue];
}

@end
