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

	CGFloat imageInset = titleSize.height + fabs(padding) / 2.0;
	self.imageEdgeInsets = UIEdgeInsetsMake(padding > 0.0 ? -imageInset : imageInset, 0.0, 0.0, -titleSize.width);
	CGFloat titleInset = imageSize.height + fabs(padding) / 2.0;
	self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, padding > 0.0 ? -titleInset : titleInset, 0.0);
}

@end

@interface UIBorderButton ()
@property (assign, nonatomic) BOOL touch;
@end

@implementation UIBorderButton

- (void)setTouch:(BOOL)touch {
	if (_touch == touch)
		return;

	_touch = touch;

	if (touch) {
		[self setTitleColor:[self rootBackgroundColor] forState:UIControlStateNormal];
		super.backgroundColor = self.tintColor;
	} else {
		super.backgroundColor = self.titleLabel.textColor;
		[self setTitleColor:self.tintColor forState:UIControlStateNormal];
	}
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
	if (self.touch)
		[self setTitleColor:backgroundColor forState:UIControlStateNormal];
	else
		[super setBackgroundColor:backgroundColor];
}

- (void)setTintColor:(UIColor *)tintColor {
	[super setTintColor:tintColor];

	if (self.touch)
		self.backgroundColor = tintColor;
	else
		[self setTitleColor:tintColor forState:UIControlStateNormal];

	[self.layer setBorderWidth:2.0 color:self.tintColor.CGColor];
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	if (self) {
		[self.layer setBorderWidth:2.0 color:self.tintColor.CGColor];
		[self.layer roundCorners:8.0];

		[self setTitleColor:self.tintColor forState:UIControlStateNormal];

		[self addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
		[self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
		[self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchDragOutside];
	}

	return self;
}

- (IBAction)touchDown:(id)sender {
	self.touch = YES;
}

- (IBAction)touchUp:(id)sender {
	self.touch = NO;
}

@end
