//
//  UITableView+Convenience.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 20.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UITableView+Convenience.h"

@implementation UIContextualAction (Convenience)

+ (instancetype)contextualActionWithStyle:(UIContextualActionStyle)style title:(NSString *)title image:(UIImage *)image color:(UIColor *)color handler:(UIContextualActionHandler)handler {
	UIContextualAction *action = [UIContextualAction contextualActionWithStyle:style title:title handler:handler];
	if (image)
		action.image = image;
	if (color)
		action.backgroundColor = color;
	return action;
}

@end

@implementation NSIndexPath (Convenience)

- (BOOL)isEqualToIndexPath:(NSIndexPath *)indexPath {
	return [indexPath isKindOfClass:[NSIndexPath class]] && [self compare:indexPath] == NSOrderedSame;
}

- (BOOL)isEqualToSection:(NSUInteger)section row:(NSUInteger)row {
	return [self indexAtPosition:0] == section && [self indexAtPosition:1] == row;
}

@end

@implementation UITableView (Convenience)

//static UIEdgeInsets inset;

- (void)setEmptyState:(UIView *)emptyState {
//	if (UIEdgeInsetsEqualToEdgeInsets(inset, UIEdgeInsetsZero))
//		inset = self.separatorInset;

	if (emptyState) {
		self.backgroundView = emptyState;
		if (self.style == UITableViewStylePlain)
			self.separatorStyle = UITableViewCellSeparatorStyleNone;
//			self.separatorInset = UIEdgeInsetsMake(0.0, fmax(self.bounds.size.height, self.bounds.size.width), 0.0, 0.0);
	} else {
		self.backgroundView = Nil;
		if (self.style == UITableViewStylePlain)
			self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//			self.separatorInset = inset;	// UIEdgeInsetsZero;
	}
}

- (UIView *)emptyState {
	return self.backgroundView;
}

- (BOOL)scrollOffsetToVisible:(CGFloat)offset animated:(BOOL)animated {
	if (offset < 0.0) {
		CGFloat y = self.contentInset.top + self.contentOffset.y + offset;
		if (y > 0.0) {
			[self scrollRectToVisible:CGRectMake(0.0, y, 1.0, 1.0) animated:animated];

			return YES;
		}
	} else if (offset > 0.0) {
		CGFloat y = self.bounds.size.height + self.contentOffset.y;
		if (y < self.contentSize.height) {
			[self scrollRectToVisible:CGRectMake(0.0, y, 1.0, offset) animated:animated];

			return YES;
		}
	}

	return NO;
}

@end

@implementation UITableView (Sections)

- (void)insertSectionsInRange:(NSRange)range {
	[self insertSections:[NSIndexSet indexSetWithIndexesInRange:range] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)insertSection:(NSUInteger)section {
	[self insertSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)deleteSectionsInRange:(NSRange)range {
	[self deleteSections:[NSIndexSet indexSetWithIndexesInRange:range] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)deleteSection:(NSUInteger)section {
	[self deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadSectionsInRange:(NSRange)range {
	[self reloadSections:[NSIndexSet indexSetWithIndexesInRange:range] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadSection:(NSUInteger)section {
	[self reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)setHeaderText:(NSString *)text forSection:(NSUInteger)section {
	UITableViewHeaderFooterView *view = [self headerViewForSection:section];
	view.textLabel.text = text;
	[view setNeedsLayout];
}

- (void)setFooterText:(NSString *)text forSection:(NSUInteger)section {
	UITableViewHeaderFooterView *view = [self footerViewForSection:section];
	view.textLabel.text = text;
	[view setNeedsLayout];
}

- (NSUInteger)firstSection {
	return self.numberOfSections ? 0 : NSNotFound;
}

- (NSUInteger)lastSection {
	return self.numberOfSections ? self.numberOfSections - 1 : NSNotFound;
}

@end

@implementation UITableView (Rows)

- (void)deselectRows:(BOOL)animated; {
	[self selectRowAtIndexPath:Nil animated:animated scrollPosition:UITableViewScrollPositionNone];
}

- (void)insertRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath)
		[self insertRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath)
		[self deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath)
		[self reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath inReverse:(BOOL)reverse {
	if (reverse) {
		[self beginUpdates];

		for (NSUInteger index = indexPath.row; index != newIndexPath.row; ) {
			NSUInteger temp = indexPath.row < newIndexPath.row ? index + 1 : index - 1;

			[self moveRowAtIndexPath:[NSIndexPath indexPathForRow:temp inSection:0] toIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];

			index = temp;
		}

		[self endUpdates];
	} else {
		[self moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
	}
}

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath {
	[self scrollToRowAtIndexPath:indexPath atScrollPosition:[self.indexPathsForVisibleRows.firstObject compare:indexPath] == NSOrderedDescending ? UITableViewScrollPositionTop : [self.indexPathsForVisibleRows.lastObject compare:indexPath] == NSOrderedAscending ? UITableViewScrollPositionBottom : UITableViewScrollPositionNone animated:YES];
}

- (NSIndexPath *)indexPathForNullableCell:(UITableViewCell *)cell {
	return cell ? [self indexPathForCell:cell] : Nil;
}

@end

@implementation UITableViewController (Convenience)

- (void)addRefreshTarget:(id)target action:(SEL)action {
	self.refreshControl = [[UIRefreshControl alloc] init];
	self.refreshControl.tintColor = self.navigationController.navigationBar.barStyle == UIBarStyleDefault ? [UIColor darkGrayColor] : [UIColor lightGrayColor];
	[self.refreshControl addTarget:target action:action forControlEvents:UIControlEventValueChanged];
}

@end
