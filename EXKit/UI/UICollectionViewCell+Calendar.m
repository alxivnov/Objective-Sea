//
//  UICollectionViewCell+Calendar.m
//  CollectionView
//
//  Created by Alexander Ivanov on 21.11.14.
//  Copyright (c) 2014 Alexander Ivanov. All rights reserved.
//

#import "UICollectionViewCell+Calendar.h"

#import "UICollectionViewCell+Text.h"
#import "UIFont+Modification.h"
#import "UIView+Convenience.h"
#import "QuartzCore+Convenience.h"

@implementation UICollectionViewCell (Calendar)

- (void)checkWithView:(UIView *)view {
	if (view)
		self.backgroundView = view;
	
	UILabel *label = [self text];
	label.font = [label.font bold];
	label.textColor = [UIColor whiteColor];
}

- (void)check:(UIColor *)color {
	[self checkWithView:[UIView new]];

	self.backgroundView.backgroundColor = color ? color : self.tintColor;
	self.backgroundView.frame = CGRectInset(self.backgroundView.frame, 5.0, 5.0);
	[self.backgroundView.layer roundCornersWithRatio:1.0];
}

- (void)check {
	[self check:Nil];
}

- (void)uncheck {
	self.backgroundView = Nil;
	
	UILabel *label = [self text];
	label.font = [label.font original];
	label.textColor = [UIColor darkTextColor];
}

- (BOOL)isChecked {
	return self.backgroundView ? YES : NO;
}

@end
