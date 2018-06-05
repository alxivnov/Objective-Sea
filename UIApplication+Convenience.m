//
//  UIApplication+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 06.10.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UIApplication+Convenience.h"

//#define STR_SOUNDS_RINGTONE @"prefs:root=Sounds&path=Ringtone"

@implementation UIApplication (Convenience)

+ (void)openURL:(NSURL *)url options:(NSDictionary<NSString *, id> *)options completionHandler:(void (^)(BOOL success))completion {
	if (!url)
		return;

	if (@available(iOS 10.0, *)) {
		if (!options)
			options = @{ };

		[[self sharedApplication] openURL:url options:options completionHandler:completion];
	} else {
		BOOL success = [[self sharedApplication] openURL:url];

		if (completion)
			completion(success);
	}
}

+ (void)openURL:(NSURL *)url {
	[self openURL:url options:Nil completionHandler:Nil];
}

+ (void)openSettings {
	[self openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}
/*
+ (void)openRingtone {
	[self openURL:[NSURL URLWithString:STR_SOUNDS_RINGTONE]];
}
*/
+ (void)openURL:(NSURL *)url inApp:(NSString *)app {
	[self openURL:app ? [NSURL URLWithString:[NSString stringWithFormat:@"%@%@app=%@", url.absoluteString, [url.absoluteString containsString:@"?"] ? @"&" : @"?", app]] : url options:Nil completionHandler:Nil];
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

- (BOOL)iPad {
	return [self rootWindow].traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular && [self rootWindow].traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular;
}

- (BOOL)iPhone {
	return !self.iPad;
}

- (CGFloat)statusBarHeight {
	return fmin(self.statusBarFrame.size.height, self.statusBarFrame.size.width);
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

+ (BOOL)performBackgroundTaskWithName:(NSString *)taskName handler:(void (^)(void))taskHandler expirationHandler:(void (^)(void))expirationHandler {
	UIBackgroundTaskIdentifier identifier = [[self sharedApplication] beginBackgroundTaskWithName:taskName expirationHandler:expirationHandler];
	if (identifier == UIBackgroundTaskInvalid)
		return NO;

	taskHandler();

	[[self sharedApplication] endBackgroundTask:identifier];

	return YES;
}

+ (void)setAlternateIconName:(NSString *)alternateIconName {
	if (@available(iOS 10.3, *))
		if ([[self sharedApplication] respondsToSelector:@selector(supportsAlternateIcons)] && [[self sharedApplication] respondsToSelector:@selector(setAlternateIconName:completionHandler:)])

			if ([self sharedApplication].supportsAlternateIcons)
				[[self sharedApplication] setAlternateIconName:alternateIconName completionHandler:^(NSError * _Nullable error) {
					NSLog(@"setAlternateIconName: %@", error.debugDescription);
				}];
}

@end
