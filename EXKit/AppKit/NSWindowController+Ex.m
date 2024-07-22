//
//  NSWindowController+Ex.m
//  Guardian
//
//  Created by Alexander Ivanov on 10.08.15.
//  Copyright (c) 2015 NATEK. All rights reserved.
//

#import "NSWindowController+Ex.h"

@implementation NSWindowController (Ex)

- (void)beginSheet:(NSWindowController *)sheetWindowController completionHandler:(void (^)(NSModalResponse))handler {
	[self.window beginSheet:sheetWindowController.window completionHandler:handler];
}

@end
