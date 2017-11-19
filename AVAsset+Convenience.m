//
//  AVAsset+Export.m
//  Ringo
//
//  Created by Alexander Ivanov on 15.02.15.
//  Copyright (c) 2015 Alexander Ivanov. All rights reserved.
//

#import "AVAsset+Convenience.h"

#define BUFFER_LENGTH 32768

@implementation AVAsset (Convenience)

- (NSTimeInterval)seconds {
	return CMTimeGetSeconds(self.duration);
}

- (AVAssetExportSession *)exportAudio:(CMTimeRange)timeRange metadata:(NSArray *)metadata to:(NSURL *)outputURL completion:(void (^)(void))handler {
	AVAssetExportSession *session = [AVAssetExportSession exportSessionWithAsset:self presetName:AVAssetExportPresetAppleM4A];
	session.outputFileType = AVFileTypeAppleM4A;
	
	session.timeRange = timeRange;
	session.outputURL = outputURL;
	
	session.metadata = metadata;
	
	[session exportAsynchronouslyWithCompletionHandler:handler];
	
	return session;
}

- (AVAssetExportSession *)exportAudio:(CMTimeRange)timeRange to:(NSURL *)outputURL completion:(void (^)(void))handler {
	return [self exportAudio:timeRange metadata:Nil to:outputURL completion:handler];
}

- (id)metadataValueForKey:(NSString *)key {
	NSArray *metadata = [AVMetadataItem metadataItemsFromArray:self.metadata withKey:key keySpace:AVMetadataKeySpaceCommon];
	AVMetadataItem *item = metadata.firstObject;
	return [item.value copyWithZone:Nil];
}

- (NSString *)title {
	return [self metadataValueForKey:AVMetadataCommonKeyTitle];
}

- (NSString *)album {
	return [self metadataValueForKey:AVMetadataCommonKeyAlbumName];
}

- (NSString *)artist {
	return [self metadataValueForKey:AVMetadataCommonKeyArtist];
}

- (NSString *)comment {
	return [self metadataValueForKey:AVMetadataCommonKeyDescription];
}

- (UIImage *)artwork {
	NSArray *metadata = [AVMetadataItem metadataItemsFromArray:self.metadata withKey:AVMetadataCommonKeyArtwork keySpace:AVMetadataKeySpaceCommon];
	for (AVMetadataItem *item in metadata) {
//		if ([item.keySpace isEqualToString:AVMetadataKeySpaceID3])
//			return [UIImage imageWithData:((NSDictionary *)[item.value copyWithZone:Nil])[@"data"]];
//		else if ([item.keySpace isEqualToString:AVMetadataKeySpaceiTunes])
//			return [UIImage imageWithData:[item.value copyWithZone:Nil]];
		NSData *data = [item.value isKindOfClass:[NSData class]] ? [item.value copyWithZone:Nil] : [item.value isKindOfClass:[NSDictionary class]] ? ((NSDictionary *)[item.value copyWithZone:Nil])[@"data"] : Nil;
		if (data)
			return [[UIImage alloc] initWithData:data];
	}
	
	return Nil;
}

- (NSString *)metadataDescription {
	return self.title.length && self.artist.length ? [@[ self.artist, self.title ] componentsJoinedByString:@" - "] : self.title.length ? self.title : self.artist.length ? self.artist : Nil;
}

- (AVAssetReader *)readWithSettings:(NSDictionary<NSString *,id> *)settings queue:(dispatch_queue_t)queue handler:(void (^)(NSData *))handler {
	NSUInteger sampleRate = settings[AVSampleRateKey] ? [settings[AVSampleRateKey] integerValue] : 44100;
	NSUInteger numberOfChannels = settings[AVNumberOfChannelsKey] ? [settings[AVNumberOfChannelsKey] integerValue] : 2;
	NSUInteger bitDepth = settings[AVLinearPCMBitDepthKey] ? [settings[AVLinearPCMBitDepthKey] integerValue] : 16;
	NSMutableData *data = [NSMutableData dataWithCapacity:self.seconds * sampleRate * numberOfChannels * bitDepth];

	AVAssetReader *reader = [AVAssetReader assetReaderWithAsset:self timeRange:kCMTimeRangeInvalid mediaType:AVMediaTypeAudio settings:settings];
	return [reader startReadingOnQueue:queue handler:^(void *buffer, size_t length) {
		if (buffer && length)
			[data appendBytes:buffer length:length];
		else
			handler(data);
	}] ? reader : Nil;
}

