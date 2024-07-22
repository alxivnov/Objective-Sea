//
//  NSAlert+Ex.m
//  Guardian
//
//  Created by Alexander Ivanov on 15.07.15.
//  Copyright © 2015 NATEK. All rights reserved.
//

#import "NSAlert+Ex.h"

@implementation NSAlert (Ex)

- (instancetype)initWithAlertStyle:(NSAlertStyle)style messageText:(NSString *)message defaultButton:(NSString *)defaultButton alternateButton:(NSString *)alternateButton otherButton:(NSString *)otherButton informativeText:(NSString *)informative {
	self = [self init];
	
	if (self) {
		self.alertStyle = style;
		
		if (message)
			self.messageText = message;
		if (defaultButton)
			[self addButtonWithTitle:defaultButton];
		if (alternateButton)
			[self addButtonWithTitle:alternateButton];
		if (otherButton)
			[self addButtonWithTitle:otherButton];
		if (informative)
			self.informativeText = informative;
	}
	
	return self;
}

+ (instancetype)runWarningAlertWithMessageText:(NSString *)message defaultButton:(NSString *)defaultButton alternateButton:(NSString *)alternateButton otherButton:(NSString *)otherButton informativeText:(NSString *)informative {
	if (!message)
		return Nil;
	
	NSAlert *instance = [[self alloc] initWithAlertStyle:NSWarningAlertStyle messageText:message defaultButton:defaultButton alternateButton:alternateButton otherButton:otherButton informativeText:informative];
	[instance runModal];
	return instance;
}

+ (instancetype)runWarningAlertWithMessageText:(NSString *)message defaultButton:(NSString *)defaultButton {
	return [self runWarningAlertWithMessageText:message defaultButton:defaultButton alternateButton:Nil otherButton:Nil informativeText:Nil];
}

+ (instancetype)runInformationalAlertWithMessageText:(NSString *)message defaultButton:(NSString *)defaultButton alternateButton:(NSString *)alternateButton otherButton:(NSString *)otherButton informativeText:(NSString *)informative {
	if (!message)
		return Nil;
	
	NSAlert *instance = [[self alloc] initWithAlertStyle:NSInformationalAlertStyle messageText:message defaultButton:defaultButton alternateButton:alternateButton otherButton:otherButton informativeText:informative];
	[instance runModal];
	return instance;
}

+ (instancetype)runInformationalAlertWithMessageText:(NSString *)message defaultButton:(NSString *)defaultButton {
	return [self runInformationalAlertWithMessageText:message defaultButton:defaultButton alternateButton:Nil otherButton:Nil informativeText:Nil];
}

+ (instancetype)runCriticalAlertWithMessageText:(NSString *)message defaultButton:(NSString *)defaultButton alternateButton:(NSString *)alternateButton otherButton:(NSString *)otherButton informativeText:(NSString *)informative {
	if (!message)
		return Nil;
	
	NSAlert *instance = [[self alloc] initWithAlertStyle:NSCriticalAlertStyle messageText:message defaultButton:defaultButton alternateButton:alternateButton otherButton:otherButton informativeText:informative];
	[instance runModal];
	return instance;
}

+ (instancetype)runCriticalAlertWithMessageText:(NSString *)message defaultButton:(NSString *)defaultButton {
	return [self runCriticalAlertWithMessageText:message defaultButton:defaultButton alternateButton:Nil otherButton:Nil informativeText:Nil];
}

@end
