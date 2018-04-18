//
//  UIButton+Convenience.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 18.04.2018.
//  Copyright © 2018 Alexander Ivanov. All rights reserved.
//

#import "UIButton+Convenience.h"

@implementation UIButton (Convenience)

- (void)setTitle:(NSString *)title {
	[self setTitle:title forState:UIControlStateNormal];
}

- (void)setTitleColor:(UIColor *)color {
	[self setTitleColor:color forState:UIControlStateNormal];
}

- (void)setTitleShadowColor:(UIColor *)color {
	[self setTitleShadowColor:color forState:UIControlStateNormal];
}

- (void)setImage:(UIImage *)image {
	[self setImage:image forState:UIControlStateNormal];
}

- (void)setBackgroundImage:(UIImage *)image {
	[self setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)setAttributedTitle:(NSAttributedString *)title {
	[self setAttributedTitle:title forState:UIControlStateNormal];
}

- (void)layoutVertically:(CGFloat)padding {
	CGSize imageSize = self.imageView.frame.size;
	CGSize titleSize = self.titleLabel.frame.size;

	self.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + padding / 2.0), 0.0, 0.0, -titleSize.width);
	self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + padding / 2.0), 0.0);
}

@end
