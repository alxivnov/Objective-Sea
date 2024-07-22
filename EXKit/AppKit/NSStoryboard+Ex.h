//
//  NSStoryboard+Ex.h
//  Guardian
//
//  Created by Alexander Ivanov on 09.07.15.
//  Copyright (c) 2015 NATEK. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSStoryboard (Ex)

+ (NSStoryboard *)defaultStoryboard;

- (NSViewController *)instantiateViewControllerWithIdentifier:(NSString *)identifier;
- (NSWindowController *)instantiateWindowControllerWithIdentifier:(NSString *)identifier;

- (NSViewController *)instantiateInitialViewController;
- (NSWindowController *)instantiateInitialWindowController;

@end
