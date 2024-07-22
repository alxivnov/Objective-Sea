//
//  UIReviewController.h
//  Sleep Diary
//
//  Created by Alexander Ivanov on 08/09/16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSRateController.h"

#import "Affiliates+Convenience.h"
#import "MessageUI+Convenience.h"
#import "NSBundle+Convenience.h"
#import "NSObject+Convenience.h"
#import "UIApplication+Convenience.h"
#import "UIButton+Convenience.h"

@interface UIRateView : UIView

@property (strong, nonatomic, readonly) UILabel *label;
@property (strong, nonatomic, readonly) UIButton *leftButton;
@property (strong, nonatomic, readonly) UIButton *rightButton;

@end

@interface UIRateController : UIViewController

@property (copy, nonatomic) void (^buttonAction)(NSRateControllerState state);

+ (instancetype)instance;

@end
