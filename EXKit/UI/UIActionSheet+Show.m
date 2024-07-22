//
//  UIActionSheet+Show.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 05.09.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "UIActionSheet+Show.h"
#import "UIView+Convenience.h"

@implementation UIActionSheet (Show)

- (void)showFromView:(UIView *)anchor inSuperview:(UIView *)view {
	if (!view)
		view = [anchor rootview];
	
	CGRect rect = [view convertRect:anchor.bounds fromView:anchor];
	
	[self showFromRect:rect inView:view animated:YES];
}

- (void)showFromView:(UIView *)anchor {
	[self showFromView:anchor inSuperview:Nil];
}

@end
