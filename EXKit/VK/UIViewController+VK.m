//
//  UIViewController+VK.m
//  Ringo
//
//  Created by Alexander Ivanov on 28.08.15.
//  Copyright (c) 2015 Alexander Ivanov. All rights reserved.
//

#import "UIViewController+VK.h"
#import "NSArray+Convenience.h"
#import "VKHelper.h"

@implementation UIViewController (VK)

- (void)presentShareDialogWithURL:(NSURL *)url title:(NSString *)title uploadImages:(NSArray *)uploadImages completion:(void (^)(VKShareDialogControllerResult result))completionHandler {
	VKShareDialogController *vc = [VKShareDialogController new];
	
	vc.dismissAutomatically = YES;
	vc.text = title;
	vc.shareLink = [[VKShareLink alloc] initWithTitle:title link:url];
	vc.uploadImages = [uploadImages map:^id(id obj) {
		return [VKUploadImage uploadImageWithImage:obj andParams:Nil];
	}];

	vc.completionHandler = completionHandler;
	
	[self presentViewController:vc animated:YES completion:Nil];
}

- (void)presentShareDialogWithURL:(NSURL *)url title:(NSString *)title uploadImages:(NSArray *)uploadImages {
	[self presentShareDialogWithURL:url title:title uploadImages:uploadImages completion:Nil];
}

- (void)presentAlertForGroupWithID:(NSUInteger)groupID title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancel joinButtonTitle:(NSString *)join configuration:(void (^)(UIAlertController *instance))configuration completion:(void(^)(BOOL))handler {
	if ([VKSdk wakeUpSession:[VKHelper instance].permissions])
		[VKHelper isMember:0 ofGroup:groupID handler:^(BOOL isMember) {
			if (!isMember)
				[self presentAlertWithTitle:title message:message cancelActionTitle:cancel destructiveActionTitle:Nil otherActionTitles:@[ join ] configuration:configuration completion:^(UIAlertController *instance, NSInteger index) {
					if (index == 0)
						[VKHelper joinGroup:groupID handler:handler];
					else if (handler)
						handler(NO);
				}];
			else if (handler)
				handler(YES);
		}];
	else if (handler)
		handler(NO);
}

@end
