//
//  MessageUI+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <MessageUI/MessageUI.h>

#import "NSObject+Convenience.h"

@import MessageUI;

@interface MFMailCompose : MFMailComposeViewController <MFMailComposeViewControllerDelegate>

+ (instancetype)createWithRecipients:(NSArray *)recipients subject:(NSString *)subject body:(NSString *)body;
+ (instancetype)createWithRecipients:(NSArray *)recipients subject:(NSString *)subject;
+ (instancetype)createWithRecipients:(NSArray *)recipients;

+ (instancetype)createWithRecipient:(NSString *)recipient subject:(NSString *)subject body:(NSString *)body;
+ (instancetype)createWithRecipient:(NSString *)recipient subject:(NSString *)subject;
+ (instancetype)createWithRecipientNSString:(NSString *)recipient;

@end

@interface UIViewController (MessageUI)

- (void)presentMailWithRecipients:(NSArray *)recipients subject:(NSString *)subject body:(NSString *)body;
- (void)presentMailWithRecipients:(NSArray *)recipients subject:(NSString *)subject;
- (void)presentMailWithRecipients:(NSArray *)recipients;

- (void)presentMailWithRecipient:(NSString *)recipient subject:(NSString *)subject body:(NSString *)body;
- (void)presentMailWithRecipient:(NSString *)recipient subject:(NSString *)subject;
- (void)presentMailWithRecipient:(NSString *)recipient;

@end
