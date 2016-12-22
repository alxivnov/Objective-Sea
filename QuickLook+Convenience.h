//
//  QuickLook+Convenience.h
//  Guardian
//
//  Created by Alexander Ivanov on 16.12.16.
//  Copyright © 2016 NATEK. All rights reserved.
//

#import <QuickLook/QuickLook.h>

#import "NSArray+Convenience.h"
#import "NSObject+Convenience.h"

#if TARGET_OS_IPHONE
@interface QLPreview : QLPreviewController <QLPreviewControllerDelegate>

@property (assign, nonatomic) BOOL actionDisabled;

@property (copy, nonatomic) void (^willDismiss)(QLPreviewController *, NSArray *);
@property (copy, nonatomic) void (^didDismiss)(QLPreviewController *, NSArray *);

+ (instancetype)createWithURLs:(NSArray *)urls;
+ (instancetype)createWithURL:(NSURL *)url;

@end
#endif

#if TARGET_OS_IPHONE
@import QuickLook;
#else
@import Quartz;
#endif


#if TARGET_OS_IPHONE
@interface QLPreviewDataSource : NSObject <QLPreviewControllerDataSource>
#else
@interface QLPreviewDataSource : NSObject <QLPreviewPanelDataSource, QLPreviewPanelDelegate>
#endif

@property (strong, nonatomic, readonly) NSArray *URLs;

- (instancetype)initWithURLs:(NSArray *)URLs;
- (instancetype)initWithURL:(NSURL *)URL;

@end
