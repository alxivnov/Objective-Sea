//
//  SKReviewController.h
//  Sleep Diary
//
//  Created by Alexander Ivanov on 08/09/16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSBundle+Convenience.h"
#import "NSCalendar+Convenience.h"
#import "NSObject+Convenience.h"

typedef enum : NSUInteger {
	NSRateControllerStateNone,
	NSRateControllerStateInit,
	NSRateControllerStateLikeYes,
	NSRateControllerStateLikeNo,
	NSRateControllerStateMailYes,
	NSRateControllerStateMailNo,
	NSRateControllerStateRateYes,
	NSRateControllerStateRateNo,
} NSRateControllerState;

@interface NSRateController : NSObject

@property (assign, nonatomic) NSUInteger appIdentifier;
@property (assign, nonatomic) NSDictionary *affiliateInfo;
@property (strong, nonatomic) NSString *recipient;

@property (assign, nonatomic, readonly) NSUInteger launch;
@property (assign, nonatomic, readonly) NSUInteger action;

@property (assign, nonatomic) NSRateControllerState state;

- (NSUInteger)incrementAction;

+ (instancetype)instance;

@end
