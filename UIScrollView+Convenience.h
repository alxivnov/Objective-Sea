//
//  UICenteredScrollView+Convenience.h
//  Poisk
//
//  Created by Alexander Ivanov on 15.06.17.
//  Copyright © 2017 Pine 9. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UICenteredScrollViewTag 'scrl'

@interface UIScrollView (Convenience)

@property (assign, nonatomic, readonly) CGFloat fillZoom;
@property (assign, nonatomic, readonly) CGFloat fitZoom;

@end

@interface UICenteredScrollView : UIScrollView

@end
