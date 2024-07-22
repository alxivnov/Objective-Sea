//
//  UITableViewCell+Focus.m
//  Done!
//
//  Created by Alexander Ivanov on 12.06.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "UITableViewCell+Focus.h"
#import <tgmath.h>

#define EPSILON 0.05

@implementation UITableViewCell (Focus)

- (void)setFocus:(CGFloat)focus {
	CGFloat alpha = FOCUS_MAX - focus;
	
	if (focus == FOCUS_MAX) {
		if (self.contentView.alpha == FOCUS_MIN)
			return;
	} else if (focus == FOCUS_MIN) {
		if (self.contentView.alpha == FOCUS_MAX)
			return;
	} else {
		if (fabs(self.contentView.alpha - alpha) < EPSILON)
			return;
	}
	
	self.contentView.alpha = alpha;
	/*
	self.textLabel.alpha = alpha;
	self.detailTextLabel.alpha = alpha;
	self.imageView.alpha = alpha;
	*/
}

- (BOOL)isFocused {
	return self.contentView.alpha <= FOCUS_MIN;
}

- (BOOL)isFocusing {
	return self.contentView.alpha > FOCUS_MIN && self.contentView.alpha < FOCUS_MAX;
}

- (BOOL)isUnfocused {
	return self.contentView.alpha >= FOCUS_MAX;
}

@end
