//
//  UITableViewCell+Focus.h
//  Done!
//
//  Created by Alexander Ivanov on 12.06.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FOCUS_MAX 1.0
#define FOCUS_MIN 0.0

@interface UITableViewCell (Focus)

- (void)setFocus:(CGFloat)focus;

-(BOOL)isFocused;
-(BOOL)isFocusing;
-(BOOL)isUnfocused;

@end
