//
//  CMHelper.m
//  Ringo
//
//  Created by Alexander Ivanov on 28.05.15.
//  Copyright (c) 2015 Alexander Ivanov. All rights reserved.
//

#import "CoreMedia+Convenience.h"

@implementation CMHelper

+ (NSTimeInterval)secondsWithTime:(CMTime)time {
	return CMTimeGetSeconds(time);
}

+ (CMTime)timeWithSeconds:(NSTimeInterval)seconds {
	return CMTimeMakeWithSeconds(seconds, CMTimeScale);
}

+ (CMTimeRange)timeRangeFromTime:(NSTimeInterval)start toTime:(NSTimeInterval)end {
	CMTime startTime = [self timeWithSeconds:start];
	CMTime endTime = [self timeWithSeconds:end];
	return CMTimeRangeFromTimeToTime(startTime, endTime);
}

@end
