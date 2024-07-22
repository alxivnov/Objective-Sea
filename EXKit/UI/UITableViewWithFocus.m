//
//  UITableView+Focus.m
//  Done!
//
//  Created by Alexander Ivanov on 14.11.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "UIView+Convenience.h"
#import "UITableViewCell+Focus.h"
#import "UITableViewWithFocus.h"

@interface UITableViewWithFocus ()
@property (nonatomic, assign, readwrite) CGFloat focusValue;
@property (strong, nonatomic, readwrite) NSArray *cellsInFocus;

@property (nonatomic, assign, readwrite) BOOL isAnimating;
@end

@implementation UITableViewWithFocus

@dynamic delegate;

- (BOOL)isFocused {
	return self.maxFocusValue - self.focusValue < 0.01;
}

- (BOOL)isFocusing {
	return !self.isFocused && !self.isUnfocused;
}

- (BOOL)isUnfocused {
	return self.minFocusValue - self.focusValue > -0.01;
}

- (void)applyFocus {
	for (UITableViewCell *cell in self.visibleCells)
		[cell setFocus:[self.cellsInFocus containsObject:cell] ? self.minFocusValue : self.focusValue];
}

- (void)setFocus:(CGFloat)value forCells:(NSArray *)cells withDuration:(NSTimeInterval)duration {
	value = fmaxf(value, self.minFocusValue);
	value = fminf(value, self.maxFocusValue);
	
	if (self.focusValue == value && [self.cellsInFocus isEqualToArray:cells])
		return;
	
	self.focusValue = value;
	self.cellsInFocus = cells;
	
	if (duration > 0.0)
		[UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:ANIMATION_DAMPING initialSpringVelocity:ANIMATION_VELOCITY options:UIViewAnimationOptionCurveEaseIn animations:^{
			self.isAnimating = YES;
			
			[self applyFocus];
		} completion:^(BOOL finished) {
			self.isAnimating = NO;
		}];
	else
		[self applyFocus];
	
	if ([self.delegate respondsToSelector:@selector(tableView:didFocus:)])
		[self.delegate tableView:self didFocus:self.focusValue];
}

- (void)refocusOnCells:(NSArray *)cells withDuration:(NSTimeInterval)duration {
	[self setFocus:self.focusValue forCells:cells withDuration:duration];
}

- (void)focusOnCells:(NSArray *)cells withDuration:(NSTimeInterval)duration {
	[self setFocus:FOCUS_MAX forCells:cells withDuration:duration];
}

- (void)defocusWithDuration:(NSTimeInterval)duration {
	[self setFocus:FOCUS_MIN forCells:self.cellsInFocus withDuration:duration];
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [super dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
	
	[cell setFocus:self.focusValue];
	
	return cell;
}

@end
