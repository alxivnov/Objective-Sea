//
//  AVAudioEnginePlayer.m
//  Ringo
//
//  Created by Alexander Ivanov on 12.05.15.
//  Copyright (c) 2015 Alexander Ivanov. All rights reserved.
//

#import "AVAudioEnginePlayer.h"
#import "AVAudioTime+Seconds.h"
#import "NSError+Log.h"

@import AVFoundation;

@interface AVAudioEnginePlayer ()
@property (strong, nonatomic) AVAudioEngine *engine;
@property (strong, nonatomic) AVAudioPlayerNode *player;
@property (strong, nonatomic) AVAudioFile *file;

@property (copy, nonatomic) void(^completionHandler)(void);

@property (assign, nonatomic) BOOL scheduled;

@property (assign, nonatomic) NSTimeInterval segmentLocation;
@property (assign, nonatomic) NSTimeInterval segmentDuration;
@end

@implementation AVAudioEnginePlayer

- (void (^)(void))completionHandler {
	if (!_completionHandler) {
		__weak AVAudioEnginePlayer *__self = self;
		_completionHandler = ^void(void) {
			NSLog(@"completed!");
			__self.scheduled = NO;
			
			if (__self.completion)
				__self.completion();
		};
	}
	
	return _completionHandler;
}

- (void)schedule {
	AVAudioFramePosition frameIndex = self.segmentLocation * self.file.processingFormat.sampleRate;
	AVAudioFrameCount frameCount = self.segmentDuration * self.file.processingFormat.sampleRate;
	if (frameIndex && !frameCount)
		frameCount = (AVAudioFrameCount)self.file.length;
	
	if (frameIndex || frameCount)
		[self.player scheduleSegment:self.file startingFrame:frameIndex frameCount:frameCount atTime:Nil completionHandler:self.completionHandler];
	else
		[self.player scheduleFile:self.file atTime:Nil completionHandler:self.completionHandler];
	
	self.scheduled = YES;
}

- (BOOL)play {
	if (!self.scheduled)
		[self schedule];
	
	NSError *error = Nil;
	[self.engine startAndReturnError:&error];

	[self.player play];
	
	[error log:@"startAndReturnError:"];
	return error;
}

- (void)stop {
	if (!self.scheduled)
		return;
	
	[self.player stop];
	
	[self.engine stop];
}

- (void)pause {
	[self.player pause];
	
	[self.engine pause];
}

- (BOOL)playing {
	return self.player.playing && self.scheduled;
}

- (void)reschedule {
	BOOL playing = self.playing;
	
	[self.player stop];
	
	[self schedule];
	
	if (playing)
		[self.player play];
}

- (NSTimeInterval)currentTime {
	AVAudioTime *playerTime = [self.player playerTimeForNodeTime:self.player.lastRenderTime];
	
	return [playerTime secondsForSampleTime];
}

- (void)setCurrentTime:(NSTimeInterval)currentTime {
	[self reschedule];
}

- (void)setLocation:(NSTimeInterval)location andDuration:(NSTimeInterval)duration {
	if (_segmentLocation == location && _segmentDuration == duration)
		return;
	
	self.segmentLocation = location;
	self.segmentDuration = duration;
	
	[self reschedule];
}

- (void)setStart:(NSTimeInterval)startTime andEnd:(NSTimeInterval)endTime {
	[self setLocation:startTime andDuration:endTime - startTime];
}

- (instancetype)initWithContentsOfURL:(NSURL *)url {
	self = [super init];
	
	if (self) {
		self.engine = [[AVAudioEngine alloc] init];
		self.player = [[AVAudioPlayerNode alloc] init];
		[self.engine attachNode:self.player];
		
		NSError *error = Nil;
		
		self.file = [[AVAudioFile alloc] initForReading:url error:&error];
		[self.engine connect:self.player to:self.engine.mainMixerNode format:self.file.processingFormat];
		
		[error log:@"initForReading:"];
	}
	
	return self;
}

@end
