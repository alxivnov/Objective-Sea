//
//  AVAudioRecorder+Convenience.m
//  Crowd Guard
//
//  Created by Alexander Ivanov on 10.05.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import "AVAudioRecorder+Convenience.h"

@implementation AVAudioSession (Convenience)

- (NSNumber *)recordPermissionGranted {
	return self.recordPermission == AVAudioSessionRecordPermissionGranted ? @YES : self.recordPermission == AVAudioSessionRecordPermissionDenied ? @NO : Nil;
}

#if TARGET_OS_IOS
- (void)requestRecordPermissionIfNeeded:(void (^)(NSNumber *granted))completionHandler {
	if (self.recordPermissionGranted.boolValue) {
		if (completionHandler)
			completionHandler(@YES);
	} else if (self.recordPermissionGranted) {
		[UIApplication openSettings];

		if (completionHandler)
			completionHandler(Nil);
	} else {
		[self requestRecordPermission:^(BOOL granted) {
			if (completionHandler)
				completionHandler(@(granted));
		}];
	}
}
#endif

@end

@implementation AVAudioRecorder (Convenience)

+ (instancetype)audioRecorderWithURL:(NSURL *)url settings:(NSDictionary<NSString *,id> *)settings {
	if ([AVAudioSession sharedInstance].recordPermission != AVAudioSessionRecordPermissionGranted)
		return Nil;

	NSError *error = Nil;

	AVAudioRecorder *recorder = [[self alloc] initWithURL:url settings:settings error:&error];

	[error log:@"audioRecorderWithURL:settings:"];

	return recorder;
}

+ (instancetype)audioRecorderWithURL:(NSURL *)url format:(AVAudioFormat *)format {
	if ([AVAudioSession sharedInstance].recordPermission != AVAudioSessionRecordPermissionGranted)
		return Nil;

	NSError *error = Nil;

	AVAudioRecorder *recorder = [[self alloc] initWithURL:url format:format error:&error];

	[error log:@"audioRecorderWithURL:format:"];

	return recorder;
}

- (BOOL)recordInTime:(NSTimeInterval)time forDuration:(NSTimeInterval)duration {
	if (time > 0.0 && duration > 0.0)
		return [self recordAtTime:self.deviceCurrentTime + time forDuration:duration];
	else if (time > 0.0)
		return [self recordAtTime:self.deviceCurrentTime + time];
	else if (duration > 0.0)
		return [self recordForDuration:duration];
	else
		return [self record];
}

+ (instancetype)recordInTime:(NSTimeInterval)time forDuration:(NSTimeInterval)duration url:(NSURL *)url settings:(NSDictionary<NSString *,id> *)settings {
	AVAudioRecorder *recorder = [self audioRecorderWithURL:url settings:settings];

	return [recorder recordInTime:time forDuration:duration] ? recorder : Nil;
}

+ (instancetype)recordInTime:(NSTimeInterval)time forDuration:(NSTimeInterval)duration url:(NSURL *)url format:(AVAudioFormat *)format {
	AVAudioRecorder *recorder = [self audioRecorderWithURL:url format:format];

	return [recorder recordInTime:time forDuration:duration] ? recorder : Nil;
}

@end

@interface AVAudioRecorderFactory () <AVAudioRecorderDelegate>
@property (copy, nonatomic) void (^completion)(NSURL *, BOOL);
@end

@implementation AVAudioRecorderFactory

+ (instancetype)recordInTime:(NSTimeInterval)time forDuration:(NSTimeInterval)duration url:(NSURL *)url settings:(NSDictionary<NSString *,id> *)settings completion:(void (^)(NSURL *, BOOL))completion {
	AVAudioRecorderFactory *recorder = [self audioRecorderWithURL:url settings:settings];
	recorder.completion = completion;
	recorder.delegate = recorder;

	time += recorder.deviceCurrentTime;
	return [recorder recordInTime:time forDuration:duration] ? recorder : Nil;
}

+ (instancetype)recordInTime:(NSTimeInterval)time forDuration:(NSTimeInterval)duration url:(NSURL *)url format:(AVAudioFormat *)format completion:(void (^)(NSURL *, BOOL))completion {
	AVAudioRecorderFactory *recorder = [self audioRecorderWithURL:url format:format];
	recorder.completion = completion;
	recorder.delegate = recorder;

	time += recorder.deviceCurrentTime;
	return [recorder recordInTime:time forDuration:duration] ? recorder : Nil;
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
	if (self.completion)
		self.completion(recorder.url, NO);

	[error log:@"audioRecorderEncodeErrorDidOccur:"];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
	if (self.completion)
		self.completion(recorder.url, flag);
}

@end
