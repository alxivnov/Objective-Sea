//
//  UIImage+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 15.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UIImage+Convenience.h"

@implementation UIImage (Convenience)

+ (UIImage *)imageWithSize:(CGSize)size opaque:(BOOL)opaque scale:(CGFloat)scale draw:(void(^)(CGContextRef context))draw {
#if TARGET_OS_IPHONE
	UIGraphicsBeginImageContextWithOptions(size, opaque, scale);

	if (draw)
		draw(UIGraphicsGetCurrentContext());

	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

	UIGraphicsEndImageContext();

	return image;
#else
	NSImage *image = [[NSImage alloc] initWithSize:size];

	if (draw) {
		[image lockFocus];

		draw([NSGraphicsContext currentContext].CGContext);

		[image unlockFocus];
	}

	return image;
#endif
}

+ (UIImage *)imageWithSize:(CGSize)size opaque:(BOOL)opaque draw:(void(^)(CGContextRef context))draw {
	return [self imageWithSize:size opaque:opaque scale:0.0 draw:draw];
}

+ (UIImage *)imageWithSize:(CGSize)size draw:(void(^)(CGContextRef context))draw {
	return [self imageWithSize:size opaque:NO scale:0.0 draw:draw];
}



- (UIImage *)imageWithBackground:(UIColor *)color {
	CGRect rect = CGRectMakeWithSize(self.size);

	return [UIImage imageWithSize:rect.size opaque:YES scale:0.0 draw:^(CGContextRef context) {
		CGContextSetFillColorWithColor(context, color.CGColor);
		CGContextFillRect(context, rect);

		[self drawInRect:rect];
	}];
}

- (UIImage *)imageWithTintColor:(UIColor *)color {
	CGRect rect = CGRectMakeWithSize(self.size);

	return [UIImage imageWithSize:rect.size opaque:NO scale:0.0 draw:^(CGContextRef context) {
		[color set];
		[self drawInRect:rect];
	}];
}

- (UIImage *)imageWithSize:(CGSize)size mode:(UIImageScale)mode {
	if (CGSizeEqualToSize(self.size, size))
		return self;

	CGSize originalSize = mode & UIImageScaleAspectFit ? CGSizeAspectFit(self.size, size) : mode & UIImageScaleAspectFill ? CGSizeAspectFill(self.size, size) : self.size;
	CGRect rect = CGSizeCenterInSize(originalSize, size);

	return [UIImage imageWithSize:size opaque:NO scale:0.0 draw:^(CGContextRef context) {
		[self drawInRect:rect];
	}];
}

- (UIImage *)imageWithSize:(CGSize)size {
	return [self imageWithSize:size mode:UIImageScaleNone];
}

+ (UIImage *)imageWithImages:(NSArray<UIImage *> *)images {
	if (!images.count)
		return Nil;

	CGRect rect = CGRectMakeWithSize(images.firstObject.size);

	return [UIImage imageWithSize:rect.size opaque:YES scale:0.0 draw:^(CGContextRef context) {
		for (UIImage *image in images)
			[image drawInRect:CGSizeCenterInRect(image.size, rect)];

	}];
}

#if TARGET_OS_IPHONE
- (NSData *)jpegRepresentation:(CGFloat)quality {
	quality = fmax(quality, 0.0);
	quality = fmin(quality, 1.0);
	return UIImageJPEGRepresentation(self, quality);
}

- (NSData *)jpegRepresentation {
	return [self jpegRepresentation:0.85];
}

- (NSData *)pngRepresentation {
	return UIImagePNGRepresentation(self);
}

- (BOOL)writeJPEGToURL:(NSURL *)url quality:(CGFloat)quality {
	if ([url isExistingItem])
		[url removeItem];

	return [[self jpegRepresentation:quality] writeToURL:url atomically:YES];
}

- (BOOL)writeJPEGToURL:(NSURL *)url {
	return [self writeJPEGToURL:url quality:0.85];
}

- (BOOL)writePNGToURL:(NSURL *)url {
	if ([url isExistingItem])
		[url removeItem];

	return [[self pngRepresentation] writeToURL:url atomically:YES];
}

+ (UIImage *)imageWithContentsOfURL:(NSURL *)url scale:(CGFloat)scale {
	return [UIImage imageWithData:[NSData dataWithContentsOfURL:url] scale:scale];
}

+ (UIImage *)imageWithContentsOfURL:(NSURL *)url {
	return [UIImage imageWithContentsOfURL:url scale:[url.lastPathComponentWithoutExtension hasSuffix:@"@3x"] ? 3.0 : [url.lastPathComponentWithoutExtension hasSuffix:@"@2x"] ? 2.0 : 1.0];
}
#endif

__static(NSMutableDictionary *, images, [NSMutableDictionary new])
__static(NSMutableDictionary *, originals, [NSMutableDictionary new])
__static(NSMutableDictionary *, templates, [NSMutableDictionary new])

+ (UIImage *)image:(id)key renderingMode:(UIImageRenderingMode)renderingMode {
	if (!key)
		return Nil;

	NSMutableDictionary *images = renderingMode == UIImageRenderingModeAlwaysOriginal ? [self originals] : renderingMode == UIImageRenderingModeAlwaysTemplate ? [self templates] : [self images];

	UIImage *value = images[key];

	if (!value) {
		value = [key isKindOfClass:[NSString class]] ? [UIImage imageNamed:key] : [key isKindOfClass:[NSURL class]] ? [UIImage imageWithContentsOfURL:key] : Nil;

		if (renderingMode == UIImageRenderingModeAlwaysOriginal)
			value = [value imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		else if (renderingMode == UIImageRenderingModeAlwaysTemplate)
			value = [value imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

		images[key] = value;
	}

	return value;
}

+ (UIImage *)image:(id)key {
	return [self image:key renderingMode:UIImageRenderingModeAutomatic];
}

+ (UIImage *)originalImage:(id)key {
	return [self image:key renderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)templateImage:(id)key {
	return [self image:key renderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (NSArray<UIImage *> *)images:(NSArray *)keys {
	return [keys map:^id(id obj) {
		return [self image:obj];
	}];
}

+ (NSArray<UIImage *> *)originalImages:(NSArray *)keys {
	return [keys map:^id(id obj) {
		return [self originalImage:obj];
	}];
}

+ (NSArray<UIImage *> *)templateImages:(NSArray *)keys {
	return [keys map:^id(id obj) {
		return [self templateImage:obj];
	}];
}

@end
