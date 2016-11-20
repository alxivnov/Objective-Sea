//
//  UITableView+Convenience.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 20.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UITableView+Convenience.h"

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

@implementation UITableViewCell (Convenience)

- (UITableView *)tableView {
	UIView *superview = self.superview;
	while (superview)
		if ([superview isKindOfClass:[UITableView class]])
			return (UITableView *)superview;
		else
			superview = superview.superview;
	return Nil;
}

@end

@implementation UITableView (Sections)

- (void)insertSectionsInRange:(NSRange)range withRowAnimation:(UITableViewRowAnimation)animation {
	[self insertSections:[NSIndexSet indexSetWithIndexesInRange:range] withRowAnimation:animation];
}

- (void)insertSectionsInRange:(NSRange)range {
	[self insertSections:[NSIndexSet indexSetWithIndexesInRange:range] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)insertSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
	[self insertSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:animation];
}

- (void)insertSection:(NSUInteger)section {
	[self insertSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)deleteSectionsInRange:(NSRange)range withRowAnimation:(UITableViewRowAnimation)animation {
	[self deleteSections:[NSIndexSet indexSetWithIndexesInRange:range] withRowAnimation:animation];
}

- (void)deleteSectionsInRange:(NSRange)range {
	[self deleteSections:[NSIndexSet indexSetWithIndexesInRange:range] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)deleteSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
	[self deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:animation];
}

- (void)deleteSection:(NSUInteger)section {
	[self deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadSectionsInRange:(NSRange)range withRowAnimation:(UITableViewRowAnimation)animation {
	[self reloadSections:[NSIndexSet indexSetWithIndexesInRange:range] withRowAnimation:animation];
}

- (void)reloadSectionsInRange:(NSRange)range {
	[self reloadSections:[NSIndexSet indexSetWithIndexesInRange:range] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
	[self reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:animation];
}

- (void)reloadSection:(NSUInteger)section {
	[self reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)setHeaderText:(NSString *)text forSection:(NSUInteger)section {
	UITableViewHeaderFooterView *view = [self headerViewForSection:section];
	view.textLabel.text = text;
	[view layoutSubviews];
}

- (void)setFooterText:(NSString *)text forSection:(NSUInteger)section {
	UITableViewHeaderFooterView *view = [self footerViewForSection:section];
	view.textLabel.text = text;
	[view layoutSubviews];
}

- (NSUInteger)firstSection {
	return self.numberOfSections ? 0 : NSNotFound;
}

- (NSUInteger)lastSection {
	return self.numberOfSections ? self.numberOfSections - 1 : NSNotFound;
}

@end

@implementation UITableView (Rows)

- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forRow:(NSInteger)row inSection:(NSInteger)section {
	return row != NSNotFound && section != NSNotFound ? [self dequeueReusableCellWithIdentifier:identifier forIndexPath:[NSIndexPath indexPathForRow:row inSection:section]] : Nil;
}

- (void)selectRow:(NSInteger)row inSection:(NSInteger)section {
	if (row != NSNotFound || section != NSNotFound)
		[self selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)deselectRow:(NSInteger)row inSection:(NSInteger)section {
	if (row != NSNotFound && section != NSNotFound)
		[self deselectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] animated:YES];
}

- (void)deselectRows:(BOOL)animated; {
	[self selectRowAtIndexPath:Nil animated:animated scrollPosition:UITableViewScrollPositionNone];
}

- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath withAnimation:(UITableViewRowAnimation)animation {
	if (indexPath)
		[self deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:animation];
}

- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath)
		[self deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)deleteRow:(NSInteger)row inSection:(NSInteger)section {
	if (row != NSNotFound && section != NSNotFound)
		[self deleteRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:row inSection:section] ] withRowAnimation:YES];
}

- (void)insertRowAtIndexPath:(NSIndexPath *)indexPath withAnimation:(UITableViewRowAnimation)animation {
	if (indexPath)
		[self insertRowsAtIndexPaths:@[ indexPath ] withRowAnimation:animation];
}

- (void)insertRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath)
		[self insertRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)insertRow:(NSInteger)row inSection:(NSInteger)section {
	if (row != NSNotFound && section != NSNotFound)
		[self insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:row inSection:section] ] withRowAnimation:YES];
}

- (void)reloadRowAtIndexPath:(NSIndexPath *)indexPath withAnimation:(UITableViewRowAnimation)animation {
	if (indexPath)
		[self reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:animation];
}

- (void)reloadRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath)
		[self reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadRow:(NSInteger)row inSection:(NSInteger)section {
	if (row != NSNotFound && section != NSNotFound)
		[self reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:row inSection:section] ] withRowAnimation:YES];
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

- (UITableViewCell *)cellForRow:(NSInteger)row inSection:(NSInteger)section {
	return row != NSNotFound && section != NSNotFound ? [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]] : Nil;
}

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath {
	[self scrollToRowAtIndexPath:indexPath atScrollPosition:[self.indexPathsForVisibleRows.firstObject compare:indexPath] == NSOrderedDescending ? UITableViewScrollPositionTop : [self.indexPathsForVisibleRows.lastObject compare:indexPath] == NSOrderedAscending ? UITableViewScrollPositionBottom : UITableViewScrollPositionNone animated:YES];
}

- (void)scrollToRow:(NSInteger)row inSection:(NSInteger)section {
	if (row != NSNotFound && section != NSNotFound)
		[self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
}

- (NSIndexPath *)indexPathForNullableCell:(UITableViewCell *)cell {
	return cell ? [self indexPathForCell:cell] : Nil;
}

@end
