//
//  UIScrollViewController.h
//  Done!
//
//  Created by Alexander Ivanov on 09.01.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollViewController : UITableViewController

@property (assign, nonatomic) BOOL statusBarHidden;

- (BOOL)hideStatusBarOnScrollDown;
- (BOOL)hideStatusBarOnScrollUp;

- (CGFloat)topInset;

@end
