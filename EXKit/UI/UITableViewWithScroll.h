//
//  UITableViewWithScroll.h
//  Done!
//
//  Created by Alexander Ivanov on 16.04.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UITableViewWithScroll;

@protocol UITableViewWithScrollDelegate <NSObject>

@optional

- (void)tableView:(UITableViewWithScroll *)tableView didScroll:(CGFloat)offset;

@end

@interface UITableViewWithScroll : UITableView

@property (assign, nonatomic, readonly) BOOL isScrolling;

- (void)stopScrolling;
- (void)scrollDown:(id <UITableViewWithScrollDelegate>)delegate;
- (void)scrollUp:(id <UITableViewWithScrollDelegate>)delegate;

@end
