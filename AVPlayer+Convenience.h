//
//  AVPlayer+Convenience.h
//  Ringo
//
//  Created by Alexander Ivanov on 15.07.15.
//  Copyright © 2015 Alexander Ivanov. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "NSFileManager+Convenience.h"
#import "NSURL+Convenience.h"

@interface AVPlayer (Convenience)

@property (strong, nonatomic, readonly) NSURL *url;

@property (assign, nonatomic, readonly) BOOL isPlaying;

- (BOOL)isPlaying:(CMTime)currentTime;

@end

@interface AVAudioPlayer (Convenience)

+ (instancetype)playerWithContentsOfURL:(NSURL *)url fileTypeHint:(NSString *)uriString;
+ (instancetype)playerWithContentsOfURL:(NSURL *)url;

+ (instancetype)playerWithData:(NSData *)data fileTypeHint:(NSString *)uriString;
+ (instancetype)playerWithData:(NSData *)data;

@end

@interface AVAudioSegmentPlayer : AVAudioPlayer <AVAudioPlayerDelegate>

@property (copy, nonatomic) void(^statusChange)(AVAudioSegmentPlayer *sender);
@property (copy, nonatomic) void(^timeChange)(AVAudioSegmentPlayer *sender);

@property (assign, nonatomic, readonly) BOOL prepared;

@property (assign, nonatomic, readonly) NSTimeInterval segmentStart;
@property (assign, nonatomic, readonly) NSTimeInterval segmentEnd;
@property (assign, nonatomic, readonly) NSTimeInterval segmentDuration;
- (void)setSegmentStart:(NSTimeInterval)start andSegmentEnd:(NSTimeInterval)end;
- (NSComparisonResult)segmentContainsTime:(NSTimeInterval)time;

@end
