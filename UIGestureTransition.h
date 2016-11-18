//
//  UIGestureTransitionSnapshot:.h
//  Sleep Diary
//
//  Created by Alexander Ivanov on 12/09/16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UIInteractiveTransition.h"

@interface UIGestureTransition : UIInteractiveTransition

@property (assign, nonatomic, readonly) BOOL shouldSnapshotFromView;
@property (assign, nonatomic, readonly) BOOL shouldSnapshotToView;

@end

@interface UIPanTransition : UIGestureTransition

@end
