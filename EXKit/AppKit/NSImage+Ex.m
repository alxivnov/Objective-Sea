//
//  NSImage+Ex.m
//  Guardian
//
//  Created by Alexander Ivanov on 16.07.15.
//  Copyright © 2015 NATEK. All rights reserved.
//

#import "NSImage+Ex.h"

@implementation NSImage (Ex)

- (NSImage *)tintWithColor:(NSColor *)color {
	NSImage *image = [self copy];
	if (color) {
		[image lockFocus];
		[color set];
		NSRectFillUsingOperation(NSMakeRect(0.0, 0.0, image.size.width, image.size.height), NSCompositeSourceAtop);
		[image unlockFocus];
	}
	return image;
}

- (NSImageView *)imageView {
	NSImageView *imageView = [[NSImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.size.width, self.size.height)];
	imageView.image = self;
	return imageView;
}

@end
