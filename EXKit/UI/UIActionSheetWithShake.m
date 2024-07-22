//
//  UIActionSheetWithShake.m
//  Done!
//
//  Created by Alexander Ivanov on 04.06.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "UIActionSheetWithShake.h"

@implementation UIActionSheetWithShake
/*
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
	[super dismissWithClickedButtonIndex:buttonIndex animated:YES];
		
	if ([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)])
		[self.delegate actionSheet:self clickedButtonAtIndex:buttonIndex];
}
*/
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (motion == UIEventSubtypeMotionShake) {
		[self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:YES];
		
		if ([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)])
			[self.delegate actionSheet:self clickedButtonAtIndex:self.cancelButtonIndex];
	}
}

@end
