//
//  AVAudioTime+Seconds.h
//  Ringo
//
//  Created by Alexander Ivanov on 12.05.15.
//  Copyright (c) 2015 Alexander Ivanov. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVAudioTime (Seconds)

- (NSTimeInterval)secondsForSampleTime;

@end
