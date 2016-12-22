//
//  FSEvents+Convenience.h
//  Guardian
//
//  Created by Alexander Ivanov on 16.12.16.
//  Copyright © 2016 NATEK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSArray+Convenience.h"
#import "NSObject+Convenience.h"

@interface FSEventStream : NSObject

- (instancetype)initWithURL:(NSURL *)URL handler:(void(^)(NSDictionary *events))handler;

@property (assign, nonatomic, readonly) BOOL started;

- (BOOL)start;
- (void)stop;

+ (instancetype)startEventStreamWithURL:(NSURL *)URL handler:(void(^)(NSDictionary *events))handler;

@end

@interface FSHelper : NSObject

+ (FSEventStreamRef)createStream:(NSArray *)URLs callback:(FSEventStreamCallback)callback info:(id)info latency:(NSTimeInterval)latency fileEvents:(BOOL)fileEvents;

+ (void)scheduleStream:(FSEventStreamRef)stream onRunLoop:(CFRunLoopRef)runLoop;

+ (BOOL)startSendingEvents:(FSEventStreamRef)stream;
+ (void)stopSendingEvents:(FSEventStreamRef)stream;

+ (void)unscheduleStream:(FSEventStreamRef)stream fromRunLoop:(CFRunLoopRef)runLoop;

+ (void)invalidateStream:(FSEventStreamRef)stream;
+ (void)releaseStream:(FSEventStreamRef)stream;

+ (NSString *)streamEventFlagsDescription:(FSEventStreamEventFlags)flags;

@end
