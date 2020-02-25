//
//  UISlider+Convenience.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 19.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UISlider+Convenience.h"

@implementation UISlider (Convenience)

#if TARGET_OS_IPHONE

- (void)setTrackImage:(UIImage *)image forState:(UIControlState)state {
	[self setMaximumTrackImage:image forState:state];
	[self setMinimumTrackImage:image forState:state];
}

- (void)hideTrack:(UIControlState)state {
	[self setTrackImage:[UIImage alloc] forState:state];
}

- (void)showTrack:(UIControlState)state {
	[self setTrackImage:Nil forState:state];
}

- (void)hideTrack {
	[self setTrackImage:[[UIImage alloc] init] forState:UIControlStateNormal];
}

- (void)showTrack {
	[self setTrackImage:Nil forState:UIControlStateNormal];
}

#else

- (double)maximumValue {
	return self.maxValue;
}

- (double)minimumValue {
	return self.minValue;
}

- (double)value {
	return self.doubleValue;
}

#endif

- (CGFloat)thumbOrigin {
	return (self.bounds.size.width - self.bounds.origin.x - UISliderHeight) / (self.maximumValue - self.minimumValue) * self.value;
}

- (CGFloat)thumbCenter {
	return [self thumbOrigin] + UISliderHeight / 2.0;
}



- (CGFloat)getValueForMin:(CGFloat)min andMax:(CGFloat)max {
	return min + ((max - min) / (self.maximumValue - self.minimumValue) * self.value);
}

@end

@implementation UIPassthroughSlider

#if TARGET_OS_IPHONE
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	CGFloat x = [self thumbCenter];

	return fabs(point.x - x) > UISliderHeight / 2.0 ? Nil : [super hitTest:point withEvent:event];
}
#else
- (NSView *)hitTest:(NSPoint)aPoint {
	CGFloat x = [self thumbCenter]+ self.frame.origin.x;

	return fabs(aPoint.x - x) > UISliderHeight / 2.0 && aPoint.x < x ? Nil : [super hitTest:aPoint];
}
#endif

@end

#if TARGET_OS_IPHONE
@interface UIDoubleSlider ()
@property (strong, nonatomic) UISlider *startSlider;
@property (strong, nonatomic) UISlider *endSlider;
@end

@implementation UIDoubleSlider

- (UISlider *)startSlider {
	if (!_startSlider) {
		_startSlider = [[UISlider alloc] initWithFrame:self.bounds];
		_startSlider.tag = 0;
		_startSlider.value = _startSlider.minimumValue;

		[self addSubview:_startSlider];
	}

	return _startSlider;
}

- (UISlider *)endSlider {
	if (!_endSlider) {
		_endSlider = [[UIPassthroughSlider alloc] initWithFrame:self.bounds];
		_endSlider.tag = 1;
		_endSlider.value = _endSlider.maximumValue;

		[self addSubview:_endSlider];
	}

	return _endSlider;
}

- (void)layoutSubviews {
	[super layoutSubviews];

	self.startSlider.frame = self.bounds;
	self.endSlider.frame = self.bounds;
}

- (float)startValue {
	return self.startSlider.value;
}

- (void)setStartValue:(float)startValue {
	self.startSlider.value = fmaxf(startValue, self.startSlider.minimumValue);
}

- (float)endValue {
	return self.endSlider.value;
}

- (void)setEndValue:(float)endValue {
	self.endSlider.value = fminf(endValue, self.endSlider.maximumValue);
}

- (float)maximumValue {
	return self.startSlider.maximumValue;
}

- (void)setMaximumValue:(float)maximumValue {
	self.startSlider.maximumValue = maximumValue;
	self.endSlider.maximumValue = maximumValue;
}

- (float)minimumValue {
	return self.endSlider.minimumValue;
}

- (void)setMinimumValue:(float)minimumValue {
	self.startSlider.minimumValue = minimumValue;
	self.endSlider.minimumValue = minimumValue;
}

- (void)hideTrack {
	[self.startSlider hideTrack];
	[self.endSlider hideTrack];
}

- (void)showTrack {
	[self.startSlider showTrack];
	[self.endSlider showTrack];
}

- (void)setThumbImage:(UIImage *)image andHighlightedImage:(UIImage *)highlightedImage {
	[self.startSlider setThumbImage:image forState:UIControlStateNormal];
	[self.startSlider setThumbImage:highlightedImage forState:UIControlStateHighlighted];

	[self.endSlider setThumbImage:image forState:UIControlStateNormal];
	[self.endSlider setThumbImage:highlightedImage forState:UIControlStateHighlighted];
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
	[self.startSlider addTarget:target action:action forControlEvents:controlEvents];
	[self.endSlider addTarget:target action:action forControlEvents:controlEvents];
}

@end
#endif
