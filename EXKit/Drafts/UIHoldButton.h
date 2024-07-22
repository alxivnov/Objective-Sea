//
//  UIHoldButton.h
//  Sleep Diary
//
//  Created by Alexander Ivanov on 16.05.15.
//  Copyright (c) 2015 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIHoldButton : UIButton

@property (copy, nonatomic) void (^holdUpBlock)(UIHoldButton *sender);
@property (assign, nonatomic) NSTimeInterval holdUpDelay;

@end



/*
 @protocol DeviceInfoForKey <NSObject>

 - (NSNumber *)_deviceInfoForKey:(NSString *)key;

 @end
 */
#define DEVICE_RGB_COLOR @"DeviceRGBColor"

+ (BOOL)hasBlackFrontPanel {
	return YES;

	/*
	 UIDevice *device = [UIDevice currentDevice];

	 if (![device respondsToSelector:@selector(_deviceInfoForKey:)])
		return NO;

	 NSNumber *color = [(id <DeviceInfoForKey>)device _deviceInfoForKey:DEVICE_RGB_COLOR];
	 if (!color)
		return NO;

	 NSInteger integer = [(NSNumber *)color intValue];
	 if (integer > 0 && integer < 8421504)
		return YES;

	 return NO;
	 */
}

+ (BOOL)systemVersionIsGreaterOrEqual:(NSString *)systemVersion {
	return [[UIDevice currentDevice].systemVersion compare:systemVersion options:NSNumericSearch] != NSOrderedAscending;
}
