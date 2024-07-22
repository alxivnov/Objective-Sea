//
//  NSWindow+Ex.h
//  Guardian
//
//  Created by Alexander Ivanov on 10.08.15.
//  Copyright (c) 2015 NATEK. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSWindow (Ex)

- (BOOL)endSheetWithReturnCode:(NSModalResponse)returnCode;
- (BOOL)endSheet;

@end
