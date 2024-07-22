//
//  UICalendarView.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 23.11.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICalendarView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (assign, nonatomic) BOOL enabled;

@property (strong, nonatomic) NSArray<NSNumber *> *selected;

+ (NSArray *)createDays;	// abstract
+ (NSUInteger)firstDay;		// abstract

@end
