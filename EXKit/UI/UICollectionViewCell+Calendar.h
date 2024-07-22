//
//  UICollectionViewCell+Calendar.h
//  CollectionView
//
//  Created by Alexander Ivanov on 21.11.14.
//  Copyright (c) 2014 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionViewCell (Calendar)

- (void)checkWithView:(UIView *)view;
- (void)check:(UIColor *)color;
- (void)check;
- (void)uncheck;
- (BOOL)isChecked;

@end
