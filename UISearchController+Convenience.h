//
//  UISearchController+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 20.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (UISearchController)

@property (strong, nonatomic) id <UISearchResultsUpdating> searchResultsUpdater;

@end

@interface UISearchResultsUpdater : UISearchController <UISearchResultsUpdating>

@property (strong, nonatomic) void(^searchResultsHandler)(NSString *text);

+ (instancetype)updaterWithSearchResultsHandler:(void(^)(NSString *text))handler;

@end

@interface UITableViewController (Search)

- (UISearchController *)searchController:(id<UISearchResultsUpdating>)updater;

- (UISearchController *)searchControllerWithHandler:(void(^)(NSString *text))handler;

@end
