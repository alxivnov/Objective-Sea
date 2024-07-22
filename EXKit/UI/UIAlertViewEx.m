//
//  UIAlertViewEx.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 22.06.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "UIAlertViewEx.h"
#import "UIAlertController+Convenience.h"

@interface UIAlertViewEx ()
@property (copy, nonatomic) void(^completion)(UIAlertView *sender, NSInteger index);

@property (strong, nonatomic) NSString *cancelButtonTitle;
@property (strong, nonatomic) NSString *destructiveButtonTitle;
@property (strong, nonatomic) NSArray *otherButtonTitles;
@end

@implementation UIAlertViewEx

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles completion:(void(^)(UIAlertView *, NSInteger))completion {
	self = [super initWithTitle:title message:message delegate:Nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:Nil];
	
	if (self) {
		self.completion = completion;
		self.cancelButtonTitle = cancelButtonTitle;
		self.destructiveButtonTitle = destructiveButtonTitle;
		self.otherButtonTitles = otherButtonTitles;
		
		self.delegate = self;
		
		if (otherButtonTitles.count)
			for (NSString *title in otherButtonTitles)
				[self addButtonWithTitle:title];
		if (destructiveButtonTitle)
			[self addButtonWithTitle:destructiveButtonTitle];
	}
	
	return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (!self.completion)
		return;
	
	NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
	NSInteger index = [self.cancelButtonTitle isEqualToString:title] ? UIAlertActionCancel : [self.destructiveButtonTitle isEqualToString:title] ? UIAlertActionDestructive : [self.otherButtonTitles first:^BOOL(id item) {
		return [item isEqualToString:title];
	}];
	if (index == NSNotFound)
		return;
	
	self.completion(alertView, index);
}

@end
