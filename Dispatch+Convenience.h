//
//  Dispatch+Convenience.h
//  Sleep Diary
//
//  Created by Alexander Ivanov on 16.10.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GCD_MAIN dispatch_get_main_queue()
#define GCD_GLOBAL dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)

#define GCD_COCURRENT(label) dispatch_queue_create(label, DISPATCH_QUEUE_CONCURRENT)
#define GCD_SERIAL(label) dispatch_queue_create(label, DISPATCH_QUEUE_SERIAL)

@interface GCD : NSObject

- (instancetype)initWithCount:(NSInteger)count;

- (BOOL)signal;

- (BOOL)wait:(NSTimeInterval)time;
- (BOOL)wait;

+ (instancetype)create;

+ (void)sync:(void (^)(GCD *sema))sync wait:(NSTimeInterval)time;
+ (void)sync:(void (^)(GCD *sema))sync;



+ (void)queue:(dispatch_queue_t)queue after:(NSTimeInterval)after block:(void (^)())block;
+ (void)global:(void (^)())block;
+ (void)main:(void (^)())block;
+ (void)once:(void (^)())block;

@end
