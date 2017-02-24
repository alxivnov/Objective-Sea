//
//  UserNotifications+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 05.10.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

@import UserNotifications;

#import "NSArray+Convenience.h"
#import "NSObject+Convenience.h"

#if TARGET_OS_IPHONE
@import UIKit;

#import "UIApplication+Convenience.h"
#endif

#define UNAuthorizationOptionAll (UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound)

#define UNNotificationPresentationOptionAll (UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert)

@interface UNUserNotificationCenter (Convenience)

+ (void)setDelegate:(id<UNUserNotificationCenterDelegate>)delegate;

+ (void)requestAuthorizationWithOptions:(UNAuthorizationOptions)options completionHandler:(void (^)(BOOL granted))completionHandler;

#if TARGET_OS_IPHONE
+ (void)requestAuthorizationIfNeededWithOptions:(UNAuthorizationOptions)options completionHandler:(void (^)(NSNumber *granted))completionHandler;
#endif

+ (void)setNotificationCategories:(NSArray<UNNotificationCategory *> *)categories;
+ (void)getNotificationCategories:(void (^)(NSArray<UNNotificationCategory *> *))completionHandler;

+ (void)getNotificationSettings:(void (^)(UNNotificationSettings *settings))completionHandler;

+ (void)addNotificationRequestWithIdentifier:(NSString *)identifier content:(UNNotificationContent *)content trigger:(UNNotificationTrigger *)trigger completion:(void (^)(BOOL success))completion;
+ (void)addNotificationRequestWithIdentifier:(NSString *)identifier content:(UNNotificationContent *)content trigger:(UNNotificationTrigger *)trigger;

+ (void)getPendingNotificationRequestsWithCompletionHandler:(void(^)(NSArray<UNNotificationRequest *> *requests))completionHandler;
+ (void)getPendingNotificationRequestsWithIdentifier:(NSString *)identifier completionHandler:(void(^)(NSArray<UNNotificationRequest *> *requests))completionHandler;
+ (void)getPendingNotificationRequestWithIdentifier:(NSString *)identifier completionHandler:(void(^)(UNNotificationRequest *request))completionHandler;
+ (void)removePendingNotificationRequestsWithIdentifiers:(NSArray<NSString *> *)identifiers;
+ (void)removePendingNotificationRequestWithIdentifier:(NSString *)identifier;
+ (void)removeAllPendingNotificationRequests;

+ (void)getDeliveredNotificationsWithCompletionHandler:(void(^)(NSArray<UNNotification *> *notifications))completionHandler;
+ (void)getDeliveredNotificationsWithIdentifier:(NSString *)identifier completionHandler:(void(^)(NSArray<UNNotification *> *notifications))completionHandler;
+ (void)getDeliveredNotificationWithIdentifier:(NSString *)identifier completionHandler:(void(^)(UNNotification *notification))completionHandler;
+ (void)removeDeliveredNotificationsWithIdentifiers:(NSArray<NSString *> *)identifiers;
+ (void)removeDeliveredNotificationWithIdentifier:(NSString *)identifier;
+ (void)removeAllDeliveredNotifications;

+ (void)removeNotificationsWithIdentifiers:(NSArray<NSString *> *)identifiers;
+ (void)removeNotificationsWithIdentifier:(NSString *)identifier;
+ (void)removeAllNotifications;

@end

@interface UNNotificationSettings (Convenience)

@property (strong, nonatomic, readonly) NSNumber *authorization;

@end

@interface UNNotificationCategory (Convenience)

+ (instancetype)categoryWithIdentifier:(NSString *)identifier actions:(NSArray<UNNotificationAction *> *)actions intentIdentifiers:(NSArray<NSString *> *)intentIdentifiers;

+ (instancetype)categoryWithIdentifier:(NSString *)identifier actions:(NSArray<UNNotificationAction *> *)actions;

@end

@interface UNNotificationAction (Convenience)

+ (instancetype)actionWithIdentifier:(NSString *)identifier title:(NSString *)title;

@end

@interface UNNotificationRequest (Convenience)

@property (strong, nonatomic, readonly) NSDate *nextTriggerDate;

@end

@interface UNNotificationContent (Convenience)

+ (instancetype)contentWithTitle:(NSString *)title subtitle:(NSString *)subtitle body:(NSString *)body badge:(NSNumber *)badge sound:(NSString *)sound attachments:(NSArray<NSURL *> *)attachments userInfo:(NSDictionary *)userInfo categoryIdentifier:(NSString *)categoryIdentifier;
+ (instancetype)contentWithTitle:(NSString *)title body:(NSString *)body badge:(NSNumber *)badge sound:(NSString *)sound attachments:(NSArray<NSURL *> *)attachments;

- (void)scheduleWithIdentifier:(NSString *)identifier completion:(void (^)(BOOL success))completion;
- (void)scheduleWithIdentifier:(NSString *)identifier;

- (void)scheduleWithIdentifier:(NSString *)identifier timeInterval:(NSTimeInterval)timeInterval repeats:(BOOL)repeats completion:(void (^)(BOOL success))completion;
- (void)scheduleWithIdentifier:(NSString *)identifier timeInterval:(NSTimeInterval)timeInterval repeats:(BOOL)repeats;
- (void)scheduleWithIdentifier:(NSString *)identifier timeInterval:(NSTimeInterval)timeInterval;

- (void)scheduleWithIdentifier:(NSString *)identifier dateComponents:(NSDateComponents *)dateComponents repeats:(BOOL)repeats completion:(void (^)(BOOL success))completion;
- (void)scheduleWithIdentifier:(NSString *)identifier dateComponents:(NSDateComponents *)dateComponents repeats:(BOOL)repeats;
- (void)scheduleWithIdentifier:(NSString *)identifier dateComponents:(NSDateComponents *)dateComponents;

- (void)scheduleWithIdentifier:(NSString *)identifier date:(NSDate *)date repeats:(BOOL)repeats completion:(void (^)(BOOL success))completion;
- (void)scheduleWithIdentifier:(NSString *)identifier date:(NSDate *)date repeats:(BOOL)repeats;
- (void)scheduleWithIdentifier:(NSString *)identifier date:(NSDate *)date;

@end

@interface UNNotificationAttachment (Convenience)

+ (instancetype)attachmentWithURL:(NSURL *)URL identifier:(NSString *)identifier options:(NSDictionary *)options;
+ (instancetype)attachmentWithURL:(NSURL *)URL identifier:(NSString *)identifier;
+ (instancetype)attachmentWithURL:(NSURL *)URL;

@end
