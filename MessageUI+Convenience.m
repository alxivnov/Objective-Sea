//
//  MessageUI+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "MessageUI+Convenience.h"

@interface MFMailCompose ()
@property (copy, nonatomic) void(^completion)(MFMailComposeResult result, NSError *error);
@end

@implementation MFMailCompose

- (instancetype)init {
	self = [super init];

	if (self)
		self.mailComposeDelegate = self;

	return self;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[controller dismissViewControllerAnimated:YES completion:Nil];

	if (self.completion)
		self.completion(result, error);
}

+ (instancetype)createWithRecipients:(NSArray *)recipients subject:(NSString *)subject body:(NSString *)body {
	if (![MFMailComposeViewController canSendMail])
		return Nil;

	MFMailCompose *instance = [self new];
	[instance setToRecipients:recipients];
	[instance setSubject:subject];
	[instance setMessageBody:body isHTML:NO];
	return instance;
}

+ (instancetype)createWithRecipients:(NSArray *)recipients subject:(NSString *)subject {
	return [self createWithRecipients:recipients subject:subject body:Nil];
}

+ (instancetype)createWithRecipients:(NSArray *)recipients {
	return [self createWithRecipients:recipients subject:Nil body:Nil];
}

+ (instancetype)createWithRecipient:(NSString *)recipient subject:(NSString *)subject body:(NSString *)body {
	return [self createWithRecipients:arr_(recipient) subject:subject body:body];
}

+ (instancetype)createWithRecipient:(NSString *)recipient subject:(NSString *)subject {
	return [self createWithRecipients:arr_(recipient) subject:subject body:Nil];
}

+ (instancetype)createWithRecipientNSString:(NSString *)recipient {
	return [self createWithRecipients:arr_(recipient) subject:Nil body:Nil];
}

@end

@implementation UIViewController (MessageUI)

- (void)presentMailWithRecipients:(NSArray *)recipients subject:(NSString *)subject body:(NSString *)body {
	MFMailCompose *vc = [MFMailCompose createWithRecipients:recipients subject:subject body:body];

	[self presentViewController:vc animated:YES completion:Nil];
}

- (void)presentMailWithRecipients:(NSArray *)recipients subject:(NSString *)subject {
	[self presentMailWithRecipients:recipients subject:subject body:Nil];
}

- (void)presentMailWithRecipients:(NSArray *)recipients {
	[self presentMailWithRecipients:recipients subject:Nil body:Nil];
}

- (void)presentMailWithRecipient:(NSString *)recipient subject:(NSString *)subject body:(NSString *)body {
	[self presentMailWithRecipients:arr_(recipient) subject:subject body:body];
}

- (void)presentMailWithRecipient:(NSString *)recipient subject:(NSString *)subject {
	[self presentMailWithRecipients:arr_(recipient) subject:subject body:Nil];
}

- (void)presentMailWithRecipient:(NSString *)recipient {
	[self presentMailWithRecipients:arr_(recipient) subject:Nil body:Nil];
}

@end
