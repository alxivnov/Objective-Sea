//
//  UIViewController+Answers.h
//  Sleep Diary
//
//  Created by Alexander Ivanov on 16.03.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Answers)

- (NSString *)loggingName;
- (NSDictionary<NSString *, id> *)loggingCustomAttributes;
- (void)startLogging;
- (void)endLogging;

@end
