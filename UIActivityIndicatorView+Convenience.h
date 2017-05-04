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

- (UIView *)startActivityIndication:(UIActivityIndicatorViewStyle)style message:(NSString *)message;
- (UIView *)startActivityIndication:(UIActivityIndicatorViewStyle)style;
- (UIView *)startActivityIndication;

- (void)stopActivityIndication:(void (^)())completion;
- (void)stopActivityIndication;

@end

@interface UIViewController (UIActivityIndicatorView)

- (UIView *)startActivityIndication:(UIActivityIndicatorViewStyle)style message:(NSString *)message;
- (UIView *)startActivityIndication:(UIActivityIndicatorViewStyle)style;
- (UIView *)startActivityIndication;

- (void)stopActivityIndication:(void (^)())completion;
- (void)stopActivityIndication;

@end
