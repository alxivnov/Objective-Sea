//
//  UITableView+Focus.h
//  Done!
//
//  Created by Alexander Ivanov on 14.11.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import "UITableViewWithScroll.h"

@class UITableViewWithFocus;

@protocol UITableViewWithFocusDelegate <NSObject>

@optional

- (void)tableView:(UITableViewWithFocus *)tableView didFocus:(CGFloat)focus;

@end

@interface UITableViewWithFocus : UITableViewWithScroll

@property (assign, nonatomic) id <UITableViewDelegate, UITableViewWithFocusDelegate> delegate;

@property (nonatomic, assign) CGFloat minFocusValue;
@property (nonatomic, assign) CGFloat maxFocusValue;
@property (nonatomic, assign, readonly) CGFloat focusValue;
@property (nonatomic, assign, readonly) BOOL isFocused;
@property (nonatomic, assign, readonly) BOOL isFocusing;
@property (nonatomic, assign, readonly) BOOL isUnfocused;
@property (nonatomic, assign, readonly) BOOL isAnimating;
@property (strong, nonatomic, readonly) NSArray	*cellsInFocus;

- (void)setFocus:(CGFloat)value forCells:(NSArray *)cells withDuration:(NSTimeInterval)duration;
- (void)refocusOnCells:(NSArray *)cells withDuration:(NSTimeInterval)duration;
- (void)focusOnCells:(NSArray *)cells withDuration:(NSTimeInterval)duration;
- (void)defocusWithDuration:(NSTimeInterval)duration;

@end
