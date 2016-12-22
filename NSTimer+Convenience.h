//
//  NSTimer+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 19.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSelectorTimer : NSObject

@property (copy, nonatomic) void (^block)(void);

@property (assign, nonatomic) BOOL enabled;

@property (assign, nonatomic) NSTimeInterval interval;

- (void)fire;

+ (instancetype)create:(void (^)(void))block interval:(NSTimeInterval)interval;

@end

@interface NSTimerBlock : NSObject

- (instancetype)initWithBlock:(BOOL(^)(id userInfo))block;

- (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti userInfo:(id)userInfo repeats:(BOOL)yesOrNo;
- (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti userInfo:(id)userInfo repeats:(BOOL)yesOrNo;

@end
