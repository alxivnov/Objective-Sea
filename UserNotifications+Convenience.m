//
//  UserNotifications+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 05.10.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UserNotifications+Convenience.h"

@implementation UNUserNotificationCenter (Convenience)

+ (void)setDelegate:(id<UNUserNotificationCenterDelegate>)delegate {
	[UNUserNotificationCenter currentNotificationCenter].delegate = delegate;
}

+ (void)requestAuthorizationWithOptions:(UNAuthorizationOptions)options completionHandler:(void (^)(BOOL granted))completionHandler {
	[[self currentNotificationCenter] requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
		if (completionHandler)
			completionHandler(granted);

		[error log:@"requestAuthorizationWithOptions:"];
	}];
}

+ (void)setNotificationCategories:(NSArray<UNNotificationCategory *> *)categories {
	if (categories)
		[[self currentNotificationCenter] setNotificationCategories:[NSSet setWithArray:categories]];
}

+ (void)getNotificationSettings:(void (^)(UNNotificationSettings *))completionHandler {
	[[self currentNotificationCenter] getNotificationSettingsWithCompletionHandler:completionHandler];
}

+ (void)addNotificationRequestWithIdentifier:(NSString *)identifier content:(UNNotificationContent *)content trigger:(UNNotificationTrigger *)trigger completion:(void (^)(BOOL success))completion {
	if (identifier && content)
		[[self currentNotificationCenter] addNotificationRequest:[UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger] withCompletionHandler:^(NSError * _Nullable error) {
			if (completion)
				completion(error == Nil);

			[error log:@"addNotificationRequest:"];
		}];
}

+ (void)addNotificationRequestWithIdentifier:(NSString *)identifier content:(UNNotificationContent *)content trigger:(UNNotificationTrigger *)trigger {
	[self addNotificationRequestWithIdentifier:identifier content:content trigger:trigger completion:Nil];
}

+ (void)getPendingNotificationRequestsWithCompletionHandler:(void(^)(NSArray<UNNotificationRequest *> *requests))completionHandler {
	[[self currentNotificationCenter] getPendingNotificationRequestsWithCompletionHandler:completionHandler];
}

+ (void)getPendingNotificationRequestsWithIdentifier:(NSString *)identifier completionHandler:(void(^)(NSArray<UNNotificationRequest *> *requests))completionHandler {
	if (identifier && completionHandler)
		[self getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
			completionHandler([requests query:^BOOL(UNNotificationRequest *obj) {
				return [obj.identifier isEqualToString:identifier];
			}]);
		}];
}

+ (void)getPendingNotificationRequestWithIdentifier:(NSString *)identifier completionHandler:(void(^)(UNNotificationRequest *request))completionHandler {
	if (identifier && completionHandler)
		[self getPendingNotificationRequestsWithIdentifier:identifier completionHandler:^(NSArray<UNNotificationRequest *> *requests) {
			completionHandler(requests.firstObject);
		}];
}

+ (void)removePendingNotificationRequestsWithIdentifiers:(NSArray<NSString *> *)identifiers {
	if (identifiers)
		[[self currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:identifiers];
}

+ (void)removePendingNotificationRequestWithIdentifier:(NSString *)identifier {
	if (identifier)
		[[self currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[ identifier ]];
}

+ (void)removeAllPendingNotificationRequests {
	[[self currentNotificationCenter] removeAllPendingNotificationRequests];
}

+ (void)getDeliveredNotificationsWithCompletionHandler:(void(^)(NSArray<UNNotification *> *notifications))completionHandler {
	[[self currentNotificationCenter] getDeliveredNotificationsWithCompletionHandler:completionHandler];
}

+ (void)getDeliveredNotificationsWithIdentifier:(NSString *)identifier completionHandler:(void(^)(NSArray<UNNotification *> *notifications))completionHandler {
	if (identifier && completionHandler)
		[self getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
			completionHandler([notifications query:^BOOL(UNNotification *obj) {
				return [obj.request.identifier isEqualToString:identifier];
			}]);
		}];
}

+ (void)getDeliveredNotificationWithIdentifier:(NSString *)identifier completionHandler:(void(^)(UNNotification *notification))completionHandler {
	if (identifier && completionHandler)
		[self getDeliveredNotificationsWithIdentifier:identifier completionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
			completionHandler(notifications.firstObject);
		}];
}

