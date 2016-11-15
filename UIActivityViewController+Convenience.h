//
//  UIActivityViewController+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSArray+Convenience.h"
#import "UIActivity+Convenience.h"
#import "UIApplication+Convenience.h"
#import "UIDocumentPickerViewController+Convenience.h"
#import "UIViewController+Convenience.h"

@import Social;

@interface UIActivityViewController (Create)

+ (instancetype)createWithActivityItems:(NSArray *)items andApplicationActivities:(NSArray *)activities completion:(UIActivityViewControllerCompletionWithItemsHandler)completion;
+ (instancetype)createWithActivityItems:(NSArray *)items completion:(UIActivityViewControllerCompletionWithItemsHandler)completion;
+ (instancetype)createWithActivityItems:(NSArray *)items;

+ (instancetype)createWithActivityItems:(NSArray *)items andExcludedTypes:(NSArray *)types completion:(UIActivityViewControllerCompletionWithItemsHandler)completion;

+ (instancetype)createWebActivityWithItems:(NSArray *)items andExcludedTypes:(NSArray *)types completion:(UIActivityViewControllerCompletionWithItemsHandler)completion;
+ (instancetype)createWebActivityWithItems:(NSArray *)items completion:(UIActivityViewControllerCompletionWithItemsHandler)completion;
+ (instancetype)createWebActivityWithItems:(NSArray *)items;

@end

@interface UIViewController (Activity)

- (UIActivityViewController *)presentActivityWithItems:(NSArray *)items applicationActivities:(NSArray *)activities excludedActivityTypes:(NSArray *)types completion:(UIActivityViewControllerCompletionWithItemsHandler)completion source:(id)source;

- (UIActivityViewController *)presentActivityWithItems:(NSArray *)items andApplicationActivities:(NSArray *)activities completion:(UIActivityViewControllerCompletionWithItemsHandler)completion sourceView:(UIView *)view;
- (UIActivityViewController *)presentActivityWithItems:(NSArray *)items andApplicationActivities:(NSArray *)activities completion:(UIActivityViewControllerCompletionWithItemsHandler)completion sourceBarButton:(UIBarButtonItem *)button;
- (UIActivityViewController *)presentActivityWithItems:(NSArray *)items andApplicationActivities:(NSArray *)activities completion:(UIActivityViewControllerCompletionWithItemsHandler)completion;
- (UIActivityViewController *)presentActivityWithItems:(NSArray *)items completion:(UIActivityViewControllerCompletionWithItemsHandler)completion;
- (UIActivityViewController *)presentActivityWithItems:(NSArray *)items;

- (UIActivityViewController *)presentActivityWithItems:(NSArray *)items andExcludedTypes:(NSArray *)types completion:(UIActivityViewControllerCompletionWithItemsHandler)completion sourceView:(UIView *)view;
- (UIActivityViewController *)presentActivityWithItems:(NSArray *)items andExcludedTypes:(NSArray *)types completion:(UIActivityViewControllerCompletionWithItemsHandler)completion sourceBarButton:(UIBarButtonItem *)button;

- (UIActivityViewController *)presentWebActivityWithItems:(NSArray *)items andExcludedTypes:(NSArray *)types completion:(UIActivityViewControllerCompletionWithItemsHandler)completion sourceView:(UIView *)view;
- (UIActivityViewController *)presentWebActivityWithItems:(NSArray *)items andExcludedTypes:(NSArray *)types completion:(UIActivityViewControllerCompletionWithItemsHandler)completion sourceBarButton:(UIBarButtonItem *)button;
- (UIActivityViewController *)presentWebActivityWithItems:(NSArray *)items andExcludedTypes:(NSArray *)types completion:(UIActivityViewControllerCompletionWithItemsHandler)completion;
- (UIActivityViewController *)presentWebActivityWithItems:(NSArray *)items completion:(UIActivityViewControllerCompletionWithItemsHandler)completion;
- (UIActivityViewController *)presentWebActivityWithItems:(NSArray *)items;

@end
