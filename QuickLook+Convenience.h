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

+ (instancetype)createWithURLs:(NSDictionary<NSURL *, NSString *> *)urls;
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

@property (strong, nonatomic, readonly) NSDictionary<NSURL *, NSString *> *URLs;

- (instancetype)initWithURLs:(NSDictionary<NSURL *, NSString *> *)URLs;
- (instancetype)initWithURL:(NSURL *)URL;

@end

#if TARGET_OS_IPHONE
@interface UIViewController (QuickLook)

- (void)presentPreviewWithURLs:(NSDictionary<NSURL *, NSString *> *)URLs animated:(BOOL)flag completion:(void (^)(void))completion;

@end

@interface UINavigationController (QuickLook)

- (void)pushPreviewWithURLs:(NSDictionary<NSURL *, NSString *> *)URLs animated:(BOOL)animated;

@end
#endif
