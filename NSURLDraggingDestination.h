//
//  NSURLDraggingDestination.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 11/07/16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "NSArray+Convenience.h"

@protocol NSURLDraggingDestination <NSObject>

- (void)performURLDragOperation:(NSArray<NSURL *> *)urls;

@optional

- (void)urlDraggingEntered:(NSArray<NSURL *> *)urls;
- (void)urlDraggingExited:(NSArray<NSURL *> *)urls;
- (void)urlDraggingEnded:(NSArray<NSURL *> *)urls;

@end

@interface NSURLDraggingDestination : NSView <NSDraggingDestination>

@property (strong, nonatomic) NSArray<NSString *> *pathExtensions;
@property (strong, nonatomic) NSColor *borderColor;

@end
