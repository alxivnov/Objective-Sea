//
//  UIBarButtonItem+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 12/09/16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UIBarButtonItem+Convenience.h"

@implementation UIBarButtonItem (Convenience)

- (UIView *)buttonView {
	return cls(UIView, [self tryGetValueForKey:@"view"]);
}

@end
