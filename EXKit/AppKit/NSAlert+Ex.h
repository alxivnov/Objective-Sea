//
//  NSAlert+Ex.h
//  Guardian
//
//  Created by Alexander Ivanov on 15.07.15.
//  Copyright © 2015 NATEK. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSAlert (Ex)

+ (instancetype)runWarningAlertWithMessageText:(NSString *)message defaultButton:(NSString *)defaultButton alternateButton:(NSString *)alternateButton otherButton:(NSString *)otherButton informativeText:(NSString *)informative;
+ (instancetype)runWarningAlertWithMessageText:(NSString *)message defaultButton:(NSString *)defaultButton;

+ (instancetype)runInformationalAlertWithMessageText:(NSString *)message defaultButton:(NSString *)defaultButton alternateButton:(NSString *)alternateButton otherButton:(NSString *)otherButton informativeText:(NSString *)informative;
+ (instancetype)runInformationalAlertWithMessageText:(NSString *)message defaultButton:(NSString *)defaultButton;

+ (instancetype)runCriticalAlertWithMessageText:(NSString *)message defaultButton:(NSString *)defaultButton alternateButton:(NSString *)alternateButton otherButton:(NSString *)otherButton informativeText:(NSString *)informative;
+ (instancetype)runCriticalAlertWithMessageText:(NSString *)message defaultButton:(NSString *)defaultButton;

@end
