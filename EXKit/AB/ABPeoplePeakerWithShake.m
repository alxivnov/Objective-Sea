//
//  ABPeoplePeakerWithShake.m
//  Done!
//
//  Created by Alexander Ivanov on 04.06.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import "ABPeoplePeakerWithShake.h"
#import "PannableBasket.h"

@implementation ABPeoplePeakerWithShake

+ (instancetype)create:(id <ABPeoplePickerNavigationControllerDelegate>)delegate {
	ABPeoplePeakerWithShake *instance = [[ABPeoplePeakerWithShake alloc] init];
	instance.peoplePickerDelegate = delegate;
	return instance;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (motion == UIEventSubtypeMotionShake)
		[self.peoplePickerDelegate peoplePickerNavigationControllerDidCancel:self];
}

@end