+ (void)removeDeliveredNotificationsWithIdentifiers:(NSArray<NSString *> *)identifiers {
	if (identifiers)
		[[self currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:identifiers];
}

+ (void)removeDeliveredNotificationWithIdentifier:(NSString *)identifier {
	if (identifier)
		[[self currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[ identifier ]];
}

+ (void)removeAllDeliveredNotifications {
	[[self currentNotificationCenter] removeAllDeliveredNotifications];
}

+ (void)removeNotificationsWithIdentifiers:(NSArray<NSString *> *)identifiers {
	[self removePendingNotificationRequestsWithIdentifiers:identifiers];
	[self removeDeliveredNotificationsWithIdentifiers:identifiers];
}

+ (void)removeNotificationsWithIdentifier:(NSString *)identifier {
	[self removePendingNotificationRequestWithIdentifier:identifier];
	[self removeDeliveredNotificationWithIdentifier:identifier];
}

+ (void)removeAllNotifications {
	[self removeAllPendingNotificationRequests];
	[self removeAllDeliveredNotifications];
}

@end

@implementation UNNotificationSettings (Convenience)

- (NSNumber *)authorization {
	return self.authorizationStatus == UNAuthorizationStatusAuthorized ? @YES : self.authorizationStatus == UNAuthorizationStatusDenied ? @NO : Nil;
}

@end

@implementation UNNotificationCategory (Convenience)

+ (instancetype)categoryWithIdentifier:(NSString *)identifier actions:(NSArray<UNNotificationAction *> *)actions intentIdentifiers:(NSArray<NSString *> *)intentIdentifiers {
	return identifier && actions ? [self categoryWithIdentifier:identifier actions:actions intentIdentifiers:intentIdentifiers ? intentIdentifiers : @[ ] options:UNNotificationCategoryOptionNone] : Nil;
}

+ (instancetype)categoryWithIdentifier:(NSString *)identifier actions:(NSArray<UNNotificationAction *> *)actions {
	return identifier && actions ? [self categoryWithIdentifier:identifier actions:actions intentIdentifiers:@[ ] options:UNNotificationCategoryOptionNone] : Nil;
}

@end

@implementation UNNotificationAction (Convenience)

+ (instancetype)actionWithIdentifier:(NSString *)identifier title:(NSString *)title {
	return identifier && title ? [self actionWithIdentifier:identifier title:title options:UNNotificationActionOptionNone] : Nil;
}

@end

@implementation UNNotificationAttachment (Convenience)

+ (instancetype)attachmentWithURL:(NSURL *)URL identifier:(NSString *)identifier options:(NSDictionary *)options {
	NSError *error = Nil;

	UNNotificationAttachment *attachment = [self attachmentWithIdentifier:identifier URL:URL options:options error:&error];

	[error log:@"attachmentWithIdentifier:"];

	return attachment;
}

+ (instancetype)attachmentWithURL:(NSURL *)URL identifier:(NSString *)identifier {
	return [self attachmentWithURL:URL identifier:identifier options:Nil];
}

+ (instancetype)attachmentWithURL:(NSURL *)URL {
	return [self attachmentWithURL:URL identifier:Nil options:Nil];
}

@end

@implementation UNNotificationRequest (Convenience)

- (NSDate *)nextTriggerDate {
	return [self.trigger isKindOfClass:[UNTimeIntervalNotificationTrigger class]] ? ((UNTimeIntervalNotificationTrigger *)self.trigger).nextTriggerDate : [self.trigger isKindOfClass:[UNCalendarNotificationTrigger class]] ? ((UNCalendarNotificationTrigger *)self.trigger).nextTriggerDate : Nil;
}

@end

#define NSCalendarUnitDateAndTime NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond

@implementation UNNotificationContent (Convenience)

+ (instancetype)contentWithTitle:(NSString *)title subtitle:(NSString *)subtitle body:(NSString *)body badge:(NSNumber *)badge sound:(NSString *)sound attachments:(NSArray<NSURL *> *)attachments userInfo:(NSDictionary *)userInfo categoryIdentifier:(NSString *)categoryIdentifier {
	if (!body && !badge && !sound)
		return Nil;

	UNMutableNotificationContent *content = [UNMutableNotificationContent new];
	content.title = title;
	content.subtitle = subtitle;
	if (body)
		content.body = body;
	content.badge = badge;
	content.sound = sound ?
#if !(TARGET_OS_WATCH)
		sound.length ? [UNNotificationSound soundNamed:sound] :
#endif
		[UNNotificationSound defaultSound] : Nil;
	content.attachments = [attachments map:^id(NSURL *obj) {
		return [UNNotificationAttachment attachmentWithURL:obj];
	}];
	content.userInfo = userInfo;
	content.categoryIdentifier = categoryIdentifier;

	return content;
}

+ (instancetype)contentWithTitle:(NSString *)title body:(NSString *)body badge:(NSNumber *)badge sound:(NSString *)sound attachments:(NSArray<NSURL *> *)attachments {
	return [self contentWithTitle:title subtitle:Nil body:body badge:badge sound:sound attachments:attachments userInfo:Nil categoryIdentifier:Nil];
}

- (void)scheduleWithIdentifier:(NSString *)identifier completion:(void (^)(BOOL success))completion {
	[UNUserNotificationCenter addNotificationRequestWithIdentifier:identifier content:self trigger:Nil completion:completion];
}

- (void)scheduleWithIdentifier:(NSString *)identifier {
	[self scheduleWithIdentifier:identifier completion:Nil];
}

- (void)scheduleWithIdentifier:(NSString *)identifier timeInterval:(NSTimeInterval)timeInterval repeats:(BOOL)repeats completion:(void (^)(BOOL success))completion {
	if (timeInterval >= 0.0)
		[UNUserNotificationCenter addNotificationRequestWithIdentifier:identifier content:self trigger:[UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:repeats] completion:completion];
}

- (void)scheduleWithIdentifier:(NSString *)identifier timeInterval:(NSTimeInterval)timeInterval repeats:(BOOL)repeats {
	[self scheduleWithIdentifier:identifier timeInterval:timeInterval repeats:repeats completion:Nil];
}

- (void)scheduleWithIdentifier:(NSString *)identifier timeInterval:(NSTimeInterval)timeInterval {
	[self scheduleWithIdentifier:identifier timeInterval:timeInterval repeats:NO];
}

- (void)scheduleWithIdentifier:(NSString *)identifier dateComponents:(NSDateComponents *)dateComponents repeats:(BOOL)repeats completion:(void (^)(BOOL success))completion {
	if (dateComponents)
		[UNUserNotificationCenter addNotificationRequestWithIdentifier:identifier content:self trigger:[UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents repeats:repeats] completion:completion];
}

- (void)scheduleWithIdentifier:(NSString *)identifier dateComponents:(NSDateComponents *)dateComponents repeats:(BOOL)repeats {
	[self scheduleWithIdentifier:identifier dateComponents:dateComponents repeats:repeats completion:Nil];
}

- (void)scheduleWithIdentifier:(NSString *)identifier dateComponents:(NSDateComponents *)dateComponents {
	[self scheduleWithIdentifier:identifier dateComponents:dateComponents repeats:NO];
}

- (void)scheduleWithIdentifier:(NSString *)identifier date:(NSDate *)date repeats:(BOOL)repeats completion:(void (^)(BOOL success))completion {
	if (date)
		[UNUserNotificationCenter addNotificationRequestWithIdentifier:identifier content:self trigger:[UNCalendarNotificationTrigger triggerWithDateMatchingComponents:[[NSCalendar currentCalendar] components:NSCalendarUnitDateAndTime fromDate:date] repeats:repeats] completion:completion];
}

- (void)scheduleWithIdentifier:(NSString *)identifier date:(NSDate *)date repeats:(BOOL)repeats {
	[self scheduleWithIdentifier:identifier date:date repeats:repeats completion:Nil];
}

- (void)scheduleWithIdentifier:(NSString *)identifier date:(NSDate *)date {
	[self scheduleWithIdentifier:identifier date:date repeats:NO];
}

@end
