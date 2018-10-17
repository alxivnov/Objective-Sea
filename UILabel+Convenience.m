//
//  UILabel+Convenience.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 19.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UILabel+Convenience.h"

@implementation UILabel (Convenience)

- (void)autoWidth {
	CGSize size = [self.attributedText size];

	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, self.frame.size.height);
}

- (void)autoHeight {
	CGSize size = [self.attributedText size];

	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, size.height);
}

- (BOOL)autoSize:(CGSize)plus {
	CGSize size = [self.attributedText size];
	size = CGSizeMake(size.width + plus.width, size.height + plus.height);
	size = CGSizeApplyAffineTransform(size, self.transform);

	if (self.superview.bounds.size.height < size.height)
		size.height = self.superview.bounds.size.height;
	if (self.superview.bounds.size.width < size.width)
		size.width = self.superview.bounds.size.width;

	if (CGSizeEqualToSize(self.frame.size, size))
		return NO;

	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, self.numberOfLines > 1 ? size.height * self.numberOfLines + 1.0 * (self.numberOfLines - 1) : size.height);

	return YES;
}

- (BOOL)autoSize {
	return [self autoSize:CGSizeMake(0.0, 0.0)];
}

- (UIFont *)systemFont {
	return [UIFont systemFontOfSize:self.font.pointSize];
}

- (UIFont *)boldSystemFont {
	return [UIFont boldSystemFontOfSize:self.font.pointSize];
}

- (UIFont *)italicSystemFont {
	return [UIFont italicSystemFontOfSize:self.font.pointSize];
}

@end

@implementation NSAttributedString (UILabel)

- (UILabel *)labelWithSize:(CGSize)size options:(NSSizeOptions)flag {
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];

	label.attributedText = self;

	//	label.text = self.string;
	CGSize autoSize = [label.attributedText size];
	//	label.attributedText = self;
	if (size.width <= 0.0 || (flag == NSSizeLessThan && size.width > autoSize.width) || (flag == NSSizeGreaterThan && size.width < autoSize.width))
		size.width = autoSize.width;
	if (size.height <= 0.0 || (flag == NSSizeLessThan && size.height > autoSize.height) || (flag == NSSizeGreaterThan && size.height < autoSize.height))
		size.height = autoSize.height;
	label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, size.width, size.height);

	label.lineBreakMode = NSLineBreakByClipping;

	//	[label autoSize];

	return label;
}

- (UILabel *)labelWithSize:(CGSize)size {
	return [self labelWithSize:size options:NSSizeExact];
}

- (UILabel *)label {
	return [self labelWithSize:CGSizeZero options:NSSizeExact];
}

@end

@implementation NSString (UILabel)

- (UILabel *)labelWithSize:(CGSize)size options:(NSSizeOptions)flag attributes:(NSDictionary<NSString *, id> *)attributes {
	return [[[NSAttributedString alloc] initWithString:self attributes:attributes] labelWithSize:size options:flag];
}

- (UILabel *)labelWithSize:(CGSize)size options:(NSSizeOptions)flag {
	return [self labelWithSize:size options:flag attributes:Nil];
}

- (UILabel *)labelWithSize:(CGSize)size {
	return [self labelWithSize:size options:NSSizeExact attributes:Nil];
}

- (UILabel *)label {
	return [self labelWithSize:CGSizeZero options:NSSizeExact attributes:Nil];
}

@end
