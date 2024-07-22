//
//  UIPinchTransition.h
//  Done!
//
//  Created by Alexander Ivanov on 08.06.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UIGestureTransition.h"

@interface UIPinchTransition : UIGestureTransition

+ (UIPinchTransition *)animatedPinchIn:(NSTimeInterval)duration;

+ (UIPinchTransition *)animatedPinchOut:(NSTimeInterval)duration;

+ (UIPinchTransition *)interactivePinchIn:(id <UIInteractiveTransitionDelegate>)delegate recognizer:(UIGestureRecognizer *)recognizer;

+ (UIPinchTransition *)interactivePinchOut:(id <UIInteractiveTransitionDelegate>)delegate recognizer:(UIGestureRecognizer *)recognizer;

@end
