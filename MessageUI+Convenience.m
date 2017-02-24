//
//  MessageUI+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "MessageUI+Convenience.h"

@implementation MFMailComposeViewController (Convenience)

+ (instancetype)createWithRecipients:(NSArray *)recipients subject:(NSString *)subject body:(NSString *)body attachments:(NSDictionary<NSString *,NSData *> *)attachments {
	if (![self canSendMail])
		return Nil;

	MFMailComposeViewController *instance = [self new];
	[instance setToRecipients:recipients];
	if (subject)
		[instance setSubject:subject];
	if (body)
		[instance setMessageBody:body isHTML:NO];
	for (NSString *name in attachments.allKeys)
		[instance addAttachmentData:attachments[name] mimeType:[UTType mimeTypeFromFilenameExtension:name.pathExtension] ?: @"application/octet-stream" fileName:name];

	return instance;
}

+ (instancetype)createWithRecipients:(NSArray *)recipients subject:(NSString *)subject body:(NSString *)body {
	return [self createWithRecipients:recipients subject:subject body:body attachments:Nil];
}

+ (instancetype)createWithRecipients:(NSArray *)recipients subject:(NSString *)subject {
	return [self createWithRecipients:recipients subject:subject body:Nil attachments:Nil];
}

+ (instancetype)createWithRecipients:(NSArray *)recipients {
	return [self createWithRecipients:recipients subject:Nil body:Nil attachments:Nil];
}

+ (instancetype)createWithRecipient:(NSString *)recipient subject:(NSString *)subject body:(NSString *)body {
	return [self createWithRecipients:arr_(recipient) subject:subject body:body attachments:Nil];
}

+ (instancetype)createWithRecipient:(NSString *)recipient subject:(NSString *)subject {
	return [self createWithRecipients:arr_(recipient) subject:subject body:Nil attachments:Nil];
}

+ (instancetype)createWithRecipient:(NSString *)recipient {
	return [self createWithRecipients:arr_(recipient) subject:Nil body:Nil attachments:Nil];
}

@end

@interface MFMailCompose ()
@property (copy, nonatomic) void(^completionHandler)(MFMailComposeResult result, NSError *error);
@end

@implementation MFMailCompose

- (instancetype)init {
	self = [super init];

	if (self)
		self.mailComposeDelegate = self;

	return self;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	if (self.completionHandler)
		self.completionHandler(result, error);

	[controller dismissViewControllerAnimated:YES completion:Nil];

	[error log:@"mailComposeController:didFinishWithResult:error:"];
}

@end

@implementation NSURL (MessageUI)

+ (NSURL *)URLWithRecipients:(NSArray<NSString *> *)recipients subject:(NSString *)subject body:(NSString *)body {
	NSMutableDictionary *parameters = [NSMutableDictionary new];
	parameters[@"subject"] = subject;
	parameters[@"body"] = body;
	return [[NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", [recipients componentsJoinedByString:STR_SEMICOLON]]] URLByAppendingQueryDictionary:parameters];
}

@end

@implementation UIViewController (MFMailComposeViewController)

- (MFMailComposeViewController *)presentMailComposeWithRecipients:(NSArray<NSString *> *)recipients subject:(NSString *)subject body:(NSString *)body attachments:(NSDictionary<NSString *,NSData *> *)attachments completionHandler:(void (^)(MFMailComposeResult, NSError *))completionHandler {
	MFMailCompose *vc = [MFMailCompose createWithRecipients:recipients subject:subject body:body attachments:attachments];
	vc.completionHandler = completionHandler;

	if (vc)
		[self presentViewController:vc animated:YES completion:Nil];
	else
		[UIApplication openURL:[NSURL URLWithRecipients:recipients subject:subject body:body] options:Nil completionHandler:^(BOOL success) {
			if (completionHandler)
				completionHandler(MFMailComposeResultFailed, Nil);
		}];

	return vc;
}

- (MFMailComposeViewController *)presentMailComposeWithRecipients:(NSArray<NSString *> *)recipients subject:(NSString *)subject body:(NSString *)body {
	return [self presentMailComposeWithRecipients:recipients subject:subject body:body attachments:Nil completionHandler:Nil];
}

- (MFMailComposeViewController *)presentMailComposeWithRecipients:(NSArray<NSString *> *)recipients subject:(NSString *)subject {
	return [self presentMailComposeWithRecipients:recipients subject:subject body:Nil attachments:Nil completionHandler:Nil];
}

- (MFMailComposeViewController *)presentMailComposeWithRecipients:(NSArray<NSString *> *)recipients {
	return [self presentMailComposeWithRecipients:recipients subject:Nil body:Nil attachments:Nil completionHandler:Nil];
}

- (MFMailComposeViewController *)presentMailComposeWithRecipient:(NSString *)recipient subject:(NSString *)subject body:(NSString *)body {
	return [self presentMailComposeWithRecipients:arr_(recipient) subject:subject body:body attachments:Nil completionHandler:Nil];
}

- (MFMailComposeViewController *)presentMailComposeWithRecipient:(NSString *)recipient subject:(NSString *)subject {
	return [self presentMailComposeWithRecipients:arr_(recipient) subject:subject body:Nil attachments:Nil completionHandler:Nil];
}

- (MFMailComposeViewController *)presentMailComposeWithRecipient:(NSString *)recipient {
	return [self presentMailComposeWithRecipients:arr_(recipient) subject:Nil body:Nil attachments:Nil completionHandler:Nil];
}

@end
