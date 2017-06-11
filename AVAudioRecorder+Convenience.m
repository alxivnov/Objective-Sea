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
