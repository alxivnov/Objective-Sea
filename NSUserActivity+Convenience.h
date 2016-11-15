//
//  NSUserActivity+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 15.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
@import CoreSpotlight;
#endif

typedef enum : NSUInteger {
	NSUserActivityEligibleForHandoff = 1,
	NSUserActivityEligibleForPublicIndexing = 2,
	NSUserActivityEligibleForSearch = 4,
} NSUserActivityEligibility;

@interface NSUserActivity (Convenience)

@property (assign, nonatomic) NSUserActivityEligibility eligibility;
@property (strong, nonatomic) NSArray<NSString *> *allKeywords;

#if TARGET_OS_IPHONE
- (void)setContentDescription:(NSString *)contentDescription;

- (void)setThumbnailData:(NSData *)thumbnailData;
- (void)setThumbnailURL:(NSURL *)thumbnailURL;
#endif

- (void)becomeCurrent:(BOOL)retain;

@end

@interface NSUserActivityQueue : NSObject

- (void)queue:(NSUserActivity *)activity;

+ (instancetype)instance;

@end
