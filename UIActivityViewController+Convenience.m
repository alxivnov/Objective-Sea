//
//  UIActivityViewController+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UIActivityViewController+Convenience.h"

@implementation UIActivityViewController (Create)

+ (instancetype)createWithActivityItems:(NSArray *)items andApplicationActivities:(NSArray *)activities completion:(UIActivityViewControllerCompletionWithItemsHandler)completion {
	UIActivityViewController *instance = [[self alloc] initWithActivityItems:items applicationActivities:activities];
		[instance performSelector:@selector(setCompletionHandler:) withObject:^(NSString *activityType, BOOL completed) {
			completion(activityType, completed, Nil, Nil);
		}];
	//	instance.excludedActivityTypes = types;
	return instance;
}

+ (instancetype)createWithActivityItems:(NSArray *)items completion:(UIActivityViewControllerCompletionWithItemsHandler)completion {
	return [self createWithActivityItems:items andApplicationActivities:Nil completion:completion];
}

+ (instancetype)createWithActivityItems:(NSArray *)items {
	return [self createWithActivityItems:items andApplicationActivities:Nil completion:Nil];
}

+ (instancetype)createWithActivityItems:(NSArray *)items andExcludedTypes:(NSArray *)types completion:(UIActivityViewControllerCompletionWithItemsHandler)completion {
	UIActivityViewController *instance = [[self alloc] initWithActivityItems:items applicationActivities:Nil];
	instance.completionWithItemsHandler = completion;
	instance.excludedActivityTypes = types;
	return instance;
}

+ (instancetype)createWebActivityWithItems:(NSArray *)items andExcludedTypes:(NSArray *)types completion:(UIActivityViewControllerCompletionWithItemsHandler)completion {
	NSArray<__kindof UIActivity *> *activities = [[UIWebActivity webActivities:Nil] query:^BOOL(__kindof UIWebActivity *obj) {
		return ![types any:^BOOL(id type) {
			return [obj.activityType isEqualToString:type];
		}];
	}];

	if (![types any:^BOOL(id item) {
		return [UIDocumentExportActivityType isEqualToString:item];
	}])
		[activities arrayByAddingObject:[UIDocumentExportActivity new]];

	UIActivityViewController *activity = [self createWithActivityItems:items andApplicationActivities:activities completion:completion];
	activity.excludedActivityTypes = types;
	return activity;
}

+ (instancetype)createWebActivityWithItems:(NSArray *)items completion:(UIActivityViewControllerCompletionWithItemsHandler)completion {
	return [self createWebActivityWithItems:items andExcludedTypes:Nil completion:completion];
}

+ (instancetype)createWebActivityWithItems:(NSArray *)items {
	return [self createWebActivityWithItems:items andExcludedTypes:Nil completion:Nil];
}

@end

@implementation UIViewController (Activity)

- (UIActivityViewController *)presentActivityWithItems:(NSArray *)items applicationActivities:(NSArray *)activities excludedActivityTypes:(NSArray *)types completion:(UIActivityViewControllerCompletionWithItemsHandler)completion source:(id)source {
	if (!items.count)
		return Nil;

	UIActivityViewController *activity = [UIActivityViewController createWithActivityItems:items andApplicationActivities:activities completion:completion];
	activity.excludedActivityTypes = types;

	[self popoverViewController:activity from:source];

	return activity;
}

- (UIActivityViewController *)presentActivityWithItems:(NSArray *)items andApplicationActivities:(NSArray *)activities completion:(UIActivityViewControllerCompletionWithItemsHandler)completion sourceView:(UIView *)view {
	return [self presentActivityWithItems:items applicationActivities:activities excludedActivityTypes:Nil completion:completion source:view];
}

- (UIActivityViewController *)presentActivityWithItems:(NSArray *)items andApplicationActivities:(NSArray *)activities completion:(UIActivityViewControllerCompletionWithItemsHandler)completion sourceBarButton:(UIBarButtonItem *)button {
	return [self presentActivityWithItems:items applicationActivities:activities excludedActivityTypes:Nil completion:completion source:button];
}

