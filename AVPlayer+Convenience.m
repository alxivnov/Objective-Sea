//
//  AVPlayer+Convenience.m
//  Ringo
//
//  Created by Alexander Ivanov on 15.07.15.
//  Copyright © 2015 Alexander Ivanov. All rights reserved.
//

#import "AVPlayer+Convenience.h"

@implementation AVPlayer (Convenience)

- (NSURL *)url {
	return [self.currentItem.asset isKindOfClass:[AVURLAsset class]] ? ((AVURLAsset *)self.currentItem.asset).URL : Nil;
}

- (BOOL)isPlaying {
	return self.rate > 0.0;
}

- (BOOL)isPlaying:(CMTime)currentTime {
	return self.isPlaying && CMTimeCompare(currentTime, self.currentItem.duration) < 0;
}

@end

@implementation AVAudioPlayer (Convenience)

+ (instancetype)playerWithContentsOfURL:(NSURL *)url fileTypeHint:(NSString *)uriString {
	NSError *error = Nil;

	AVAudioPlayer *instance = uriString.length ? [[self alloc] initWithContentsOfURL:url fileTypeHint:uriString error:&error] : [[self alloc] initWithContentsOfURL:url error:&error];

	[error log:@"AVAudioSegmentPlayer initWithContentsOfURL:"];

	return error ? Nil : instance;
}

+ (instancetype)playerWithContentsOfURL:(NSURL *)url {
	return url.isWebAddress || url.isExistingFile || url.isMediaItem ? [self playerWithContentsOfURL:url fileTypeHint:[NSString string]] : Nil;
}

+ (instancetype)playerWithData:(NSData *)data fileTypeHint:(NSString *)uriString {
	NSError *error = Nil;

	AVAudioPlayer *instance = uriString.length ? [[self alloc] initWithData:data fileTypeHint:uriString error:&error] : [[self alloc] initWithData:data error:&error];

	[error log:@"AVAudioSegmentPlayer initWithData:"];

	return error ? Nil : instance;
}

+ (instancetype)playerWithData:(NSData *)data {
	return data.length ? [self playerWithData:data fileTypeHint:[NSString string]] : Nil;
}

@end

#define EPSILON 0.04
#define TIME 0.02

@interface AVAudioSegmentPlayer ()
@property (assign, nonatomic) BOOL prepared;
@end

@implementation AVAudioSegmentPlayer {
	NSNumber *_segmentStart;
	NSNumber *_segmentEnd;
}

- (void)performStatusChange {
	__weak AVAudioSegmentPlayer *__self = self;
	if (self.statusChange)
		self.statusChange(__self);
}

- (void)performTimeChange {
	__weak AVAudioSegmentPlayer *__self = self;
	if (self.timeChange)
		self.timeChange(__self);
}

- (instancetype)initWithContentsOfURL:(NSURL *)url fileTypeHint:(NSString *)utiString error:(NSError *__autoreleasing *)outError {
	self = [super initWithContentsOfURL:url fileTypeHint:utiString error:outError];

	if (self)
		self.delegate = self;

	return self;
}

- (instancetype)initWithContentsOfURL:(NSURL *)url error:(NSError * _Nullable __autoreleasing *)outError {
	self = [super initWithContentsOfURL:url error:outError];

	if (self)
		self.delegate = self;

	return self;
}

- (instancetype)initWithData:(NSData *)data fileTypeHint:(NSString *)utiString error:(NSError *__autoreleasing *)outError {
	self = [super initWithData:data fileTypeHint:utiString error:outError];

	if (self)
		self.delegate = self;

	return self;
}

- (instancetype)initWithData:(NSData *)data error:(NSError * _Nullable __autoreleasing *)outError {
	self = [super initWithData:data error:outError];

	if (self)
		self.delegate = self;

	return self;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	[self performStatusChange];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
	[error log:@"audioPlayerDecodeErrorDidOccur:"];

	[self performStatusChange];
}

- (NSComparisonResult)segmentContainsTime:(NSTimeInterval)time {
	BOOL greaterThanStart = !_segmentStart || time - self.segmentStart >= -EPSILON;
	BOOL lessThanEnd = !_segmentEnd || time - self.segmentEnd < -EPSILON;
	return !greaterThanStart ? NSOrderedAscending : !lessThanEnd ? NSOrderedDescending : NSOrderedSame;
}

- (NSTimeInterval)segmentStart {
	return _segmentStart.doubleValue;
}

- (NSTimeInterval)segmentEnd {
	return _segmentEnd.doubleValue;
}

- (NSTimeInterval)segmentDuration {
	return _segmentEnd.doubleValue - _segmentStart.doubleValue;
}

- (void)setSegmentStart:(NSTimeInterval)start andSegmentEnd:(NSTimeInterval)end {
	NSTimeInterval s = fabs(start - self.segmentStart);
	NSTimeInterval e = fabs(end - self.segmentEnd);
	if (s <= EPSILON && e <= EPSILON)
		return;

	_segmentStart = @(start);
	_segmentEnd = @(end);

	NSComparisonResult contains = [self segmentContainsTime:self.currentTime];
	if (contains == NSOrderedSame)
		return;

	[self stop];

	if (contains == NSOrderedAscending)
		[super setCurrentTime:0.0];
	else if (contains == NSOrderedDescending)
		[super setCurrentTime:self.duration];
}

- (void)timer {
	if (!self.playing)
		return;

	if (self.numberOfLoops < 0 && [self segmentContainsTime:self.currentTime] == NSOrderedDescending) {
		self.currentTime = self.segmentStart;

		[self performSelector:@selector(timer) withObject:Nil afterDelay:TIME];
	} else

		if ([self segmentContainsTime:self.currentTime] != NSOrderedSame)
			[self stop];
		else
			[self performSelector:@selector(timer) withObject:Nil afterDelay:TIME];

	[self performTimeChange];
}

- (BOOL)prepareToPlay {
	self.prepared = [super prepareToPlay];

	[self performStatusChange];

	return self.prepared;
}

- (BOOL)play {
	if ([self segmentContainsTime:self.currentTime] != NSOrderedSame)
		self.currentTime = self.segmentStart;

	self.prepared = [super play];

	[self performStatusChange];

	[self timer];

	return self.prepared;
}

- (BOOL)playAtTime:(NSTimeInterval)time {
	return NO;
}

- (void)pause {
	[super pause];

	[self performStatusChange];
}

- (void)stop {
	self.prepared = NO;

	[super stop];

	[self performStatusChange];
}
/*
 - (void)setCurrentTime:(NSTimeInterval)currentTime {
	[super setCurrentTime:[self segmentContainsTime:currentTime] == NSOrderedAscending ? self.segmentStart : currentTime];
 }
 */
@end
