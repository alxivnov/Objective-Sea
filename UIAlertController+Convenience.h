//
//  UIAlertController+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 16.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewController+Convenience.h"

#define UIAlertActionCancel NSIntegerMax
#define UIAlertActionDestructive NSIntegerMin

@interface UIAlertController (Convenience)

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle cancelActionTitle:(NSString *)cancelActionTitle destructiveActionTitle:(NSString *)destructiveActionTitle otherActionTitles:(NSArray *)otherActionTitles completion:(void (^)(UIAlertController *instance, NSInteger index))completion;

+ (instancetype)sheetWithTitle:(NSString *)title message:(NSString *)message cancelActionTitle:(NSString *)cancelActionTitle destructiveActionTitle:(NSString *)destructiveActionTitle otherActionTitles:(NSArray *)otherActionTitles completion:(void (^)(UIAlertController *instance, NSInteger index))completion;

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message cancelActionTitle:(NSString *)cancelActionTitle destructiveActionTitle:(NSString *)destructiveActionTitle otherActionTitles:(NSArray *)otherActionTitles completion:(void (^)(UIAlertController *instance, NSInteger index))completion;

@end

@interface UIViewController (UIAlertController)

- (UIAlertController *)presentAlertWithTitle:(NSString *)title message:(NSString *)message cancelActionTitle:(NSString *)cancelActionTitle destructiveActionTitle:(NSString *)destructiveActionTitle otherActionTitles:(NSArray *)otherActionTitles completion:(void (^)(UIAlertController *instance, NSInteger index))completion;
- (UIAlertController *)presentAlertWithTitle:(NSString *)title cancelActionTitle:(NSString *)cancelActionTitle;
- (UIAlertController *)presentAlertWithError:(NSError *)error cancelActionTitle:(NSString *)cancelActionTitle;

- (UIAlertController *)presentSheetWithTitle:(NSString *)title message:(NSString *)message cancelActionTitle:(NSString *)cancelActionTitle destructiveActionTitle:(NSString *)destructiveActionTitle otherActionTitles:(NSArray *)otherActionTitles from:(id)from completion:(void (^)(UIAlertController *instance, NSInteger index))completion;
- (UIAlertController *)presentSheetWithTitle:(NSString *)title cancelActionTitle:(NSString *)cancelActionTitle from:(id)from;
- (UIAlertController *)presentSheetWithError:(NSError *)error cancelActionTitle:(NSString *)cancelActionTitle from:(id)from;

@end
