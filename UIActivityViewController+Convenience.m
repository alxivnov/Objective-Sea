//
//  UIActivityViewController+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UIActivityViewController+Convenience.h"

@implementation UIActivityViewController (Convenience)

+ (instancetype)activityWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray<__kindof UIActivity *> *)applicationActivities excludedActivityTypes:(NSArray<UIActivityType> *)excludedActivityTypes completionHandler:(UIActivityViewControllerCompletionWithItemsHandler)completionHandler {
	UIActivityViewController *instance = [[self alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
	instance.excludedActivityTypes = excludedActivityTypes;
	instance.completionWithItemsHandler = completionHandler;
	return instance;
}


+ (instancetype)webActivityWithActivityItems:(NSArray *)activityItems excludedActivityTypes:(NSArray<UIActivityType> *)excludedActivityTypes completionHandler:(UIActivityViewControllerCompletionWithItemsHandler)completionHandler {
	NSArray<__kindof UIActivity *> *applicationActivities = [[UIWebActivity webActivities:Nil] query:^BOOL(__kindof UIWebActivity *obj) {
		return ![excludedActivityTypes any:^BOOL(id type) {
			return [obj.activityType isEqualToString:type];
		}];
	}];

	if (![excludedActivityTypes any:^BOOL(id item) {
		return [UIDocumentExportActivityType isEqualToString:item];
	}])
		[applicationActivities arrayByAddingObject:[UIDocumentExportActivity new]];

	return [self activityWithActivityItems:activityItems applicationActivities:applicationActivities excludedActivityTypes:excludedActivityTypes completionHandler:completionHandler];
}

@end

@implementation UIViewController (Activity)

- (UIActivityViewController *)presentActivityWithActivityItems:(NSArray *)items applicationActivities:(NSArray<__kindof UIActivity *> *)activities excludedActivityTypes:(NSArray *)excluded completionHandler:(UIActivityViewControllerCompletionWithItemsHandler)handler source:(id)source {
	if (!items.count)
		return Nil;

	UIActivityViewController *activity = [UIActivityViewController activityWithActivityItems:items applicationActivities:activities excludedActivityTypes:excluded completionHandler:handler];

	[self popoverViewController:activity from:source];

	return activity;
}

- (UIActivityViewController *)presentActivityWithActivityItems:(NSArray *)items applicationActivities:(NSArray<__kindof UIActivity *> *)activities completionHandler:(UIActivityViewControllerCompletionWithItemsHandler)handler sourceView:(UIView *)view {
	return [self presentActivityWithActivityItems:items applicationActivities:activities excludedActivityTypes:Nil completionHandler:handler source:view];
}

- (UIActivityViewController *)presentActivityWithActivityItems:(NSArray *)items applicationActivities:(NSArray<__kindof UIActivity *> *)activities completionHandler:(UIActivityViewControllerCompletionWithItemsHandler)handler sourceBarButton:(UIBarButtonItem *)button {
	return [self presentActivityWithActivityItems:items applicationActivities:activities excludedActivityTypes:Nil completionHandler:handler source:button];
}

- (UIActivityViewController *)presentActivityWithActivityItems:(NSArray *)items applicationActivities:(NSArray<__kindof UIActivity *> *)activities completionHandler:(UIActivityViewControllerCompletionWithItemsHandler)handler {
	return [self presentActivityWithActivityItems:items applicationActivities:activities excludedActivityTypes:Nil completionHandler:handler source:Nil];
}

- (UIActivityViewController *)presentActivityWithActivityItems:(NSArray *)items {
	return [self presentActivityWithActivityItems:items applicationActivities:Nil excludedActivityTypes:Nil completionHandler:Nil source:Nil];
}



- (UIActivityViewController *)presentWebActivityWithActivityItems:(NSArray *)items excludedTypes:(NSArray *)types completionHandler:(UIActivityViewControllerCompletionWithItemsHandler)completion source:(id)source {
	if (!items.count)
		return Nil;

	UIActivityViewController *activity = [UIActivityViewController webActivityWithActivityItems:items excludedActivityTypes:types completionHandler:completion];

	[self popoverViewController:activity from:source];

	return activity;
}

- (UIActivityViewController *)presentWebActivityWithActivityItems:(NSArray *)items excludedTypes:(NSArray *)types completionHandler:(UIActivityViewControllerCompletionWithItemsHandler)handler sourceView:(UIView *)view {
	return [self presentWebActivityWithActivityItems:items excludedTypes:types completionHandler:handler source:view];
}

- (UIActivityViewController *)presentWebActivityWithActivityItems:(NSArray *)items excludedTypes:(NSArray *)types completionHandler:(UIActivityViewControllerCompletionWithItemsHandler)handler sourceBarButton:(UIBarButtonItem *)button {
	return [self presentWebActivityWithActivityItems:items excludedTypes:types completionHandler:handler source:button];
}

- (UIActivityViewController *)presentWebActivityWithActivityItems:(NSArray *)items excludedTypes:(NSArray *)types completionHandler:(UIActivityViewControllerCompletionWithItemsHandler)handler {
	return [self presentWebActivityWithActivityItems:items excludedTypes:types completionHandler:handler source:Nil];
}

- (UIActivityViewController *)presentWebActivityWithActivityItems:(NSArray *)items {
	return [self presentWebActivityWithActivityItems:items excludedTypes:Nil completionHandler:Nil sourceView:Nil];
}

@end
