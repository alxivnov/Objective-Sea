//
//  UIImageViewWithHit.m
//  Done!
//
//  Created by Alexander Ivanov on 27.06.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "UIImageViewWithMinHitSize.h"

#define MIN_SIZE 44.0
#define ZERO 0.0

@implementation UIImageViewWithMinHitSize

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
	CGFloat dx = self.bounds.size.width < MIN_SIZE ? self.bounds.size.width - MIN_SIZE : ZERO;
	CGFloat dy = self.bounds.size.height < MIN_SIZE ? self.bounds.size.height - MIN_SIZE : ZERO;
	
	if (dx >= ZERO && dy >= ZERO)
		[super pointInside:point withEvent:event];
	
	CGRect bounds = self.bounds;
	CGRectInset(bounds, dx, dy);
	return CGRectContainsPoint(bounds, point);
}

@end
