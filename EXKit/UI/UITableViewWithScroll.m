//
//  UITableViewWithScroll.m
//  Done!
//
//  Created by Alexander Ivanov on 16.04.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "UITableViewWithScroll.h"
#import "UITableView+Convenience.h"
#import "UIScrollView+Scroll.h"

@interface UITableViewWithScroll ()
@property (assign, nonatomic) CGFloat scrollOffset;
@end

@implementation UITableViewWithScroll

- (BOOL)isScrolling {
	return self.scrollOffset != 0;
}

- (void)stopScrolling {
	self.scrollOffset = 0;
}

- (void)scrollDown:(id<UITableViewWithScrollDelegate>)delegate {
	if (self.scrollOffset > 0)
		return;
	
	CGFloat oldOffset = self.scrollOffset;
	
	self.scrollOffset = 1;
	
	if (oldOffset == 0)
		[self autoScroll:delegate];
}

- (void)scrollUp:(id<UITableViewWithScrollDelegate>)delegate {
	if (self.scrollOffset < 0)
		return;
	
	CGFloat oldOffset = self.scrollOffset;
	
	self.scrollOffset = -1;
	
	if (oldOffset == 0)
		[self autoScroll:delegate];
}

- (void)autoScroll:(id <UITableViewWithScrollDelegate>)delegate {
	if (self.scrollOffset == 0)
		return;

	if ([self scrollOffsetToVisible:self.scrollOffset animated:NO]) {
		if ([delegate respondsToSelector:@selector(tableView:didScroll:)])
			[delegate tableView:self didScroll:self.scrollOffset];
		
		[self performSelector:@selector(autoScroll:) withObject:delegate afterDelay:0.01];
	}
}

@end
