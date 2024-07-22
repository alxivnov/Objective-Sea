//
//  AppKitEx.h
//  Guardian
//
//  Created by Alexander Ivanov on 09.07.15.
//  Copyright (c) 2015 NATEK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSAlert+Ex.h"
#import "NSImage+Ex.h"
#import "NSResponder+Ex.h"
#import "NSStoryboard+Ex.h"
#import "NSURL+Ex.m"
#import "NSView+Ex.h"
#import "NSWindow+Ex.h"
#import "NSWindowController+Ex.h"
#import "NSWorkspace+Ex.h"

#define ALPHA 1.0
#define RGB_MAX 255.0

#define RGBA(r, g, b, a) [NSColor colorWithRed:r/RGB_MAX green:g/RGB_MAX blue:b/RGB_MAX alpha:a/100.0]
#define RGB(r, g, b) [NSColor colorWithRed:r/RGB_MAX green:g/RGB_MAX blue:b/RGB_MAX alpha:ALPHA]