- (AVAssetReader *)readWithSettings:(NSDictionary<NSString *,id> *)settings handler:(void (^)(NSData *))handler {
	return [self readWithSettings:settings queue:GCD_GLOBAL handler:handler];
}

- (AVAssetReader *)read:(void (^)(NSData *))handler {
	return [self readWithSettings:Nil queue:GCD_GLOBAL handler:handler];
}

- (AVAssetWriter *)exportAudioWithSettings:(NSDictionary<NSString *,id> *)settings timeRange:(CMTimeRange)timeRange metadata:(NSArray *)metadata to:(NSURL *)outputURL handler:(void (^)(double progress))handler {
	AVAssetReader *reader = [AVAssetReader assetReaderWithAsset:self timeRange:timeRange mediaType:AVMediaTypeAudio settings:Nil];
	AVAssetWriter *writer = [AVAssetWriter assetWriterWithURL:outputURL fileType:AVFileTypeAppleM4A mediaType:AVMediaTypeAudio settings:settings];
	writer.metadata = metadata;
	return [reader startWriting:writer handler:^(CMTime time) {
		if (handler)
			handler(CMTIME_IS_INVALID(time) ? 1.0 : CMTimeGetSeconds(time) / CMTimeGetSeconds(self.duration));
	}] ? writer : Nil;
}

- (BOOL)canRead {
	return [AVAssetReader assetReaderWithAsset:self timeRange:kCMTimeRangeInvalid mediaType:AVMediaTypeAudio settings:Nil].canRead;
}

@end

@implementation AVAssetTrack (Convenience)

- (NSUInteger)channelsPerFrame {
	return CMAudioFormatDescriptionGetStreamBasicDescription((CMFormatDescriptionRef)self.formatDescriptions.firstObject)->mChannelsPerFrame;
}

@end

@implementation AVMetadataItem (Convenience)

+ (instancetype)metadataItemWithKey:(id <NSObject, NSCopying>)key value:(id <NSObject, NSCopying>)value {
	AVMutableMetadataItem *instance = [AVMutableMetadataItem metadataItem];
	instance.keySpace = AVMetadataKeySpaceCommon;
	instance.key = key;
	instance.value = value;
	return instance;
}

@end

@implementation AVAssetReader (Convenience)

+ (AVAssetReader *)assetReaderWithAsset:(AVAsset *)asset timeRange:(CMTimeRange)timeRange mediaType:(NSString *)mediaType settings:(NSDictionary<NSString *,id> *)settings {
	NSError *error = Nil;

	AVAssetReader *reader = [AVAssetReader assetReaderWithAsset:asset error:&error];

	if (!CMTimeRangeEqual(timeRange, kCMTimeRangeInvalid))
		reader.timeRange = timeRange;

	[error log:@"assetReaderWithAsset:"];

	if (!reader)
		return Nil;

	AVAssetReaderOutput *output = [AVAssetReaderAudioMixOutput assetReaderAudioMixOutputWithAudioTracks:[asset tracksWithMediaType:mediaType] audioSettings:settings];
	output.alwaysCopiesSampleData = NO;

	if (![reader canAddOutput:output])
		return Nil;

	[reader addOutput:output];

	return reader;
}

- (BOOL)canRead {
	if (![self startReading])
		return NO;

	CMSampleBufferRef sampleBuffer = [self.outputs.firstObject copyNextSampleBuffer];
	if (sampleBuffer) {
		CFRelease(sampleBuffer);

		return YES;
	} else {
		[self.error log:@"canRead"];

		return NO;
	}
}

