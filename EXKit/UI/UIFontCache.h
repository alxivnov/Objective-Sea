//
//  UIFontCache.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 23.02.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FNT_CACHE [UIFontCache instance]

@import UIKit;

@interface UIFontCache : NSObject

- (UIFont *)system:(CGFloat)size;

- (UIFont *)avenirNext:(CGFloat)size;

- (UIFont *)snellRoundhand:(CGFloat)size;

+ (instancetype)instance;

@end
