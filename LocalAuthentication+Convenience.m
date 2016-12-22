//
//  LocalAuthentication+Convenience.m
//  Guardian
//
//  Created by Alexander Ivanov on 16.12.16.
//  Copyright © 2016 NATEK. All rights reserved.
//

#import "LocalAuthentication+Convenience.h"

@implementation LAContext (Convenience)

- (BOOL)isBiometricsAvailable {
	NSError *error = Nil;

	BOOL r = [self canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];

	[error log:@"canEvaluatePolicy:"];

	return r;
}

__static(LAContext *, defaultContext, [self new])

@end

@implementation SecHelper

+ (void)log:(OSStatus)status message:(NSString *)message {
	if (status == errSecUnimplemented)
		[@"Function or operation not implemented." log:message];
	if (status == errSecParam)
		[@"One or more parameters passed to the function were not valid." log:message];
	if (status == errSecAllocate)
		[@"Failed to allocate memory." log:message];
	if (status == errSecNotAvailable)
		[@"No trust results are available." log:message];
	if (status == errSecAuthFailed)
		[@"Authorization/Authentication failed." log:message];
	if (status == errSecDuplicateItem)
		[@"The item already exists." log:message];
	if (status == errSecItemNotFound)
		[@"The item cannot be found." log:message];
	if (status == errSecInteractionNotAllowed)
		[@"Interaction with the Security Server is not allowed." log:message];
	if (status == errSecDecode)
		[@"Unable to decode the provided data." log:message];
}

+ (SecTrustResultType)evaluate:(SecTrustRef)trust {
	SecTrustResultType result;

	OSStatus status = SecTrustEvaluate(trust, &result);
	[self log:status message:@"SecTrustEvaluate"];

	return result;
}

+ (BOOL)setExceptions:(SecTrustRef)trust {
	CFDataRef exceptions = SecTrustCopyExceptions(trust);

	BOOL valid = SecTrustSetExceptions(trust, exceptions);

	if (exceptions)
		CFRelease(exceptions);

	return valid;
}

#if TARGET_OS_IPHONE
+ (BOOL)selectPasswordMatchingAccount:(NSString *)account service:(NSString *)service prompt:(NSString *)prompt handler:(void(^)(NSString *password))handler {
	if (!account.length)
		return NO;

	if (!service.length)
		service = [NSBundle bundleIdentifier];

	NSDictionary *query = prompt.length ? @{
		(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
		(__bridge id)kSecAttrService : service,
		(__bridge id)kSecAttrAccount : account,
		(__bridge id)kSecReturnData : @YES,
		(__bridge id)kSecUseOperationPrompt : prompt,
	} : @{
		(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
		(__bridge id)kSecAttrService : service,
		(__bridge id)kSecAttrAccount : account,
		(__bridge id)kSecReturnData : @YES,
	};

	[GCD global:^{
		CFTypeRef result = NULL;
		OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
		[self log:status message:@"SecItemCopyMatching"];
		if (handler) {
			NSString *password = [[NSString alloc] initWithData:(__bridge NSData *)result encoding:NSUTF8StringEncoding];
			[GCD main:^{
				handler(password);
			}];
		}
	}];

	return YES;
}

+ (BOOL)selectPasswordMatchingAccount:(NSString *)account prompt:(NSString *)prompt handler:(void(^)(NSString *password))handler {
	return [self selectPasswordMatchingAccount:account service:Nil prompt:prompt handler:handler];
}

+ (BOOL)selectPasswordMatchingAccount:(NSString *)account handler:(void(^)(NSString *password))handler {
	return [self selectPasswordMatchingAccount:account service:Nil prompt:Nil handler:handler];
}

+ (BOOL)insertPassword:(NSString *)password account:(NSString *)account service:(NSString *)service userPresence:(BOOL)flag {
	if (!account.length || !password.length)
		return NO;

	if (flag && ![[LAContext defaultContext] isBiometricsAvailable])
		return NO;

	if (!service.length)
		service = [NSBundle bundleIdentifier];

	CFErrorRef error =  NULL;
	SecAccessControlRef secObject = SecAccessControlCreateWithFlags(kCFAllocatorDefault, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, flag ? kSecAccessControlUserPresence : 0, &error);
	[((__bridge NSError *)error) log:@"SecAccessControlCreateWithFlags"];
	if (error)
		CFRelease(error);

	NSData *data = [password dataUsingEncoding:NSUTF8StringEncoding];
	NSDictionary *query = @{
		(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
		(__bridge id)kSecAttrService : service,
		(__bridge id)kSecAttrAccount : account,
		(__bridge id)kSecValueData : data,
		(__bridge id)kSecAttrAccessControl : (__bridge id)secObject,
	};

	OSStatus status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
	[self log:status message:@"SecItemAdd"];

	if (secObject)
		CFRelease(secObject);

	return status == errSecSuccess;
}

+ (BOOL)insertPassword:(NSString *)password account:(NSString *)account userPresence:(BOOL)flag {
	return [self insertPassword:password account:account service:Nil userPresence:flag];
}

+ (BOOL)insertPassword:(NSString *)password account:(NSString *)account {
	return [self insertPassword:password account:account service:Nil userPresence:NO];
}

+ (BOOL)updatePassword:(NSString *)password account:(NSString *)account service:(NSString *)service {
	if (!account.length || !password.length)
		return NO;

	if (!service.length)
		service = [NSBundle bundleIdentifier];

	NSDictionary *query = @{
		(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
		(__bridge id)kSecAttrService : service,
		(__bridge id)kSecAttrAccount : account,
	};

	NSData *data = [password dataUsingEncoding:NSUTF8StringEncoding];
	NSDictionary *attributes = @{
								 (__bridge id)kSecValueData : data,
								 };

	OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)attributes);
	[self log:status message:@"SecItemUpdate"];
	return status == errSecSuccess;
}

+ (BOOL)updatePassword:(NSString *)password account:(NSString *)account {
	return [self updatePassword:password account:account service:Nil];
}

+ (BOOL)deletePasswordMatchingAccount:(NSString *)account service:(NSString *)service {
	if (!account.length)
		return NO;

	if (!service.length)
		service = [NSBundle bundleIdentifier];

	NSDictionary *query = @{
		(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
		(__bridge id)kSecAttrService : service,
		(__bridge id)kSecAttrAccount : account,
	};

	OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
	[self log:status message:@"SecItemDelete"];
	return status == errSecSuccess;
}

+ (BOOL)deletePasswordMatchingAccount:(NSString *)account {
	return [self deletePasswordMatchingAccount:account service:Nil];
}
#endif

@end
