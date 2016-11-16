//
//  UIImage+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 15.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
@import UIKit;
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



- (UIImage *)imageWithBackground:(UIColor *)color;
- (UIImage *)imageWithTintColor:(UIColor *)color;

- (UIImage *)imageWithSize:(CGSize)size mode:(UIImageScale)mode;
- (UIImage *)imageWithSize:(CGSize)size;

+ (UIImage *)imageWithImages:(NSArray<UIImage *> *)images;

#if TARGET_OS_IPHONE
- (NSData *)jpegRepresentation:(CGFloat)quality;
- (NSData *)pngRepresentation;

- (BOOL)writeJPEGToURL:(NSURL *)url quality:(CGFloat)quality;
- (BOOL)writeJPEGToURL:(NSURL *)url;

- (BOOL)writePNGToURL:(NSURL *)url;

+ (UIImage *)imageWithContentsOfURL:(NSURL *)url;
#endif

@end
