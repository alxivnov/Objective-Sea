//
//  UIAlertViewEx.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 22.06.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSArray+Convenience.h"
#import "NSObject+Convenience.h"

#import "UIView+Convenience.h"

@interface UIAlertViewEx : UIAlertView <UIAlertViewDelegate>

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles completion:(void(^)(UIAlertView *, NSInteger))completion;

@end
