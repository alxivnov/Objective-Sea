//
//  UIDatePicker+Convenience.h
//  Sleep Diary
//
//  Created by Alexander Ivanov on 22.02.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+Convenience.h"
#import "UIViewController+Convenience.h"

@interface UIDatePicker (Convenience)

- (void)setNullableDate:(NSDate *)date animated:(BOOL)animated;
- (void)setNullableDate:(NSDate *)date;

@end

@interface UIDatePickerController : UIViewController

@property (strong, nonatomic) UIColor *backgroundColor;
@property (strong, nonatomic) UIColor *buttonColor;
@property (strong, nonatomic) UIColor *pickerColor;
@property (strong, nonatomic) UIColor *titleColor;

- (instancetype)initWithView:(UIView *)view;

@property (strong, nonatomic) id identifier;
@property (strong, nonatomic) NSIndexPath *indexPath;

@property (strong, readonly, nonatomic) UILabel *titleLabel;
@property (strong, readonly, nonatomic) UIButton *doneButton;
@property (strong, readonly, nonatomic) UIDatePicker *datePicker;

@property (copy, nonatomic) void (^identifierValueChanged)(UIDatePicker *sender, id identifier);
@property (copy, nonatomic) void (^datePickerValueChanged)(UIDatePicker *sender, id identifier);

@end
