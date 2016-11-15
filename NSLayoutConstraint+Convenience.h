//
//  NSLayoutConstraint+Convenience.h
//  Sleep Diary
//
//  Created by Alexander Ivanov on 14.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Constraints)

- (void)equal:(NSLayoutAttribute)selfAttribute view:(UIView *)view attribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant;
- (void)equal:(NSLayoutAttribute)selfAttribute view:(UIView *)view attribute:(NSLayoutAttribute)attribute;
- (void)equal:(NSLayoutAttribute)selfAttribute view:(UIView *)view;

- (void)equalSize:(UIView *)view;

- (void)equalCenter:(UIView *)view constant:(CGPoint)constant;
- (void)equalCenter:(UIView *)view;

@end
