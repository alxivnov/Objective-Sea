//
//  UIStepper+Convenience.m
//  Watch Extension
//
//  Created by Alexander Ivanov on 19.04.2020.
//  Copyright © 2020 Alexander Ivanov. All rights reserved.
//

#import "UIStepper+Convenience.h"

@implementation UIStepper (Convenience)

- (void)resetImagesForState:(UIControlState)state {
	[self setDecrementImage:[self decrementImageForState:state] forState:state];
	[self setIncrementImage:[self incrementImageForState:state] forState:state];
}

- (void)resetImages {
	[self resetImagesForState:UIControlStateNormal];
}

@end
