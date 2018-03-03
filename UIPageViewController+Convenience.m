//
//  UIPageViewController+Convenience.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 02.03.2018.
//  Copyright © 2018 Alexander Ivanov. All rights reserved.
//

#import "UIPageViewController+Convenience.h"

@implementation UIPageViewController (Convenience)

- (void)setViewController:(UIViewController *)viewController direction:(UIPageViewControllerNavigationDirection)direction animated:(BOOL)animated completion:(void (^)(BOOL))completion {
	if (!viewController)
		return;

	[self setViewControllers:@[ viewController ] direction:direction animated:animated completion:completion];
}

@end

@interface UIPagingController ()

@end

@implementation UIPagingController

- (UIViewController *)viewControllerForIndex:(NSUInteger)index {
	return Nil;
}

- (NSUInteger)indexForViewController:(UIViewController *)viewController {
	return NSNotFound;
}

- (NSUInteger)numberOfPages {
	return [self respondsToSelector:@selector(presentationCountForPageViewController:)] ? [self presentationCountForPageViewController:self] : NSNotFound;
}

- (NSUInteger)currentPage {
	return [self indexForViewController:self.viewControllers.firstObject];
}

- (void)setCurrentPage:(NSUInteger)currentPage animated:(BOOL)animated completion:(void (^)(BOOL))completion {
	[self setViewController:[self viewControllerForIndex:currentPage] direction:self.currentPage < currentPage ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse animated:animated completion:completion];
}

- (void)setCurrentPage:(NSUInteger)currentPage {
	[self setCurrentPage:currentPage animated:NO completion:Nil];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.

	self.dataSource = self;
	self.delegate = self;

	[self setViewController:[self viewControllerForIndex:[self currentPage]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:Nil];
	[self pageViewController:self didFinishAnimating:YES previousViewControllers:@[ ] transitionCompleted:YES];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
	NSUInteger index = [self indexForViewController:viewController];

	return [self viewControllerForIndex:index + 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
	NSUInteger index = [self indexForViewController:viewController];

	return [self viewControllerForIndex:index - 1];
}
/*
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
	return self.numberOfPages;
}
*/
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
	return [self indexForViewController:pageViewController.viewControllers.firstObject];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
	if (!completed)
		return;

	self.navigationItem.title = self.viewControllers.firstObject.navigationItem.title;
	self.navigationItem.rightBarButtonItems = self.viewControllers.firstObject.navigationItem.rightBarButtonItems;
	self.toolbarItems = self.viewControllers.firstObject.toolbarItems;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
