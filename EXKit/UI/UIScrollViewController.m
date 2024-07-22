//
//  UIScrollViewController.m
//  Done!
//
//  Created by Alexander Ivanov on 09.01.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "UIScrollViewController.h"
#import "Constants.h"
#import "UIView+Convenience.h"
#import "UIViewController+Convenience.h"

@implementation UIScrollViewController

- (void)setStatusBarHidden:(BOOL)statusBarHidden {
	if (_statusBarHidden == statusBarHidden)
		return;
	
	_statusBarHidden = statusBarHidden;

	[UIView animateWithDuration:ANIMATION_DURATION / 8 delay:0.0 usingSpringWithDamping:ANIMATION_DAMPING initialSpringVelocity:ANIMATION_VELOCITY options:UIViewAnimationOptionCurveEaseIn animations:^{
		[self setNeedsStatusBarAppearanceUpdate];
	} completion:Nil];
}

- (BOOL)prefersStatusBarHidden {
	return self.statusBarHidden;
}

- (BOOL)modalPresentationCapturesStatusBarAppearance {
	return YES;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
	return UIStatusBarAnimationSlide;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if ([UIViewController isCallingStatusBar])
		return;
	
	self.statusBarHidden = ([self hideStatusBarOnScrollUp] && scrollView.contentOffset.y > 0) || ([self hideStatusBarOnScrollDown] && scrollView.contentOffset.y < -scrollView.contentInset.top);
}

- (BOOL)hideStatusBarOnScrollDown {
	return NO;
}

- (BOOL)hideStatusBarOnScrollUp {
	return YES;
}

- (CGFloat)topInset {
	return GUI_STATUS_BAR_HEIGHT;
/*
	if (self.statusBarHidden)
		return 0.0;
	
	CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarHeight;
	return statusBarHeight ? statusBarHeight : GUI_STATUS_BAR_HEIGHT;
*/
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.tableView.contentInset = UIEdgeInsetsMake([self topInset], self.tableView.contentInset.left, self.tableView.contentInset.bottom, self.tableView.contentInset.right);
}

@end
