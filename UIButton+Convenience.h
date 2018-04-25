//
//  UIButton+Convenience.h
//  Sleep Diary
//
//  Created by Alexander Ivanov on 18.04.2018.
//  Copyright © 2018 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QuartzCore+Convenience.h"
#import "UIView+Convenience.h"

@interface UIButton (Convenience)

- (void)setTitle:(NSString *)title;
- (void)setTitleColor:(UIColor *)color;
- (void)setTitleShadowColor:(UIColor *)color;
- (void)setImage:(UIImage *)image;
- (void)setBackgroundImage:(UIImage *)image;
- (void)setAttributedTitle:(NSAttributedString *)title;

- (void)layoutVertically:(CGFloat)padding;

@end

@interface UIBorderButton : UIButton

@end
