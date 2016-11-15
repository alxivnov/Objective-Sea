//
//  UIActivityIndicatorView+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSLayoutConstraint+Convenience.h"
#import "UIView+Convenience.h"
#import "UIViewController+Convenience.h"

@interface UIView (UIActivityIndicatorView)

- (void)startActivityIndication:(UIActivityIndicatorViewStyle)style message:(NSString *)message;
- (void)startActivityIndication:(UIActivityIndicatorViewStyle)style;
- (void)startActivityIndication;

- (void)stopActivityIndication:(void (^)())completion;
- (void)stopActivityIndication;

@end

@interface UIViewController (UIActivityIndicatorView)

- (void)startActivityIndication:(UIActivityIndicatorViewStyle)style message:(NSString *)message;
- (void)startActivityIndication:(UIActivityIndicatorViewStyle)style;
- (void)startActivityIndication;

- (void)stopActivityIndication:(void (^)())completion;
- (void)stopActivityIndication;

@end
