//
//  UIViewController+VK.h
//  Ringo
//
//  Created by Alexander Ivanov on 28.08.15.
//  Copyright (c) 2015 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VKSdk/VKSdk.h>

@interface UIViewController (VK)

- (void)presentShareDialogWithURL:(NSURL *)url title:(NSString *)title uploadImages:(NSArray *)uploadImages completion:(void (^)(VKShareDialogControllerResult result))completionHandler;
- (void)presentShareDialogWithURL:(NSURL *)url title:(NSString *)title uploadImages:(NSArray *)uploadImages;

- (void)presentAlertForGroupWithID:(NSUInteger)groupID title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancel joinButtonTitle:(NSString *)join configuration:(void (^)(UIAlertController *instance))configuration completion:(void(^)(BOOL))handler;

@end
