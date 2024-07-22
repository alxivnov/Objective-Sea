//
//  NSURL+Ex.m
//  Guardian
//
//  Created by Alexander Ivanov on 20.07.15.
//  Copyright © 2015 NATEK. All rights reserved.
//

@import AppKit;

#import "NSURL+Ex.h"

@implementation NSURL (Ex)

- (BOOL)setIcon:(NSImage *)image {
	return [[NSWorkspace sharedWorkspace] setIcon:image forFile:self.path options:NSExcludeQuickDrawElementsIconCreationOption];
}

@end
