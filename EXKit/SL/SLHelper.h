//
//  SLHelper.h
//  Done!
//
//  Created by Alexander Ivanov on 01.11.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APP_STORE @"App Store"
#define FACEBOOK @"Facebook"
#define TWITTER @"Twitter"
#define WEBSITE @"airtasks.net"
#define EMAIL @"alex.p.ivanov@gmail.com"
#define HASHTAG @"airtasks"

@import Social;

@class SLHelper;

@protocol SLHelperDelegate <NSObject>

- (void)composeClickedButtonWithTitle:(NSString *)title;
- (void)composeDone:(SLComposeViewController *)sender;
- (void)composeCancelled:(SLComposeViewController *)sender;

@end

@interface SLHelper : NSObject <UIActionSheetDelegate, UIAlertViewDelegate>

+ (UIViewController *)composeWithServiceType:(NSString *)serviceType initialText:(NSString *)text image:(UIImage *)image url:(NSURL *)url completion:(void (^)(NSString *activityType, BOOL completed))completion;

+ (void)composeWithTitle:(NSString *)title presentingViewController:(UIViewController *)presentingViewController appStore:(BOOL)appStore initialText:(NSString *)initialText image:(UIImage *)image appStoreURL:(NSURL *)appStoreURL websiteURL:(NSURL *)websiteURL email:(NSString *)email delegate:(id <SLHelperDelegate>)delegate alert:(BOOL)alert;

+ (NSString *)appStore;
+ (NSString *)facebook;
+ (NSString *)twitter;
+ (NSString *)website;
+ (NSString *)email;

@end
