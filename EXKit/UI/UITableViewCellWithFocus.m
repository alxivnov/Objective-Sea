//
//  UITableViewCellWithFocus.m
//  Done!
//
//  Created by Alexander Ivanov on 12.06.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "UITableViewCellWithFocus.h"

@implementation UITableViewCellWithFocus

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
	if (self)
        _focus = FOCUS_MAX;
    
	return self;
}

- (void)awakeFromNib {
    _focus = FOCUS_MAX;
}

- (void)setFocus:(NSUInteger)focus {
	if (focus > FOCUS_MAX)
		focus = FOCUS_MAX;
	
	if (_focus == focus)
		return;
	
	CGFloat alpha = focus == 0 ? 1.0f : focus == FOCUS_MAX ? 0.0f : ((CGFloat)FOCUS_MAX - focus) / (CGFloat)FOCUS_MAX;
	
	self.textLabel.alpha = alpha;
	self.detailTextLabel.alpha = alpha;
	self.imageView.alpha = alpha;
}

@end
