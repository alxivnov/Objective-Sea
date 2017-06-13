//
//  CoreImage+Convenience.m
//  Poisk
//
//  Created by Alexander Ivanov on 13.06.17.
//  Copyright © 2017 Pine 9. All rights reserved.
//

#import "CoreImage+Convenience.h"

@implementation UIImage (CoreImage)

- (NSArray *)featuresOfType:(NSString *)type options:(NSDictionary<NSString *, id> *)options {
	return [[CIDetector detectorOfType:type context:Nil options:options] featuresInImage:self.CIImage ?: [CIImage imageWithCGImage:self.CGImage] options:options];
}

- (CGRect)boundsForFeature:(CIFeature *)feature {
	return CGRectMake(feature.bounds.origin.x / self.scale, self.size.height - (feature.bounds.origin.y + feature.bounds.size.height) / self.scale, feature.bounds.size.width / self.scale, feature.bounds.size.height / self.scale);
}

- (UIImage *)imageWithFeature:(CIFeature *)feature {
	CGRect rect = CGRectMake(feature.bounds.origin.x, self.size.height * self.scale - (feature.bounds.origin.y + feature.bounds.size.height), feature.bounds.size.width, feature.bounds.size.height);

	CGImageRef cgImage = CGImageCreateWithImageInRect(self.CGImage, rect);

	UIImage *image = [UIImage imageWithCGImage:cgImage scale:self.scale orientation:self.imageOrientation];

	CGImageRelease(cgImage);

	return image;
}

- (UIImage *)filterWithName:(NSString *)name parameters:(NSDictionary<NSString *, id> *)params createCGImage:(BOOL)flag {
	if (!name)
		return self;

	NSMutableDictionary *dic = params ? [params mutableCopy] : [NSMutableDictionary dictionaryWithCapacity:1];
	dic[kCIInputImageKey] = self.CIImage ?: [CIImage imageWithCGImage:self.CGImage];

	CIFilter *filter = [CIFilter filterWithName:name withInputParameters:dic];

	if (!flag)
		return [UIImage imageWithCIImage:filter.outputImage scale:self.scale orientation:self.imageOrientation];

	CGImageRef cgImage = [[CIContext contextWithOptions:Nil] createCGImage:filter.outputImage fromRect:filter.outputImage.extent];

	UIImage *image = [UIImage imageWithCGImage:cgImage scale:self.scale orientation:self.imageOrientation];

	CGImageRelease(cgImage);

	return image;
}

- (UIImage *)filterWithName:(NSString *)name parameters:(NSDictionary<NSString *, id> *)params {
	return [self filterWithName:name parameters:params createCGImage:NO];
}

- (UIImage *)filterWithName:(NSString *)name {
	return [self filterWithName:name parameters:Nil createCGImage:NO];
}

@end
