//
//  AVAsset+Export.h
//  Ringo
//
//  Created by Alexander Ivanov on 15.02.15.
//  Copyright (c) 2015 Alexander Ivanov. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#if TARGET_OS_IPHONE
@import UIKit;
#else
@import AppKit;
#define UIImage NSImage
#endif

#define AVAudioSettingsLinearPCMMono @{ AVFormatIDKey : @(kAudioFormatLinearPCM), AVLinearPCMBitDepthKey : @(32), AVLinearPCMIsFloatKey : @YES, AVNumberOfChannelsKey : @(1) }
#define AVAudioSettingsLinearPCMStereo @{ AVFormatIDKey : @(kAudioFormatLinearPCM), AVLinearPCMBitDepthKey : @(32), AVLinearPCMIsFloatKey : @YES, AVNumberOfChannelsKey : @(2) }
#define AVAudioSettingsMPEG4AACMono @{ AVFormatIDKey : @(kAudioFormatMPEG4AAC), AVSampleRateKey : @(44100), AVNumberOfChannelsKey : @(1) }
#define AVAudioSettingsMPEG4AACStereo @{ AVFormatIDKey : @(kAudioFormatMPEG4AAC), AVSampleRateKey : @(44100), AVNumberOfChannelsKey : @(2) }
#define AVAudioSettingsMPEG4Layer3Mono @{ AVFormatIDKey : @(kAudioFormatMPEGLayer3), AVSampleRateKey : @(44100), AVNumberOfChannelsKey : @(1) }
#define AVAudioSettingsMPEG4Layer3Stereo @{ AVFormatIDKey : @(kAudioFormatMPEGLayer3), AVSampleRateKey : @(44100), AVNumberOfChannelsKey : @(2) }

#import "Dispatch+Convenience.h"
#import "NSObject+Convenience.h"

@interface AVAsset (Convenience)

@property (assign, nonatomic, readonly) NSTimeInterval seconds;

@property (strong, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly) NSString *album;
@property (strong, nonatomic, readonly) NSString *artist;
@property (strong, nonatomic, readonly) NSString *comment;
@property (strong, nonatomic, readonly) UIImage *artwork;

- (NSString *)metadataDescription;

- (AVAssetExportSession *)exportAudio:(CMTimeRange)timeRange metadata:(NSArray *)metadata to:(NSURL *)outputURL completion:(void (^)(void))handler;
- (AVAssetExportSession *)exportAudio:(CMTimeRange)timeRange to:(NSURL *)outputURL completion:(void (^)(void))handler;

- (AVAssetReader *)readWithSettings:(NSDictionary<NSString *, id> *)settings queue:(dispatch_queue_t)queue handler:(void (^)(NSData *data))handler;
- (AVAssetReader *)readWithSettings:(NSDictionary<NSString *, id> *)settings handler:(void (^)(NSData *data))handler;
- (AVAssetReader *)read:(void (^)(NSData *data))handler;

- (AVAssetWriter *)exportAudioWithSettings:(NSDictionary<NSString *, id> *)settings timeRange:(CMTimeRange)timeRange metadata:(NSArray *)metadata to:(NSURL *)outputURL handler:(void (^)(double progress))handler;

@property (assign, nonatomic, readonly) BOOL canRead;

@end

@interface AVAssetTrack (Convenience)

@property (assign, nonatomic, readonly) NSUInteger channelsPerFrame;

@end

@interface AVMetadataItem (Convenience)

+ (AVMutableMetadataItem *)metadataItemWithKey:(id <NSObject, NSCopying>)key value:(id <NSObject, NSCopying>)value;

@end

@interface AVAssetReader (Convenience)

+ (AVAssetReader *)assetReaderWithAsset:(AVAsset *)asset timeRange:(CMTimeRange)timeRange mediaType:(NSString *)mediaType settings:(NSDictionary<NSString *,id> *)settings;

@property (assign, nonatomic, readonly) BOOL canRead;

- (BOOL)startReadingOnQueue:(dispatch_queue_t)queue handler:(void (^)(void *, size_t))handler;
- (BOOL)startReading:(void (^)(void *, size_t))handler;

- (BOOL)startWriting:(AVAssetWriter *)writer queue:(dispatch_queue_t)queue handler:(void (^)(CMTime time))handler;
- (BOOL)startWriting:(AVAssetWriter *)writer handler:(void (^)(CMTime time))handler;

@end

@interface AVAssetWriter (Convenience)

+ (instancetype)assetWriterWithURL:(NSURL *)url fileType:(NSString *)fileType mediaType:(NSString *)mediaType settings:(NSDictionary<NSString *,id> *)settings;

@end
