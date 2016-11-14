//
//  UIViewController+Convenience.h
//  Crowd Guard
//
//  Created by Alexander Ivanov on 13.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIViewControllerNextTarget(break) ^id(id target, BOOL responds, id returnValue) { return break && responds ? Nil : [target nextViewController]; }

@interface UIViewController (Convenience)

@property (strong, nonatomic, readonly) __kindof UIViewController *previousViewController;
@property (strong, nonatomic, readonly) __kindof UIViewController *firstViewController;

@property (strong, nonatomic, readonly) __kindof UIViewController *nextViewController;
@property (strong, nonatomic, readonly) __kindof UIViewController *lastViewController;

- (__kindof UIViewController *)presentRootViewControllerAnimated:(BOOL)animated;
- (__kindof UIViewController *)presentRootViewController;

- (void)setToolbar;
- (void)setToolbar:(NSArray<UIBarButtonItem *> *)toolbarItems animated:(BOOL)animated;
- (void)setToolbar:(NSArray<UIBarButtonItem *> *)toolbarItems;

@end
