//
//  UIApplication+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 06.10.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UIApplication+Convenience.h"

#define STR_SOUNDS_RINGTONE @"prefs:root=Sounds&path=Ringtone"

@implementation UIApplication (Convenience)

+ (void)openURL:(NSURL *)url options:(NSDictionary<NSString *, id> *)options completionHandler:(void (^)(BOOL success))completion {
	if (!url)
		return;

	if (!options)
		options = @{ };

	[[self sharedApplication] openURL:url options:options completionHandler:completion];
}

+ (void)openURL:(NSURL *)url {
	[self openURL:url options:Nil completionHandler:Nil];
}

+ (void)openSettings {
	[self openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

+ (void)openRingtone {
	[self openURL:[NSURL URLWithString:STR_SOUNDS_RINGTONE]];
}

+ (void)openURL:(NSURL *)url inApp:(NSString *)app {
	[self openURL:app ? [url URLByAppendingPathComponent:[NSString stringWithFormat:@"%@app=%@", [url.absoluteString containsString:@"?"] ? @"&" : @"?", app]] : url options:Nil completionHandler:Nil];
}



- (UIWindow *)rootWindow {
	return self.keyWindow.rootViewController ? self.keyWindow : [self.windows lastObject:^BOOL(UIWindow *item) {
		return item.rootViewController != Nil;
	}];
}

- (UIViewController *)rootViewController {
	return [self rootWindow].rootViewController;
}

- (void)setRootViewController:(UIViewController *)viewController {
	[self rootWindow].rootViewController = viewController;
}



- (BOOL)isActive {
	return self.applicationState == UIApplicationStateActive;
}

- (BOOL)isBackground {
	return self.applicationState == UIApplicationStateBackground;
}

- (BOOL)isInactive {
	return self.applicationState == UIApplicationStateInactive;
}

- (BOOL)performBackgroundTask:(void (^)(void))task withName:(NSString *)name expirationHandler:(void(^)(void))handler {
	UIBackgroundTaskIdentifier identifier = [self beginBackgroundTaskWithName:name expirationHandler:handler];
	if (identifier == UIBackgroundTaskInvalid)
		return NO;

	task();
	[self endBackgroundTask:identifier];

	return YES;
}

- (BOOL)performBackgroundTask:(void (^)(void))task expirationHandler:(void (^)(void))handler {
	return [self performBackgroundTask:task withName:Nil expirationHandler:handler];
}

- (BOOL)performBackgroundTask:(void (^)(void))task {
	return [self performBackgroundTask:task withName:Nil expirationHandler:Nil];
}

@end
