//
//  ASHelper.m
//  Done!
//
//  Created by Alexander Ivanov on 13.06.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

@import AudioToolbox;

#import "ASHelper.h"

@implementation ASHelper

static NSMutableArray *_sounds;

+ (NSMutableArray *)sounds {
	if (!_sounds)
		_sounds = [NSMutableArray array];
	
	return _sounds;
}

static void disposeSystemSound(SystemSoundID systemSoundID, void *inClientData) {
	AudioServicesRemoveSystemSoundCompletion(systemSoundID);
	AudioServicesDisposeSystemSoundID(systemSoundID);
}

+ (void)playResource:(NSString *)name {
	NSArray *array = [name componentsSeparatedByString:@"."];
	NSURL *url = [[NSBundle mainBundle] URLForResource:array.count > 0 ? array[0] : Nil withExtension:array.count > 1 ? array[1] : Nil];
	[self play:url];
}

+ (void)play:(NSURL *)path {
	if (!path)
		return;

	SystemSoundID sound = 0;
	
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)path, &sound);
	
	if (!sound)
		return;
	
	AudioServicesAddSystemSoundCompletion(sound, NULL, NULL, disposeSystemSound, NULL);
	
	AudioServicesPlaySystemSound(sound);
	
	[[self sounds] addObject:@(sound)];
}

+ (void)stop {
	NSNumber *sound = [[self sounds] lastObject];
	if (!sound)
		return;
	
	[[self sounds] removeLastObject];
	
	disposeSystemSound(sound.unsignedIntValue, Nil);
}

+ (void)stopAll {
	NSArray *sounds = [[self sounds] copy];
	if (![sounds count])
		return;
	
	[[self sounds] removeAllObjects];
	
	for (NSNumber *sound in sounds)
		disposeSystemSound(sound.unsignedIntValue, Nil);
}

@end
