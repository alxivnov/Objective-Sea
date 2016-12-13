//
//  UINavigationController+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 13.12.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSArray+Convenience.h"
#import "NSLayoutConstraint+Convenience.h"
#import "UIViewController+Convenience.h"

@interface UINavigationController (Convenience)

- (UIViewController *)pushViewControllerWithIdentifier:(NSString *)identifier animated:(BOOL)animated;

@property (strong, nonatomic, readonly) UIViewController *lowerViewController;

@end

@interface UINavigationBar (Convenience)

@property (strong, nonatomic, readonly) UIProgressView *progressView;
@property (assign, nonatomic) float progress;

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
