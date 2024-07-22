//
//  AVAudioTime+Seconds.m
//  Ringo
//
//  Created by Alexander Ivanov on 12.05.15.
//  Copyright (c) 2015 Alexander Ivanov. All rights reserved.
//

#import "AVAudioTime+Seconds.h"

@implementation AVAudioTime (Seconds)

- (NSTimeInterval)secondsForSampleTime {
	return self.sampleTimeValid ? self.sampleTime / self.sampleRate : 0.0;
}

@end
