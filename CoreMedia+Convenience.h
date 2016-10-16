//
//  CMHelper.h
//  Ringo
//
//  Created by Alexander Ivanov on 28.05.15.
//  Copyright (c) 2015 Alexander Ivanov. All rights reserved.
//

#import <CoreMedia/CoreMedia.h>

#define CMTimeScale 1000

@interface CMHelper : NSObject

+ (NSTimeInterval)secondsWithTime:(CMTime)time;
+ (CMTime)timeWithSeconds:(NSTimeInterval)seconds;

+ (CMTimeRange)timeRangeFromTime:(NSTimeInterval)start toTime:(NSTimeInterval)end;

@end