- (UIActivityViewController *)presentActivityWithItems:(NSArray *)items andApplicationActivities:(NSArray *)activities completion:(UIActivityViewControllerCompletionWithItemsHandler)completion {
	return [self presentActivityWithItems:items applicationActivities:activities excludedActivityTypes:Nil completion:completion source:Nil];
}

- (UIActivityViewController *)presentActivityWithItems:(NSArray *)items completion:(UIActivityViewControllerCompletionWithItemsHandler)completion {
	return [self presentActivityWithItems:items applicationActivities:Nil excludedActivityTypes:Nil completion:completion source:Nil];
}

- (UIActivityViewController *)presentActivityWithItems:(NSArray *)items {
	return [self presentActivityWithItems:items applicationActivities:Nil excludedActivityTypes:Nil completion:Nil source:Nil];
}

- (UIActivityViewController *)presentActivityWithItems:(NSArray *)items andExcludedTypes:(NSArray *)types completion:(UIActivityViewControllerCompletionWithItemsHandler)completion source:(id)source {
	if (!items.count)
		return Nil;

	UIActivityViewController *activity = [UIActivityViewController createWithActivityItems:items andExcludedTypes:types completion:completion];

	[self popoverViewController:activity from:source];

	return activity;
}

- (UIActivityViewController *)presentActivityWithItems:(NSArray *)items andExcludedTypes:(NSArray *)types completion:(UIActivityViewControllerCompletionWithItemsHandler)completion sourceView:(UIView *)view {
	return [self presentActivityWithItems:items andExcludedTypes:types completion:completion source:view];
}

- (UIActivityViewController *)presentActivityWithItems:(NSArray *)items andExcludedTypes:(NSArray *)types completion:(UIActivityViewControllerCompletionWithItemsHandler)completion sourceBarButton:(UIBarButtonItem *)button {
	return [self presentActivityWithItems:items andExcludedTypes:types completion:completion source:button];
}

- (UIActivityViewController *)presentWebActivityWithItems:(NSArray *)items andExcludedTypes:(NSArray *)types completion:(UIActivityViewControllerCompletionWithItemsHandler)completion source:(id)source {
	if (!items.count)
		return Nil;

	UIActivityViewController *activity = [UIActivityViewController createWebActivityWithItems:items andExcludedTypes:types completion:completion];

	[self popoverViewController:activity from:source];

	return activity;
}

- (UIActivityViewController *)presentWebActivityWithItems:(NSArray *)items andExcludedTypes:(NSArray *)types completion:(UIActivityViewControllerCompletionWithItemsHandler)completion sourceView:(UIView *)view {
	return [self presentWebActivityWithItems:items andExcludedTypes:types completion:completion source:view];
}

- (UIActivityViewController *)presentWebActivityWithItems:(NSArray *)items andExcludedTypes:(NSArray *)types completion:(UIActivityViewControllerCompletionWithItemsHandler)completion sourceBarButton:(UIBarButtonItem *)button {
	return [self presentWebActivityWithItems:items andExcludedTypes:types completion:completion source:button];
}

- (UIActivityViewController *)presentWebActivityWithItems:(NSArray *)items andExcludedTypes:(NSArray *)types completion:(UIActivityViewControllerCompletionWithItemsHandler)completion {
	return [self presentWebActivityWithItems:items andExcludedTypes:types completion:completion sourceView:Nil];
}

- (UIActivityViewController *)presentWebActivityWithItems:(NSArray *)items completion:(UIActivityViewControllerCompletionWithItemsHandler)completion {
	return [self presentWebActivityWithItems:items andExcludedTypes:Nil completion:completion sourceView:Nil];
}

- (UIActivityViewController *)presentWebActivityWithItems:(NSArray *)items {
	return [self presentWebActivityWithItems:items andExcludedTypes:Nil completion:Nil sourceView:Nil];
}

@end
