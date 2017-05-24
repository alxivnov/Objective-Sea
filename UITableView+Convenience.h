//
//  UITableView+Convenience.h
//  Sleep Diary
//
//  Created by Alexander Ivanov on 20.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GUI_CELL_ID @"Cell"
#define GUI_CUSTOM_CELL_ID @"Custom Cell"
#define GUI_BASIC_CELL_ID @"Basic Cell"
#define GUI_RIGHT_DETAIL_CELL_ID @"Right Detail Cell"
#define GUI_LEFT_DETAIL_CELL_ID @"Left Detail Cell"
#define GUI_SUBTITLE_CELL_ID @"Subtitle Cell"

#define NSIndexPathMake(section, row) [NSIndexPath indexPathForRow:row inSection:section]

@protocol UITableViewSwipeAccessoryButton <NSObject>

@optional

- (NSString *)tableView:(UITableView *)tableView titleForSwipeAccessoryButtonForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView swipeAccessoryButtonPushedForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface NSIndexPath (Convenience)

- (BOOL)isEqualToIndexPath:(NSIndexPath *)indexPath;
- (BOOL)isEqualToSection:(NSUInteger)section row:(NSUInteger)row;

@end

@interface UITableView (Convenience)

@property (assign, nonatomic) UIView *emptyState;

- (BOOL)scrollOffsetToVisible:(CGFloat)offset animated:(BOOL)animated;

@end

@interface UITableView (Sections)

- (void)insertSectionsInRange:(NSRange)range withRowAnimation:(UITableViewRowAnimation)animation;
- (void)insertSectionsInRange:(NSRange)range;

- (void)insertSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;
- (void)insertSection:(NSUInteger)section;

- (void)deleteSectionsInRange:(NSRange)range withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteSectionsInRange:(NSRange)range;

- (void)deleteSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteSection:(NSUInteger)section;

- (void)reloadSectionsInRange:(NSRange)range withRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadSectionsInRange:(NSRange)range;

- (void)reloadSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadSection:(NSUInteger)section;

- (void)setHeaderText:(NSString *)text forSection:(NSUInteger)section;
- (void)setFooterText:(NSString *)text forSection:(NSUInteger)section;

@property (assign, nonatomic, readonly) NSUInteger firstSection;
@property (assign, nonatomic, readonly) NSUInteger lastSection;

@end

@interface UITableView (Rows)

- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forRow:(NSInteger)row inSection:(NSInteger)section;

- (void)selectRow:(NSInteger)row inSection:(NSInteger)section;
- (void)deselectRow:(NSInteger)row inSection:(NSInteger)section;
- (void)deselectRows:(BOOL)animated;

- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath withAnimation:(UITableViewRowAnimation)animation;
- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)deleteRow:(NSInteger)row inSection:(NSInteger)section;

- (void)insertRowAtIndexPath:(NSIndexPath *)indexPath withAnimation:(UITableViewRowAnimation)animation;
- (void)insertRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)insertRow:(NSInteger)row inSection:(NSInteger)section;

- (void)reloadRowAtIndexPath:(NSIndexPath *)indexPath withAnimation:(UITableViewRowAnimation)animation;
- (void)reloadRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)reloadRow:(NSInteger)row inSection:(NSInteger)section;

- (void)moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath inReverse:(BOOL)reverse;

- (UITableViewCell *)cellForRow:(NSInteger)row inSection:(NSInteger)section;

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)scrollToRow:(NSInteger)row inSection:(NSInteger)section;

- (NSIndexPath *)indexPathForNullableCell:(UITableViewCell *)cell;

@end

@interface UITableViewRowAction (Category)

+ (instancetype)destructiveRowActionWithTitle:(NSString *)title handler:(void (^)(UITableViewRowAction *action, NSIndexPath *indexPath))handler;
+ (instancetype)normalRowActionWithTitle:(NSString *)title handler:(void (^)(UITableViewRowAction *action, NSIndexPath *indexPath))handler;

@end
