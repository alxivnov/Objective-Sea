//
//  UIViewController+Background.m
//  Done!
//
//  Created by Alexander Ivanov on 30.05.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "UIViewController+Background.h"

@implementation UIViewController (Background)

- (void)setBackgroundView:(UIView *)backgroundView {
	if ([self.view isKindOfClass:[UITableView class]])
		((UITableView *)self.view).backgroundView = backgroundView;
	else
		[self.view insertSubview:backgroundView atIndex:0];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
	UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
	backgroundView.image = backgroundImage;
	[self setBackgroundView:backgroundView];
}

@end
