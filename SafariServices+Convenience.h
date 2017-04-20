//
//  SafariServices+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 20.04.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import <SafariServices/SafariServices.h>

@interface UIViewController (SafariServices)

- (SFSafariViewController *)presentSafariWithURL:(NSURL *)url entersReaderIfAvailable:(BOOL)entersReaderIfAvailable;
- (SFSafariViewController *)presentSafariWithURL:(NSURL *)url;

@end
