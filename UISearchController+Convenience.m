//
//  UISearchController+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 20.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "UISearchController+Convenience.h"

@implementation UISearchResultsUpdater

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
	if (self.searchResultsHandler)
		self.searchResultsHandler(searchController.searchBar.text);
}

- (instancetype)initWithSearchResultsController:(UIViewController *)searchResultsController {
	self = [super initWithSearchResultsController:searchResultsController];

	if (self)
		self.searchResultsUpdater = self;

	return self;
}

+ (instancetype)updaterWithSearchResultsHandler:(void (^)(NSString *))handler {
	UISearchResultsUpdater *instance = [[UISearchResultsUpdater alloc] initWithSearchResultsController:Nil];
	instance.searchResultsHandler = handler;

	instance.dimsBackgroundDuringPresentation = NO;
	instance.hidesNavigationBarDuringPresentation = NO;

	return instance;
}

@end

@implementation UITableViewController (Search)

- (UISearchController *)searchController:(id<UISearchResultsUpdating>)updater {
	UISearchController *search = [[UISearchController alloc] initWithSearchResultsController:Nil];
	search.searchResultsUpdater = updater;

	[search.searchBar sizeToFit];
	self.tableView.tableHeaderView = search.searchBar;

	return search;
}

- (UISearchController *)searchControllerWithHandler:(void (^)(NSString *))handler {
	UISearchResultsUpdater *search = [UISearchResultsUpdater updaterWithSearchResultsHandler:handler];

	[search.searchBar sizeToFit];
	self.tableView.tableHeaderView = search.searchBar;

	search.delegate = (id<UISearchControllerDelegate>)self;
	[search.searchBar setShowsCancelButton:NO animated:NO];

	return search;
}

- (void)didPresentSearchController:(UISearchController *)searchController {
	self.tableView.tableHeaderView = searchController.searchBar;
//	[self.tableView.tableHeaderView becomeFirstResponder];
}

- (void)didDismissSearchController:(UISearchController *)searchController {
	self.tableView.tableHeaderView = searchController.searchBar;
//	[self.tableView.tableHeaderView resignFirstResponder];
}

@end
