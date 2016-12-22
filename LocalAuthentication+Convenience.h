//
//  LocalAuthentication+Convenience.h
//  Guardian
//
//  Created by Alexander Ivanov on 16.12.16.
//  Copyright © 2016 NATEK. All rights reserved.
//

#import <LocalAuthentication/LocalAuthentication.h>
#import <SystemConfiguration/SystemConfiguration.h>

#import "Dispatch+Convenience.h"
#import "NSBundle+Convenience.h"
#import "NSObject+Convenience.h"

#define SCConsoleUserString CFBridgingRelease(SCDynamicStoreCopyConsoleUser(NULL, NULL, NULL))

@interface LAContext (Convenience)

- (BOOL)isBiometricsAvailable;

+ (instancetype)defaultContext;

@end

@interface SecHelper : NSObject

+ (SecTrustResultType)evaluate:(SecTrustRef)trust;
+ (BOOL)setExceptions:(SecTrustRef)trust;

#if TARGET_OS_IPHONE
+ (BOOL)selectPasswordMatchingAccount:(NSString *)account service:(NSString *)service prompt:(NSString *)prompt handler:(void(^)(NSString *password))handler;
+ (BOOL)selectPasswordMatchingAccount:(NSString *)account prompt:(NSString *)prompt handler:(void(^)(NSString *password))handler;
+ (BOOL)selectPasswordMatchingAccount:(NSString *)account handler:(void(^)(NSString *password))handler;

+ (BOOL)insertPassword:(NSString *)password account:(NSString *)account service:(NSString *)service userPresence:(BOOL)flag;
+ (BOOL)insertPassword:(NSString *)password account:(NSString *)account userPresence:(BOOL)flag;
+ (BOOL)insertPassword:(NSString *)password account:(NSString *)account;

+ (BOOL)updatePassword:(NSString *)password account:(NSString *)account service:(NSString *)service;
+ (BOOL)updatePassword:(NSString *)password account:(NSString *)account;

+ (BOOL)deletePasswordMatchingAccount:(NSString *)account service:(NSString *)service;
+ (BOOL)deletePasswordMatchingAccount:(NSString *)account;
#endif

@end
