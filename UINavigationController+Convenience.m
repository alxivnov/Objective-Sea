//
//  UINavigationController+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 13.12.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UINavigationController+Convenience.h"

@implementation UINavigationController (Convenience)

- (UIViewController *)pushViewControllerWithIdentifier:(NSString *)identifier animated:(BOOL)animated {
	UIViewController *vc = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:identifier];

	[self pushViewController:vc animated:animated];

	return vc;
}

- (UIViewController *)lowerViewController {
	NSUInteger index = [self.viewControllers first:^BOOL(__kindof UIViewController *obj) {
		return obj == self.topViewController;
	}];

	return idx(self.viewControllers, index - 1);
}

@end

@implementation UINavigationBar (Convenience)

- (UIProgressView *)progressView {
	UIProgressView *progress = [self.subviews firstObject:^BOOL(__kindof UIView *obj) {
		return [obj isKindOfClass:[UIProgressView class]];
	}];

	if (!progress) {
		progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
		progress.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y + self.bounds.size.height - progress.frame.size.height, self.bounds.size.width, progress.frame.size.height);

		[self addSubview:progress];

		[self equal:NSLayoutAttributeBottom view:progress];
		[self equal:NSLayoutAttributeWidth view:progress];
	}

	return progress;
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
	UIProgressView *progressView = self.progressView;
	if (progress <= 0.0)
		[progressView setProgress:0.0 animated:animated];
	else if (progress >= 1.0)
		[progressView setProgress:1.0 animated:animated];
	else
		[progressView setProgress:progress animated:animated];
}

- (void)setProgress:(float)progress {
	[self setProgress:progress animated:NO];
}

- (float)progress {
	return self.progressView.progress;
}

@end