- (BOOL)startReadingOnQueue:(dispatch_queue_t)queue handler:(void (^)(void *, size_t))handler {
	if (![self startReading])
		return NO;

	[GCD queue:queue after:0.0 block:^{
		void *buffer = malloc(BUFFER_LENGTH);

		AVAssetReaderOutput *read = self.outputs.firstObject;
		while (read) {
			CMSampleBufferRef sampleBuffer = [read copyNextSampleBuffer];
			if (sampleBuffer) {
				CMBlockBufferRef blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);

				size_t length = CMBlockBufferGetDataLength(blockBuffer);

				char *data = buffer;
				CMBlockBufferAccessDataBytes(blockBuffer, 0, MIN(length, BUFFER_LENGTH), buffer, &data);
//				CMBlockBufferCopyDataBytes(blockBuffer, 0, length, buffer);

				handler(data, data == buffer ? MIN(length, BUFFER_LENGTH) : length);

				CFRelease(sampleBuffer);
				sampleBuffer = Nil;
			} else {
				[self.error log:@"startReadingOnQueue:"];

				handler(Nil, 0);

				read = Nil;
			}
		}

		free(buffer);
	}];

	return YES;
}

- (BOOL)startReading:(void (^)(void *, size_t))handler {
	return [self startReadingOnQueue:GCD_GLOBAL handler:handler];
}

- (BOOL)startWriting:(AVAssetWriter *)writer queue:(dispatch_queue_t)queue handler:(void (^)(CMTime time))handler {
	if (self.status != AVAssetReaderStatusReading && ![self startReading]) {
		[self.error log:@"startReading:"];
		return NO;
	}

	if (writer.status != AVAssetWriterStatusWriting && ![writer startWriting]) {
		[writer.error log:@"startWriting:"];
		return NO;
	}

	[writer startSessionAtSourceTime:self.timeRange.start.value ? self.timeRange.start : kCMTimeZero];

	AVAssetWriterInput *input = writer.inputs.firstObject;
	AVAssetReaderOutput *output = self.outputs.firstObject;
	[input requestMediaDataWhenReadyOnQueue:queue usingBlock:^{
		while ([input isReadyForMoreMediaData]) {
			CMSampleBufferRef nextSampleBuffer = [output copyNextSampleBuffer];
			if (nextSampleBuffer) {
				CMTime time = CMSampleBufferGetPresentationTimeStamp(nextSampleBuffer);

				[input appendSampleBuffer:nextSampleBuffer];
				CFRelease(nextSampleBuffer);

				if (handler)
					handler(time);
			} else {
				[input markAsFinished];

				if (self.timeRange.duration.value)
					[writer endSessionAtSourceTime:CMTimeAdd(self.timeRange.start, self.timeRange.duration)];
				[writer finishWritingWithCompletionHandler:^{
					if (handler)
						handler(kCMTimeInvalid);
				}];

				break;
			}
		}
	}];

	return YES;
}

- (BOOL)startWriting:(AVAssetWriter *)writer handler:(void (^)(CMTime time))handler {
	return [self startWriting:writer queue:GCD_SERIAL("AVAssetReader+Convenience startWriting:") handler:handler];
}

@end

@implementation AVAssetWriter (Convenience)

+ (instancetype)assetWriterWithURL:(NSURL *)url fileType:(NSString *)fileType/*AVFileTypeAppleM4A*/ mediaType:(NSString *)mediaType/*AVMediaTypeAudio*/ settings:(NSDictionary<NSString *,id> *)settings {
	NSError *error = Nil;

	AVAssetWriter *writer = [AVAssetWriter assetWriterWithURL:url fileType:fileType error:&error];

	[error log:@"assetWriterWithURL:"];

	if (!writer)
		return Nil;

	AVAssetWriterInput *input = [AVAssetWriterInput assetWriterInputWithMediaType:mediaType outputSettings:settings];

	if (![writer canAddInput:input])
		return Nil;

	[writer addInput:input];

	return writer;
}

@end
