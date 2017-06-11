//
//  AVAudioRecorder+Convenience.h
//  Crowd Guard
//
//  Created by Alexander Ivanov on 10.05.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "NSObject+Convenience.h"

#if TARGET_OS_IOS
#import "UIApplication+Convenience.h"
#endif

@interface AVAudioSession (Convenience)

@property (strong, nonatomic, readonly) NSString *recordPermissionGranted;

#if TARGET_OS_IOS
- (void)requestRecordPermissionIfNeeded:(void (^)(NSNumber *granted))completionHandler;
#endif

@end

@interface AVAudioRecorder (Convenience)

+ (instancetype)audioRecorderWithURL:(NSURL *)url settings:(NSDictionary<NSString *,id> *)settings;
+ (instancetype)audioRecorderWithURL:(NSURL *)url format:(AVAudioFormat *)format;

@end
