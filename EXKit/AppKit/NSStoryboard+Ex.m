//
//  NSStoryboard+Ex.m
//  Guardian
//
//  Created by Alexander Ivanov on 09.07.15.
//  Copyright (c) 2015 NATEK. All rights reserved.
//

#import "NSStoryboard+Ex.h"

#define GUI_MAIN_STORYBOARD_NAME @"Main"

@implementation NSStoryboard (Ex)

+ (NSStoryboard *)defaultStoryboard {
	return [self storyboardWithName:GUI_MAIN_STORYBOARD_NAME bundle:Nil];
}

- (id)instantiateViewControllerWithIdentifier:(NSString *)identifier {
	id controller = [self instantiateControllerWithIdentifier:identifier];

	return [controller isKindOfClass:[NSViewController class]] ? controller : [controller contentViewController];
}

- (id)instantiateWindowControllerWithIdentifier:(NSString *)identifier {
	id controller = [self instantiateControllerWithIdentifier:identifier];

	return [controller isKindOfClass:[NSWindowController class]] ? controller : Nil;
}

- (id)instantiateInitialViewController {
	id controller = [self instantiateInitialController];

	return [controller isKindOfClass:[NSViewController class]] ? controller : [controller contentViewController];
}

- (id)instantiateInitialWindowController {
	id controller = [self instantiateInitialController];

	return [controller isKindOfClass:[NSWindowController class]] ? controller : Nil;
}

@end
