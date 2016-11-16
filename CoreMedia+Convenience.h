//
//  CMHelper.h
//  Ringo
//
//  Created by Alexander Ivanov on 28.05.15.
//  Copyright (c) 2015 Alexander Ivanov. All rights reserved.
//

#import <CoreMedia/CoreMedia.h>

#define CMTimeGetTimeInterval(time) CMTimeGetSeconds(time)
#define CMTimeMakeWithTimeInterval(seconds) CMTimeMakeWithSeconds(seconds, 1000)
#define CMTimeRangeFromTimeIntervalToTimeInterval(start, end) CMTimeRangeFromTimeToTime(CMTimeMakeWithSeconds(start, 1000), CMTimeMakeWithSeconds(end, 1000))
