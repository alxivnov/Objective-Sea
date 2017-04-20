//
//  SafariServices+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 20.04.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import "SafariServices+Convenience.h"

@implementation UIViewController (SafariServices)

- (SFSafariViewController *)presentSafariWithURL:(NSURL *)url entersReaderIfAvailable:(BOOL)entersReaderIfAvailable {
	if (!url)
		return Nil;

	SFSafariViewController *safari = [[SFSafariViewController alloc] initWithURL:url entersReaderIfAvailable:entersReaderIfAvailable];
//	safari.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	safari.modalPresentationStyle = UIModalPresentationPageSheet;

	[self presentViewController:safari animated:YES completion:Nil];

	return safari;
}

- (SFSafariViewController *)presentSafariWithURL:(NSURL *)url {
	return [self presentSafariWithURL:url entersReaderIfAvailable:NO];
}

@end
