//
//  UICalendarView.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 23.11.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "NSArray+Convenience.h"
#import "UICalendarView.h"
#import "NSObject+Convenience.h"
#import "UICollectionViewCell+Calendar.h"
#import "UICollectionViewCell+Text.h"

#define CELL_ID @"DAY"

@interface UICalendarView ()
@property (strong, nonatomic) NSArray *days;
@end

@implementation UICalendarView

- (NSArray *)days {
	if (!_days)
		_days = [[self class] createDays];
	
	return _days;
}

- (BOOL)isSelected:(NSInteger)index {
	return [self.selected any:^BOOL(id item) {
		return ((NSNumber *)item).integerValue == index;
	}];
}

- (void)setSelected:(NSArray<NSNumber *> *)selected {
	_selected = selected;
	
	for (UICollectionViewCell *cell in self.visibleCells)
		if ([self isSelected:cell.tag])
			[cell check:self.tintColor];
		else
			[cell uncheck];
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
	
	if (![cell text].enabled)
		return;
	
	if ([self isSelected:cell.tag])
		[[collectionView cellForItemAtIndexPath:indexPath] uncheck];
	else
		[[collectionView cellForItemAtIndexPath:indexPath] check:self.tintColor];
	
	NSMutableArray *selected = [NSMutableArray arrayWithCapacity:self.days.count];
	for (NSUInteger index = 0; index < self.days.count; index++) {
		UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
		if ([cell isChecked])
			[selected addObject:@(cell.tag)];
	}
	_selected = selected;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
	
	NSUInteger index = [[self class] firstDay] + indexPath.row;
	if (index >= self.days.count)
		index -= self.days.count;
	
	cell.tag = index;
	[cell text].enabled = self.enabled;
	[cell text].text = [[self.days[index] description] uppercaseString];
	if ([self isSelected:index])
		[cell check:self.tintColor];
	else
		[cell uncheck];
	
	return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.days.count;
}

- (void)didMoveToSuperview {
	[super didMoveToSuperview];
	
//	[self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELL_ID];
	
	self.dataSource = self;
	self.delegate = self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	UICollectionViewFlowLayout *layout = cls(UICollectionViewFlowLayout, self.collectionViewLayout);
	if (layout) {
		NSUInteger count = self.days.count > 7 ? 7 : self.days.count;
		
		CGFloat x = (self.bounds.size.width - layout.itemSize.width * count) / (count + 1);
		layout.sectionInset = UIEdgeInsetsMake(0.0, x, 0.0, x);
		layout.minimumInteritemSpacing = x;
	}
}

- (void)setEnabled:(BOOL)enabled {
	_enabled = enabled;
	
	for (UICollectionViewCell *cell in self.visibleCells)
		[cell text].enabled = enabled;
}

+ (NSArray *)createDays {
	return Nil;	// abstract
}

+ (NSUInteger)firstDay {
	return 0;	// abstract
}

@end
