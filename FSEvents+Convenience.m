//
//  FSEvents+Convenience.m
//  Guardian
//
//  Created by Alexander Ivanov on 16.12.16.
//  Copyright © 2016 NATEK. All rights reserved.
//

#import "FSEvents+Convenience.h"

@interface FSEventStream ()
@property (strong, nonatomic) NSURL *URL;
@property (copy, nonatomic) void(^handler)(NSDictionary *);

@property (assign, nonatomic) FSEventStreamRef stream;

@property (assign, nonatomic) BOOL started;
@end

@implementation FSEventStream

void callback(ConstFSEventStreamRef streamRef, void *clientCallBackInfo, size_t numEvents, void *eventPaths, const FSEventStreamEventFlags eventFlags[], const FSEventStreamEventId eventIds[]) {
	FSEventStream *__self = (__bridge FSEventStream *)clientCallBackInfo;
	CFArrayRef paths = eventPaths;

	NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:numEvents];

	for (NSUInteger index = 0; index < numEvents; index++) {
		CFStringRef path = CFArrayGetValueAtIndex(paths, index);
		FSEventStreamEventFlags flags = eventFlags[index];

		if (!path || !flags)
			continue;

		NSURL *url = [[NSURL alloc] initFileURLWithPath:(__bridge NSString *)path];
		flags = [dictionary[url] unsignedIntValue] | flags;
		dictionary[url] = @(flags);
	}

	if (__self.handler)
		__self.handler(dictionary);
}

- (instancetype)initWithURL:(NSURL *)URL handler:(void(^)(NSDictionary *))handler {
	self = [super init];

	if (self) {
		self.URL = URL;
		self.handler = handler;

		self.stream = [FSHelper createStream:arr_(URL) callback:callback info:self latency:1.0 fileEvents:YES];

		[FSHelper scheduleStream:self.stream onRunLoop:Nil];
	}

	return self;
}

- (BOOL)start {
	self.started = [FSHelper startSendingEvents:self.stream];

	return self.started;
}

- (void)stop {
	if (!self.started)
		return;

	[FSHelper stopSendingEvents:self.stream];
}

- (void)dealloc {
	[self stop];

	[FSHelper unscheduleStream:self.stream fromRunLoop:Nil];

	[FSHelper invalidateStream:self.stream];
	[FSHelper releaseStream:self.stream];
}

+ (instancetype)startEventStreamWithURL:(NSURL *)URL handler:(void(^)(NSDictionary *))handler {
	if (!URL || !handler)
		return Nil;

	FSEventStream *instance = [[self alloc] initWithURL:URL handler:handler];
	return [instance start] ? instance : Nil;
}

@end

@implementation FSHelper

+ (FSEventStreamRef)createStream:(NSArray *)URLs callback:(FSEventStreamCallback)callback info:(id)info latency:(NSTimeInterval)latency fileEvents:(BOOL)fileEvents {
	FSEventStreamContext context;
	context.version = 0;
	context.info = (__bridge void *)info;
	context.retain = NULL;
	context.release = NULL;
	context.copyDescription = NULL;

	NSArray *pathsToWatch = [URLs map:^id(NSURL *URL) {
		return URL.path;
	}];
	FSEventStreamCreateFlags flags = kFSEventStreamCreateFlagUseCFTypes;
	if (fileEvents)
		flags |= kFSEventStreamCreateFlagFileEvents;

	return FSEventStreamCreate(kCFAllocatorDefault, callback, &context, (__bridge CFArrayRef)pathsToWatch, kFSEventStreamEventIdSinceNow, latency, flags);
}

+ (void)scheduleStream:(FSEventStreamRef)stream onRunLoop:(CFRunLoopRef)runLoop {
	if (!runLoop)
		runLoop = CFRunLoopGetCurrent();

	FSEventStreamScheduleWithRunLoop(stream, runLoop, kCFRunLoopDefaultMode);
}

+ (BOOL)startSendingEvents:(FSEventStreamRef)stream {
	return FSEventStreamStart(stream);
}

+ (void)stopSendingEvents:(FSEventStreamRef)stream {
	FSEventStreamStop(stream);
}

+ (void)unscheduleStream:(FSEventStreamRef)stream fromRunLoop:(CFRunLoopRef)runLoop {
	if (!runLoop)
		runLoop = CFRunLoopGetCurrent();

	FSEventStreamUnscheduleFromRunLoop(stream, runLoop, kCFRunLoopDefaultMode);
}

+ (void)invalidateStream:(FSEventStreamRef)stream {
	FSEventStreamInvalidate(stream);
}

+ (void)releaseStream:(FSEventStreamRef)stream {
	FSEventStreamRelease(stream);
}

+ (NSString *)streamEventFlagsDescription:(FSEventStreamEventFlags)flags {
	NSMutableArray *array = [NSMutableArray new];

	//	if (flags & kFSEventStreamEventFlagNone)
	//		[array addObject:@"None"];
	if (flags & kFSEventStreamEventFlagMustScanSubDirs)
		[array addObject:@"MustScanSubDirs"];
	if (flags & kFSEventStreamEventFlagUserDropped)
		[array addObject:@"UserDropped"];
	if (flags & kFSEventStreamEventFlagKernelDropped)
		[array addObject:@"KernelDropped"];
	if (flags & kFSEventStreamEventFlagEventIdsWrapped)
		[array addObject:@"EventIdsWrapped"];
	if (flags & kFSEventStreamEventFlagHistoryDone)
		[array addObject:@"HistoryDone"];
	if (flags & kFSEventStreamEventFlagRootChanged)
		[array addObject:@"RootChanged"];
	if (flags & kFSEventStreamEventFlagMount)
		[array addObject:@"Mount"];
	if (flags & kFSEventStreamEventFlagUnmount)
		[array addObject:@"Unmount"];
	if (flags & kFSEventStreamEventFlagItemCreated)
		[array addObject:@"ItemCreated"];
	if (flags & kFSEventStreamEventFlagItemRemoved)
		[array addObject:@"ItemRemoved"];
	if (flags & kFSEventStreamEventFlagItemInodeMetaMod)
		[array addObject:@"ItemInodeMetaMod"];
	if (flags & kFSEventStreamEventFlagItemRenamed)
		[array addObject:@"ItemRenamed"];
	if (flags & kFSEventStreamEventFlagItemModified)
		[array addObject:@"ItemModified"];
	if (flags & kFSEventStreamEventFlagItemFinderInfoMod)
		[array addObject:@"ItemFinderInfoMod"];
	if (flags & kFSEventStreamEventFlagItemChangeOwner)
		[array addObject:@"ItemChangeOwner"];
	if (flags & kFSEventStreamEventFlagItemXattrMod)
		[array addObject:@"ItemXattrMod"];
	if (flags & kFSEventStreamEventFlagItemIsFile)
		[array addObject:@"ItemIsFile"];
	if (flags & kFSEventStreamEventFlagItemIsDir)
		[array addObject:@"ItemIsDir"];
	if (flags & kFSEventStreamEventFlagItemIsSymlink)
		[array addObject:@"ItemIsSymlink"];
	if (flags & kFSEventStreamEventFlagOwnEvent)
		[array addObject:@"OwnEvent"];
	if (flags & kFSEventStreamEventFlagItemIsHardlink)
		[array addObject:@"ItemIsHardlink"];
	if (flags & kFSEventStreamEventFlagItemIsLastHardlink)
		[array addObject:@"ItemIsLastHardlink"];

	return [array componentsJoinedByString:STR_VERTICAL_BAR];
}

@end
