//
//  UIViewController+Convenience.h
//  Crowd Guard
//
//  Created by Alexander Ivanov on 13.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIViewControllerNextTarget(break) ^id(id target, BOOL responds, id returnValue) { return break && responds ? Nil : [target nextViewController]; }

@interface UIViewController (Convenience)

@property (strong, nonatomic, readonly) UIViewController *nextViewController;

@end
