//
//  UIDatePicker+Convenience.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 22.02.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UIDatePicker+Convenience.h"

@implementation UIDatePicker (Convenience)

- (void)setNullableDate:(NSDate *)date animated:(BOOL)animated {
	if (date)
		[self setDate:date animated:animated];
}

- (void)setNullableDate:(NSDate *)date {
	[self setNullableDate:date animated:NO];
}

@end

@interface UIDatePickerController ()
@property (assign, nonatomic, readonly) CGFloat margin;

@property (strong, nonatomic) UIView *parent;

@property (strong, nonatomic) UIView *pane;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *doneButton;
@property (strong, nonatomic) UIDatePicker *datePicker;
@end

@implementation UIDatePickerController

- (UIColor *)backgroundColor {
	return _backgroundColor ?: [UIColor colorWithRed:0xFA / 255.0 green:0xFA / 255.0 blue:0xFF / 255.0 alpha:1.0];
}

- (UIColor *)buttonColor {
	return _buttonColor ?: [UIColor whiteColor];
}

- (UIColor *)pickerColor {
	return _pickerColor ?: [UIColor blackColor];
}

- (UIColor *)titleColor {
	return _titleColor ?: [UIColor darkGrayColor];
}

__synthesize(CGFloat, margin, self.iPad ? GUI_MARGIN_REGULAR : GUI_MARGIN_COMPACT)

- (instancetype)initWithView:(UIView *)view {
	self = [self init];

	if (self)
		self.parent = view;

	return self;
}

- (IBAction)pickerValueChanged:(UIDatePicker *)sender {
	if (self.datePickerValueChanged)
		self.datePickerValueChanged(sender, self.identifier);
}

- (UIDatePicker *)datePicker {
	if (!_datePicker) {
		_datePicker = [[UIDatePicker alloc] init];
		_datePicker.backgroundColor = self.backgroundColor;
		_datePicker.frame = CGRectMake(0.0, 2.0 * self.margin, self.parent.bounds.size.width, _datePicker.frame.size.height);

		[_datePicker addTarget:self action:@selector(pickerValueChanged:) forControlEvents:UIControlEventValueChanged];

		[_datePicker setValue:self.pickerColor forKey:@"textColor"];
	}

	return _datePicker;
}

- (IBAction)buttonTouchUpInside:(UIButton *)sender {
	self.identifier = Nil;
}

- (UILabel *)titleLabel {
	if (!_titleLabel) {
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.pane.bounds.origin.x + self.margin, 0.0, self.doneButton.frame.origin.x - self.margin, 2.0 * self.margin)];

		_titleLabel.font = [UIFont boldSystemFontOfSize:self.doneButton.titleLabel.font.pointSize];
		_titleLabel.textColor = self.titleColor;
	}

	return _titleLabel;
}

- (UIButton *)doneButton {
	if (!_doneButton) {
		_doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
		_doneButton.backgroundColor = self.backgroundColor;

		[_doneButton setTitle:loc(@"Done") forState:UIControlStateNormal];
		[_doneButton setTitleColor:self.buttonColor forState:UIControlStateNormal];

		CGSize size = [_doneButton.titleLabel.attributedText size];
		_doneButton.frame = CGRectMake(self.parent.bounds.size.width - size.width - self.margin, 0.0, size.width + 1.0, 2.0 * self.margin);

		[_doneButton addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
	}

	return _doneButton;
}

- (UIView *)pane {
	if (!_pane) {
		_pane = [[UIView alloc] init];
		_pane.backgroundColor = self.backgroundColor;
		_pane.frame = CGRectMake(0.0, self.parent.bounds.size.height - cls(UITableView, self.parent).contentInset.top, self.parent.bounds.size.width, self.datePicker.frame.size.height + self.doneButton.frame.size.height + self.parent.safeAreaInsets.bottom);
		_pane.hidden = YES;

		[self.pane addSubview:self.datePicker];
		[self.pane addSubview:self.titleLabel];
		[self.pane addSubview:self.doneButton];

		[self.parent addSubview:_pane];
	}

	return _pane;
}

@synthesize identifier = _identifier;

- (id)identifier {
	return self.pane.hidden || !self.pane.tag ? Nil : _identifier;
}

- (void)setIdentifier:(id)identifier {
	id previous = self.identifier;
	if (previous == identifier || ([identifier isKindOfClass:[NSIndexPath class]] && [previous isKindOfClass:[NSIndexPath class]] && ((NSIndexPath *)identifier).section == ((NSIndexPath *)previous).section && ((NSIndexPath *)identifier).row == ((NSIndexPath *)previous).row))
		return;

	if (!identifier) {
		self.pane.tag = 0;
		[UIView animateWithDuration:ANIMATION_DURATION delay:0.0 usingSpringWithDamping:ANIMATION_DAMPING initialSpringVelocity:ANIMATION_VELOCITY options:ANIMATION_OPTIONS animations:^{
			self.pane.frame = CGRectSetY(self.pane.frame, self.parent.bounds.size.height/* - CLS(UITableView, self.parent).contentInset.top*/ + cls(UITableView, self.parent).contentOffset.y);
		} completion:^(BOOL finished) {
			if (!self.pane.tag)
				self.pane.hidden = YES;
		}];
	} else {
		self.pane.tag = NSIntegerMax;
		self.pane.hidden = NO;
		[UIView animateWithDuration:ANIMATION_DURATION delay:0.0 usingSpringWithDamping:ANIMATION_DAMPING initialSpringVelocity:ANIMATION_VELOCITY options:ANIMATION_OPTIONS animations:^{
			[self.pane bringToFront];

			self.pane.frame = CGRectSetY(self.pane.frame, self.parent.bounds.size.height/* - CLS(UITableView, self.parent).contentInset.top*/ + cls(UITableView, self.parent).contentOffset.y - self.pane.frame.size.height);
		} completion:Nil];
	}

	_identifier = identifier;

	if (self.identifierValueChanged)
		self.identifierValueChanged(self.datePicker, self.identifier);
}

- (NSIndexPath *)indexPath {
	return cls(NSIndexPath, self.identifier);
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
	self.identifier = ([self.identifier isKindOfClass:[NSIndexPath class]] && ((NSIndexPath *)self.identifier).section == indexPath.section && ((NSIndexPath *)self.identifier).row == indexPath.row) ? Nil : indexPath;
}

- (UIView *)view {
	return self.identifier ? self.pane : Nil;
}

@end
