//
//  UISlider+Convenience.h
//  Sleep Diary
//
//  Created by Alexander Ivanov on 19.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
@import UIKit;

#define UISliderHeight 31.0
#else
@import AppKit;

#define UISlider NSSlider

#define UISliderHeight 21.0
#endif

@interface UISlider (Convenience)

#if TARGET_OS_IPHONE
- (void)hideTrack:(UIControlState)state;
- (void)showTrack:(UIControlState)state;
- (void)hideTrack;
- (void)showTrack;
#else
@property (assign, nonatomic, readonly) double maximumValue;
@property (assign, nonatomic, readonly) double minimumValue;
@property (assign, nonatomic, readonly) double value;
#endif

- (CGFloat)thumbOrigin;
- (CGFloat)thumbCenter;



- (CGFloat)getValueForMin:(CGFloat)min andMax:(CGFloat)max;

@end

#if TARGET_OS_IPHONE

#else
#define UIPassthroughSlider NSPassthroughSlider
#define UIView NSView
#endif

@interface UIPassthroughSlider : UISlider

@end

#if TARGET_OS_IPHONE
@interface UIDoubleSlider : UIControl

@property(assign, nonatomic) float startValue;
@property(assign, nonatomic) float endValue;
@property(assign, nonatomic) float minimumValue;
@property(assign, nonatomic) float maximumValue;

- (void)hideTrack;
- (void)showTrack;

- (void)setThumbImage:(UIImage *)image andHighlightedImage:(UIImage *)highlightedImage;

@end
#endif
