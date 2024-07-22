//
//  NSImage+Ex.h
//  Guardian
//
//  Created by Alexander Ivanov on 16.07.15.
//  Copyright © 2015 NATEK. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (Ex)

- (NSImage *)tintWithColor:(NSColor *)color;

- (NSImageView *)imageView;

@end
