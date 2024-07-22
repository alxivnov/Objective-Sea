//
//  UITableViewCellWithFocus.h
//  Done!
//
//  Created by Alexander Ivanov on 12.06.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FOCUS_MAX 100

@interface UITableViewCellWithFocus : UITableViewCell

@property (assign, nonatomic) NSUInteger focus;

@end
