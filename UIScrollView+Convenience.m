//
//  UIScrollView+Convenience.m
//  Poisk
//
//  Created by Alexander Ivanov on 15.06.17.
//  Copyright © 2017 Pine 9. All rights reserved.
//

#import "UIScrollView+Convenience.h"

@implementation UIScrollView (Convenience)

- (CGFloat)fillZoom {
	return fmax(self.bounds.size.width / self.contentSize.width, self.bounds.size.height / self.contentSize.height);
}

- (CGFloat)fitZoom {
	return fmin(self.bounds.size.width / self.contentSize.width, self.bounds.size.height / self.contentSize.height);
}

- (void)setContentView:(UIView *)contentView {
	UIView *view = [self viewWithTag:UICenteredScrollViewTag];
	if (view == contentView)
		return;

	[view removeFromSuperview];

	if (contentView == Nil)
		return;

	contentView.tag = UICenteredScrollViewTag;
	self.contentSize = contentView.frame.size;
	[self addSubview:contentView];
}

- (UIView *)contentView {
	return [self viewWithTag:UICenteredScrollViewTag];
}

@end

@implementation UICenteredScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews {
	[super layoutSubviews];

	[self viewWithTag:UICenteredScrollViewTag].frame = CGRectMake(self.contentSize.width < self.bounds.size.width ? (self.bounds.size.width - self.contentSize.width) / 2.0 : 0.0, self.contentSize.height < self.bounds.size.height ? (self.bounds.size.height - self.contentSize.height) / 2.0 - self.contentInset.top : 0.0, self.contentSize.width, self.contentSize.height);
}

@end
