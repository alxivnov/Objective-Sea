//
//  UIDetailTableViewCell.m
//  Ringo
//
//  Created by Alexander Ivanov on 07.09.15.
//  Copyright (c) 2015 Alexander Ivanov. All rights reserved.
//

#import "UIDetailTableViewCell.h"

@implementation UIDetailTableViewCell

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGFloat detailTextLabelWidth = round([self.detailTextLabel.attributedText size].width);
	
	if (self.detailTextLabel.frame.size.width < detailTextLabelWidth) {
		self.detailTextLabel.frame = CGRectMake(self.bounds.size.width - self.accessoryView.frame.size.width - detailTextLabelWidth - 16.0, self.detailTextLabel.frame.origin.y, detailTextLabelWidth, self.detailTextLabel.frame.size.height);
		
		self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x, self.detailTextLabel.frame.origin.y, self.detailTextLabel.frame.origin.x - self.textLabel.frame.origin.x, self.textLabel.frame.size.height);
	}
}

@end
