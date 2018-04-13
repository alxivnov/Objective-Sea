//
//  UIImage+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 15.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IOS
@import UIKit;
#elif TARGET_OS_WATCH
@import WatchKit;
#else
@import AppKit;

#define UIImage NSImage
#define UIColor NSColor
#endif

#import "CoreGraphics+Convenience.h"
#import "NSFileManager+Convenience.h"

typedef enum : NSUInteger {
	UIImageScaleNone,
	UIImageScaleAspectFit,
	UIImageScaleAspectFill,
} UIImageScale;

@interface UIImage (Convenience)

+ (UIImage *)imageWithSize:(CGSize)size opaque:(BOOL)opaque scale:(CGFloat)scale draw:(void(^)(CGContextRef context))draw;
+ (UIImage *)imageWithSize:(CGSize)size opaque:(BOOL)opaque draw:(void(^)(CGContextRef context))draw;
+ (UIImage *)imageWithSize:(CGSize)size draw:(void(^)(CGContextRef context))draw;



- (UIImage *)drawImage:(void(^)(CGContextRef context))draw;

- (UIImage *)imageWithBackground:(UIColor *)color;
- (UIImage *)imageWithTintColor:(UIColor *)color;

- (UIImage *)imageWithSize:(CGSize)size mode:(UIImageScale)mode interpolation:(CGInterpolationQuality)interpolation;
- (UIImage *)imageWithSize:(CGSize)size mode:(UIImageScale)mode;
- (UIImage *)imageWithSize:(CGSize)size;

+ (UIImage *)imageWithImages:(NSArray<UIImage *> *)images;

#if TARGET_OS_IPHONE
- (NSData *)jpegRepresentation:(CGFloat)quality;
- (NSData *)jpegRepresentation;
- (NSData *)pngRepresentation;

- (BOOL)writeJPEGToURL:(NSURL *)url quality:(CGFloat)quality;
- (BOOL)writeJPEGToURL:(NSURL *)url;

- (BOOL)writePNGToURL:(NSURL *)url;

+ (UIImage *)imageWithContentsOfURL:(NSURL *)url scale:(CGFloat)scale;
+ (UIImage *)imageWithContentsOfURL:(NSURL *)url;
#endif

+ (UIImage *)image:(id)key;
+ (UIImage *)originalImage:(id)key;
+ (UIImage *)templateImage:(id)key;

+ (NSArray<UIImage *> *)images:(NSArray *)keys;
+ (NSArray<UIImage *> *)originalImages:(NSArray *)keys;
+ (NSArray<UIImage *> *)templateImages:(NSArray *)keys;

+ (NSURL *)URLForResource:(NSString *)name withExtension:(NSString *)ext;
+ (NSURL *)URLForResource:(NSString *)name;

@end

#if __has_include("UIImageEffects.h")

@interface UIImage (UIImageEffects)

- (UIImage*)imageByApplyingLightEffect:(UIImage *)maskImage;
- (UIImage*)imageByApplyingExtraLightEffect:(UIImage *)maskImage;
- (UIImage*)imageByApplyingDarkEffect:(UIImage *)maskImage;

- (UIImage*)imageByApplyingLightEffect;
- (UIImage*)imageByApplyingExtraLightEffect;
- (UIImage*)imageByApplyingDarkEffect;

@end

#endif
