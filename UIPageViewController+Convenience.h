//
//  UIPageViewController+Convenience.h
//  Sleep Diary
//
//  Created by Alexander Ivanov on 02.03.2018.
//  Copyright © 2018 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPageViewController (Convenience)

- (void)setViewController:(UIViewController *)viewController direction:(UIPageViewControllerNavigationDirection)direction animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

@end

@interface UIPagingController : UIPageViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

- (UIViewController *)viewControllerForIndex:(NSUInteger)index;
- (NSUInteger)indexForViewController:(UIViewController *)viewController;

@property (assign, nonatomic, readonly) NSUInteger numberOfPages;
@property (assign, nonatomic) NSUInteger currentPage;
- (void)setCurrentPage:(NSUInteger)currentPage animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

@end
