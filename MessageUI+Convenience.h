//
//  MessageUI+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <MessageUI/MessageUI.h>

#import "NSArray+Convenience.h"
#import "NSObject+Convenience.h"
#import "NSURL+Convenience.h"
#import "UIApplication+Convenience.h"

@import MessageUI;

@interface MFMailComposeViewController (Convenience)

+ (instancetype)createWithRecipients:(NSArray *)recipients subject:(NSString *)subject body:(NSString *)body;
+ (instancetype)createWithRecipients:(NSArray *)recipients subject:(NSString *)subject;
+ (instancetype)createWithRecipients:(NSArray *)recipients;

+ (instancetype)createWithRecipient:(NSString *)recipient subject:(NSString *)subject body:(NSString *)body;
+ (instancetype)createWithRecipient:(NSString *)recipient subject:(NSString *)subject;
+ (instancetype)createWithRecipient:(NSString *)recipient;

@end

@interface MFMailCompose : MFMailComposeViewController <MFMailComposeViewControllerDelegate>

@end

@interface NSURL (MessageUI)

+ (NSURL *)URLWithRecipients:(NSArray<NSString *> *)recipients subject:(NSString *)subject body:(NSString *)body;

@end

@interface UIViewController (MFMailComposeViewController)

- (MFMailComposeViewController *)presentMailComposeWithRecipients:(NSArray<NSString *> *)recipients subject:(NSString *)subject body:(NSString *)body completionHandler:(void (^)(MFMailComposeResult result, NSError *error))completionHandler;

- (MFMailComposeViewController *)presentMailComposeWithRecipients:(NSArray<NSString *> *)recipients subject:(NSString *)subject body:(NSString *)body;
- (MFMailComposeViewController *)presentMailComposeWithRecipients:(NSArray<NSString *> *)recipients subject:(NSString *)subject;
- (MFMailComposeViewController *)presentMailComposeWithRecipients:(NSArray<NSString *> *)recipients;

- (MFMailComposeViewController *)presentMailComposeWithRecipient:(NSString *)recipient subject:(NSString *)subject body:(NSString *)body;
- (MFMailComposeViewController *)presentMailComposeWithRecipient:(NSString *)recipient subject:(NSString *)subject;
- (MFMailComposeViewController *)presentMailComposeWithRecipient:(NSString *)recipient;

@end
