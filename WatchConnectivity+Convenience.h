//
//  WatchConnectivity+Convenience.h
//  Sleep Diary
//
//  Created by Alexander Ivanov on 13.10.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <WatchConnectivity/WatchConnectivity.h>

#import "NSFormatter+Convenience.h"

@interface NSDate (WatchConnectivity)

- (NSString *)serialize;

+ (NSDate *)deserialize:(NSString *)string;

@end

@interface WCSession (Convenience)

- (void)sendMessage:(NSDictionary<NSString *, id> *)message replyHandler:(void (^)(NSDictionary<NSString *, id> *replyMessage))replyHandler;

- (void)sendMessage:(NSDictionary<NSString *, id> *)message;

@end

@interface WCSessionDelegate : NSObject <WCSessionDelegate>

@property (copy, nonatomic) void(^didReceiveMessage)(NSDictionary<NSString *,id> *message, void (^replyHandler)(NSDictionary<NSString *,id> *replyMessage));

@property (strong, nonatomic, readonly) WCSession *session;
@property (strong, nonatomic, readonly) WCSession *installedSession;
@property (strong, nonatomic, readonly) WCSession *reachableSession;

+ (instancetype)instance;

@end
