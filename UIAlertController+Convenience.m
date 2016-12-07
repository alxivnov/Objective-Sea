//
//  UIAlertController+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 16.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UIAlertController+Convenience.h"

@implementation UIAlertAction (Convenience)

- (void)setActionImage:(UIImage *)image {
	[self trySetValue:image forKey:@"_image"];
}

- (void)setActionColor:(UIColor *)color {
	[self trySetValue:color forKey:@"_imageTintColor"];
	[self trySetValue:color forKey:@"_titleTextColor"];
}

@end

@implementation UIAlertController (Convenience)

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle cancelActionTitle:(NSString *)cancelActionTitle destructiveActionTitle:(NSString *)destructiveActionTitle otherActionTitles:(NSArray *)otherActionTitles completion:(void (^)(UIAlertController *instance, NSInteger index))completion {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];

	__weak UIAlertController *__alert = alert;
	void (^handler)(UIAlertAction *) = ^(UIAlertAction *action) {
		NSUInteger index = [__alert.actions indexOfObject:action];
		if (completion)
			completion(__alert, action.style == UIAlertActionStyleCancel ? UIAlertActionCancel : action.style == UIAlertActionStyleDestructive ? UIAlertActionDestructive : index);
	};

	for (NSString *otherActionTitle in otherActionTitles)
		[alert addAction:[UIAlertAction actionWithTitle:otherActionTitle style:UIAlertActionStyleDefault handler:handler]];

	if (destructiveActionTitle)
		[alert addAction:[UIAlertAction actionWithTitle:destructiveActionTitle style:UIAlertActionStyleDestructive handler:handler]];

	if (cancelActionTitle/* && [self iPhone]*/)
		[alert addAction:[UIAlertAction actionWithTitle:cancelActionTitle style:UIAlertActionStyleCancel handler:handler]];

	return alert;
}

+ (instancetype)sheetWithTitle:(NSString *)title message:(NSString *)message cancelActionTitle:(NSString *)cancelActionTitle destructiveActionTitle:(NSString *)destructiveActionTitle otherActionTitles:(NSArray *)otherActionTitles completion:(void (^)(UIAlertController *instance, NSInteger index))completion {
	return [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet cancelActionTitle:cancelActionTitle destructiveActionTitle:destructiveActionTitle otherActionTitles:otherActionTitles completion:completion];
}

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message cancelActionTitle:(NSString *)cancelActionTitle destructiveActionTitle:(NSString *)destructiveActionTitle otherActionTitles:(NSArray *)otherActionTitles completion:(void (^)(UIAlertController *instance, NSInteger index))completion {
	return [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert cancelActionTitle:cancelActionTitle destructiveActionTitle:destructiveActionTitle otherActionTitles:otherActionTitles completion:completion];
}

@end

@implementation UIViewController (UIAlertController)

- (UIAlertController *)presentAlertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle cancelActionTitle:(NSString *)cancelActionTitle destructiveActionTitle:(NSString *)destructiveActionTitle otherActionTitles:(NSArray *)otherActionTitles from:(id)from configuration:(void (^)(UIAlertController *instance))configuration completion:(void (^)(UIAlertController *instance, NSInteger index))completion {
	if (!title && !message && !completion)
		return Nil;

	UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle cancelActionTitle:cancelActionTitle destructiveActionTitle:destructiveActionTitle otherActionTitles:otherActionTitles completion:completion];

	if (configuration)
		configuration(alert);

	if (alert) {
		if (preferredStyle == UIAlertControllerStyleActionSheet)
			[self popoverViewController:alert from:from];
		else
			[self presentViewController:alert animated:YES completion:Nil];
	}

	return alert;
}

- (UIAlertController *)presentAlertWithTitle:(NSString *)title message:(NSString *)message cancelActionTitle:(NSString *)cancelActionTitle destructiveActionTitle:(NSString *)destructiveActionTitle otherActionTitles:(NSArray *)otherActionTitles configuration:(void (^)(UIAlertController *instance))configuration completion:(void (^)(UIAlertController *instance, NSInteger index))completion {
	return [self presentAlertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert cancelActionTitle:cancelActionTitle destructiveActionTitle:destructiveActionTitle otherActionTitles:otherActionTitles from:Nil configuration:configuration completion:completion];
}

- (UIAlertController *)presentAlertWithTitle:(NSString *)title message:(NSString *)message cancelActionTitle:(NSString *)cancelActionTitle destructiveActionTitle:(NSString *)destructiveActionTitle otherActionTitles:(NSArray *)otherActionTitles completion:(void (^)(UIAlertController *instance, NSInteger index))completion {
	return [self presentAlertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert cancelActionTitle:cancelActionTitle destructiveActionTitle:destructiveActionTitle otherActionTitles:otherActionTitles from:Nil configuration:Nil completion:completion];
}

- (UIAlertController *)presentAlertWithTitle:(NSString *)title cancelActionTitle:(NSString *)cancelActionTitle {
	return [self presentAlertWithTitle:title message:Nil cancelActionTitle:cancelActionTitle destructiveActionTitle:Nil otherActionTitles:Nil completion:Nil];
}

- (UIAlertController *)presentAlertWithError:(NSError *)error cancelActionTitle:(NSString *)cancelActionTitle {
	return [self presentAlertWithTitle:error.localizedDescription message:error.localizedFailureReason cancelActionTitle:cancelActionTitle destructiveActionTitle:Nil otherActionTitles:Nil completion:Nil];
}

- (UIAlertController *)presentSheetWithTitle:(NSString *)title message:(NSString *)message cancelActionTitle:(NSString *)cancelActionTitle destructiveActionTitle:(NSString *)destructiveActionTitle otherActionTitles:(NSArray *)otherActionTitles from:(id)from configuration:(void (^)(UIAlertController *instance))configuration completion:(void (^)(UIAlertController *instance, NSInteger index))completion {
	return [self presentAlertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet cancelActionTitle:cancelActionTitle destructiveActionTitle:destructiveActionTitle otherActionTitles:otherActionTitles from:from configuration:configuration completion:completion];
}

- (UIAlertController *)presentSheetWithTitle:(NSString *)title message:(NSString *)message cancelActionTitle:(NSString *)cancelActionTitle destructiveActionTitle:(NSString *)destructiveActionTitle otherActionTitles:(NSArray *)otherActionTitles from:(id)from completion:(void (^)(UIAlertController *instance, NSInteger index))completion {
	return [self presentAlertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet cancelActionTitle:cancelActionTitle destructiveActionTitle:destructiveActionTitle otherActionTitles:otherActionTitles from:from configuration:Nil completion:completion];
}

- (UIAlertController *)presentSheetWithTitle:(NSString *)title cancelActionTitle:(NSString *)cancelActionTitle from:(id)from {
	return [self presentSheetWithTitle:title message:Nil cancelActionTitle:cancelActionTitle destructiveActionTitle:Nil otherActionTitles:Nil from:from completion:Nil];
}

- (UIAlertController *)presentSheetWithError:(NSError *)error cancelActionTitle:(NSString *)cancelActionTitle from:(id)from {
	return [self presentSheetWithTitle:error.localizedDescription message:error.localizedFailureReason cancelActionTitle:cancelActionTitle destructiveActionTitle:Nil otherActionTitles:Nil from:from completion:Nil];
}

@end
