//
//  UIApplication+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 06.10.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSArray+Convenience.h"

#define kAppITunes @"itunes"
#define kAppMusic @"music"

@interface UIApplication (Convenience)

+ (void)openURL:(NSURL *)url options:(NSDictionary<NSString *, id> *)options completionHandler:(void (^)(BOOL success))completion;
+ (void)openURL:(NSURL *)url;
+ (void)openSettings;
+ (void)openRingtone;
+ (void)openURL:(NSURL *)url inApp:(NSString *)app;

@property (strong, nonatomic) __kindof UIViewController *rootViewController;

@property (assign, nonatomic, readonly) BOOL iPad;
@property (assign, nonatomic, readonly) BOOL iPhone;

- (BOOL)isActive;
- (BOOL)isBackground;
- (BOOL)isInactive;

- (BOOL)performBackgroundTask:(void (^)(void))task withName:(NSString *)name expirationHandler:(void(^)(void))handler;
- (BOOL)performBackgroundTask:(void (^)(void))task expirationHandler:(void(^)(void))handler;
- (BOOL)performBackgroundTask:(void (^)(void))task;

@end
