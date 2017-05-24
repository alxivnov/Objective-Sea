//
//  AVAudioRecorder+Convenience.m
//  Crowd Guard
//
//  Created by Alexander Ivanov on 10.05.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import "AVAudioRecorder+Convenience.h"

@implementation AVAudioSession (Convenience)

+ (void)requestRecordPermission:(PermissionBlock)response {
	AVAudioSession *session = [self sharedInstance];
	AVAudioSessionRecordPermission recordPermission = [session recordPermission];

	if (recordPermission == AVAudioSessionRecordPermissionUndetermined)
		[session requestRecordPermission:response];
	else
		if (response)
			response(recordPermission == AVAudioSessionRecordPermissionGranted);
}

@end

@implementation AVAudioRecorder (Convenience)

+ (instancetype)audioRecorderWithURL:(NSURL *)url settings:(NSDictionary<NSString *,id> *)settings {
	NSError *error = Nil;

	AVAudioRecorder *recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];

	[error log:@"audioRecorderWithURL:settings:"];

	return recorder;
}

+ (instancetype)audioRecorderWithURL:(NSURL *)url format:(AVAudioFormat *)format {
	NSError *error = Nil;

	AVAudioRecorder *recorder = [[AVAudioRecorder alloc] initWithURL:url format:format error:&error];

	[error log:@"audioRecorderWithURL:format:"];

	return recorder;
}

@end
