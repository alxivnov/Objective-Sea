//
//  UITextField+Placeholder.m
//  Guardian
//
//  Created by Alexander Ivanov on 20.02.15.
//  Copyright (c) 2015 NATEK. All rights reserved.
//

#import "UITextField+Placeholder.h"

@implementation UITextField (Placeholder)

- (void)setPlaceholderColor:(UIColor *)color {
	self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{ NSForegroundColorAttributeName : color }];
}

@end
