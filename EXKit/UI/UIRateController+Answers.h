//
//  UIRateController+Answers.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 23.05.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UIRateController.h"

@interface UIRateController (Answers)

+ (void)logRateWithMethod:(NSString *)method success:(BOOL)success;

- (void)setupLogging:(void(^)(NSRateControllerState state))buttonAction;
- (void)setupLogging;

@end
