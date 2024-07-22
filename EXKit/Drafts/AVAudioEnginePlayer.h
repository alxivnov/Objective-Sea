//
//  AVAudioEnginePlayer.h
//  Ringo
//
//  Created by Alexander Ivanov on 12.05.15.
//  Copyright (c) 2015 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AVAudioEnginePlayer : NSObject

- (BOOL)play;
- (void)pause;
- (void)stop;

@property (assign, nonatomic, readonly) BOOL playing;

@property (assign, nonatomic, readonly) NSTimeInterval currentTime;
@property (assign, nonatomic, readonly) NSTimeInterval segmentLocation;
@property (assign, nonatomic, readonly) NSTimeInterval segmentDuration;

- (void)setLocation:(NSTimeInterval)location andDuration:(NSTimeInterval)duration;
- (void)setStart:(NSTimeInterval)startTime andEnd:(NSTimeInterval)endTime;

@property (copy, nonatomic) void(^completion)(void);

- (instancetype)initWithContentsOfURL:(NSURL *)url;

@end
