//
//  NSURLDraggingDestination.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 11/07/16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "NSURLDraggingDestination.h"

@interface NSURLDraggingDestination ()
@property (strong, nonatomic) NSArray<NSURL *> *urls;
@end

@implementation NSURLDraggingDestination

- (void)awakeFromNib {
	[super awakeFromNib];

	[self registerForDraggedTypes:@[ NSURLPboardType ]];
}

- (void)drawRect:(NSRect)dirtyRect {
	[super drawRect:dirtyRect];

	// Drawing code here.
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
	NSPasteboard *pasteboard = [sender draggingPasteboard];
	NSDragOperation operation = [sender draggingSourceOperationMask];

	if (![pasteboard.types containsObject:NSURLPboardType] || !(operation & NSDragOperationCopy))
		return NSDragOperationNone;

	NSArray<NSURL *> *urls = [pasteboard readObjectsForClasses:[NSArray arrayWithObject:[NSURL class]] options:Nil];
	self.urls = self.pathExtensions.count ? [urls query:^BOOL(NSURL *url) {
		return [self.pathExtensions any:^BOOL(NSString *pathExtension) {
			return [[pathExtension lowercaseString] isEqualToString:[url.pathExtension lowercaseString]];
		}];
	}] : urls;

	[[NSApplication sharedApplication] sendAction:@selector(urlDraggingEntered:) to:Nil from:self.urls];

	if (!urls.count)
		return NSDragOperationNone;

	if (self.borderColor) {
		self.layer.borderColor = self.borderColor.CGColor;
		self.layer.borderWidth = 4.0;
	}
//	self.layer.cornerRadius = 0.0;
//	self.layer.masksToBounds = YES;

	return NSDragOperationEvery;
}

- (void)draggingExited:(id<NSDraggingInfo>)sender {
	[[NSApplication sharedApplication] sendAction:@selector(urlDraggingExited:) to:Nil from:self.urls];

	if (self.borderColor) {
		self.layer.borderColor = Nil;
		self.layer.borderWidth = 0.0;
	}
}

- (void)draggingEnded:(id<NSDraggingInfo>)sender {
	[[NSApplication sharedApplication] sendAction:@selector(urlDraggingEnded:) to:Nil from:self.urls];

	if (self.borderColor) {
		self.layer.borderColor = Nil;
		self.layer.borderWidth = 0.0;
	}
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
	NSPasteboard *pasteboard = [sender draggingPasteboard];
	NSDragOperation operation = [sender draggingSourceOperationMask];

	if (![pasteboard.types containsObject:NSURLPboardType] || !(operation & NSDragOperationCopy))
		return NO;

	return self.urls.count && [[NSApplication sharedApplication] sendAction:@selector(performURLDragOperation:) to:Nil from:self.urls];
}

@end
