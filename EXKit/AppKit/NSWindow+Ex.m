//
//  NSWindow+Ex.m
//  Guardian
//
//  Created by Alexander Ivanov on 10.08.15.
//  Copyright (c) 2015 NATEK. All rights reserved.
//

#import "NSWindow+Ex.h"

@implementation NSWindow (Ex)

- (BOOL)endSheetWithReturnCode:(NSModalResponse)returnCode {
	if (!self.sheet)
		return NO;
	
	[self.sheetParent endSheet:self returnCode:returnCode];
	return YES;
}

- (BOOL)endSheet {
	return [self endSheetWithReturnCode:NSModalResponseCancel];
}

@end
