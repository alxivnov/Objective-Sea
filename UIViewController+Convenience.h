//
//  UIViewController+Convenience.h
//  Crowd Guard
//
//  Created by Alexander Ivanov on 13.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSObject+Convenience.h"

#define GUI_MARGIN_COMPACT 16.0
#define GUI_MARGIN_REGULAR 20.0

#define GUI_STATUS_BAR_HEIGHT 20.0

#define UIViewControllerNextTarget(break) ^id(id __target, BOOL __responds, id __returnValue) { return break && __responds ? Nil : [__target nextViewController]; }

@interface UIViewController (Convenience)

@property (assign, nonatomic, readonly) BOOL iPad;
@property (assign, nonatomic, readonly) BOOL iPhone;

//@property (strong, nonatomic, readonly) __kindof UIViewController *prevViewController;
@property (strong, nonatomic, readonly) __kindof UIViewController *containingViewController;

@property (strong, nonatomic, readonly) __kindof UIViewController *nextViewController;
@property (strong, nonatomic, readonly) __kindof UIViewController *lastViewController;

- (__kindof UIViewController *)presentRootViewControllerAnimated:(BOOL)animated;
- (__kindof UIViewController *)presentRootViewController;

- (void)setToolbar;
- (void)setToolbar:(NSArray<UIBarButtonItem *> *)toolbarItems animated:(BOOL)animated;
- (void)setToolbar:(NSArray<UIBarButtonItem *> *)toolbarItems;

+ (CGFloat)statusBarHeight;
+ (BOOL)inCallingStatusBar;

@end

@interface UIViewController (UIPopoverPresentationController)

- (BOOL)popoverViewController:(UIViewController *)vc from:(id)source;
- (BOOL)popoverViewController:(UIViewController *)vc fromView:(UIView *)view;
- (BOOL)popoverViewController:(UIViewController *)vc fromButton:(UIBarButtonItem *)button;
- (BOOL)popoverViewController:(UIViewController *)vc completion:(void(^)(UIViewController *vc))completion;
- (BOOL)popoverViewController:(UIViewController *)vc;

- (UIViewController *)popoverViewControllerWithIdentifier:(NSString *)identifier from:(id)source;
- (UIViewController *)popoverViewControllerWithIdentifier:(NSString *)identifier fromView:(UIView *)view;
- (UIViewController *)popoverViewControllerWithIdentifier:(NSString *)identifier fromButton:(UIBarButtonItem *)button;
- (UIViewController *)popoverViewControllerWithIdentifier:(NSString *)identifier completion:(void(^)(UIViewController *vc))completion;
- (UIViewController *)popoverViewControllerWithIdentifier:(NSString *)identifier;

@end

@interface UIStoryboard (Convenience)

+ (UIStoryboard *)mainStoryboard;

@end