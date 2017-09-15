//
//  SafariServices+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 20.04.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import "SafariServices+Convenience.h"

@implementation UIViewController (SafariServices)

- (SFSafariViewController *)presentSafariWithURL:(NSURL *)url entersReaderIfAvailable:(BOOL)entersReaderIfAvailable animated:(BOOL)flag completion:(void (^)(void))completion {
	if (!url)
		return Nil;

	SFSafariViewController *safari = [[SFSafariViewController alloc] initWithURL:url /*entersReaderIfAvailable:entersReaderIfAvailable*/];
//	safari.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	safari.modalPresentationStyle = UIModalPresentationPageSheet;

	[self presentViewController:safari animated:flag completion:completion];

	return safari;
}

- (SFSafariViewController *)presentSafariWithURL:(NSURL *)url entersReaderIfAvailable:(BOOL)entersReaderIfAvailable animated:(BOOL)flag {
	return [self presentSafariWithURL:url entersReaderIfAvailable:NO animated:flag completion:Nil];
}

- (SFSafariViewController *)presentSafariWithURL:(NSURL *)url entersReaderIfAvailable:(BOOL)entersReaderIfAvailable {
	return [self presentSafariWithURL:url entersReaderIfAvailable:entersReaderIfAvailable animated:YES completion:Nil];
}

- (SFSafariViewController *)presentSafariWithURL:(NSURL *)url {
	return [self presentSafariWithURL:url entersReaderIfAvailable:NO animated:YES completion:Nil];
}

@end
