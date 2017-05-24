//
//  AVAudioRecorder+Convenience.h
//  Crowd Guard
//
//  Created by Alexander Ivanov on 10.05.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "NSObject+Convenience.h"

@interface AVAudioSession (Convenience)

+ (void)requestRecordPermission:(PermissionBlock)response;

@end

@interface AVAudioRecorder (Convenience)

+ (instancetype)audioRecorderWithURL:(NSURL *)url settings:(NSDictionary<NSString *,id> *)settings;
+ (instancetype)audioRecorderWithURL:(NSURL *)url format:(AVAudioFormat *)format;

@end
