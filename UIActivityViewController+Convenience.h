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

@interface UIActivityViewController (Convenience)

+ (instancetype)activityWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray<__kindof UIActivity *> *)applicationActivities excludedActivityTypes:(NSArray<UIActivityType> *)excludedActivityTypes completionHandler:(UIActivityViewControllerCompletionWithItemsHandler)completionHandler;

+ (instancetype)webActivityWithActivityItems:(NSArray *)activityItems excludedActivityTypes:(NSArray<UIActivityType> *)excludedActivityTypes completionHandler:(UIActivityViewControllerCompletionWithItemsHandler)completionHandler;

@end

@interface UIViewController (Activity)

- (UIActivityViewController *)presentActivityWithActivityItems:(NSArray *)items applicationActivities:(NSArray<__kindof UIActivity *> *)activities completionHandler:(UIActivityViewControllerCompletionWithItemsHandler)handler sourceView:(UIView *)view;
- (UIActivityViewController *)presentActivityWithActivityItems:(NSArray *)items applicationActivities:(NSArray<__kindof UIActivity *> *)activities completionHandler:(UIActivityViewControllerCompletionWithItemsHandler)handler sourceBarButton:(UIBarButtonItem *)button;
- (UIActivityViewController *)presentActivityWithActivityItems:(NSArray *)items applicationActivities:(NSArray<__kindof UIActivity *> *)activities completionHandler:(UIActivityViewControllerCompletionWithItemsHandler)handler;
- (UIActivityViewController *)presentActivityWithActivityItems:(NSArray *)items;


- (UIActivityViewController *)presentWebActivityWithActivityItems:(NSArray *)items excludedTypes:(NSArray *)types completionHandler:(UIActivityViewControllerCompletionWithItemsHandler)handler sourceView:(UIView *)view;
- (UIActivityViewController *)presentWebActivityWithActivityItems:(NSArray *)items excludedTypes:(NSArray *)types completionHandler:(UIActivityViewControllerCompletionWithItemsHandler)handler sourceBarButton:(UIBarButtonItem *)button;
- (UIActivityViewController *)presentWebActivityWithActivityItems:(NSArray *)items excludedTypes:(NSArray *)types completionHandler:(UIActivityViewControllerCompletionWithItemsHandler)handler;
- (UIActivityViewController *)presentWebActivityWithActivityItems:(NSArray *)items;

@end
