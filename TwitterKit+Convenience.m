//
//  TwitterKit+Convenience.m
//  Ringtonic
//
//  Created by Alexander Ivanov on 29.05.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import "TwitterKit+Convenience.h"

@interface TWComposer () <TWTRComposerViewControllerDelegate>
@property (copy, nonatomic) TWTRComposerCompletion completion;
@end

@implementation TWComposer

static NSMutableArray *_composers;

+ (NSMutableArray *)composers {
	if (!_composers)
		_composers = [NSMutableArray array];

	return _composers;
}

- (void)composerDidCancel:(TWTRComposerViewController *)controller {
	[[[self class] composers] removeObject:self];

	if (self.completion)
		self.completion(TWTRComposerResultCancelled);
}

- (void)composerDidSucceed:(TWTRComposerViewController *)controller withTweet:(TWTRTweet *)tweet {
	[[[self class] composers] removeObject:self];

	if (self.completion)
		self.completion(TWTRComposerResultDone);
}

- (void)composerDidFail:(TWTRComposerViewController *)controller withError:(NSError *)error {
	[[[self class] composers] removeObject:self];

	if (self.completion)
		self.completion(TWTRComposerResultCancelled);

	if (error)
		NSLog(@"composerDidFail: %@", [error debugDescription]);
}

- (void)showFromViewController:(UIViewController *)fromController completion:(TWTRComposerCompletion)completion {
	[[[self class] composers] addObject:self];

	self.completion = completion;

	if ([[Twitter sharedInstance].sessionStore hasLoggedInUsers]) {
		TWTRComposerViewController *composer = [[TWTRComposerViewController alloc] initWithInitialText:self.text && self.URL ? self.text.length + self.URL.absoluteString.length < 140 ? [NSString stringWithFormat:@"%@ %@", self.text, self.URL] : self.URL.absoluteString : self.text ? self.text : self.URL.absoluteString image:self.image videoURL:Nil];
		composer.delegate = self;

		[fromController presentViewController:composer animated:YES completion:Nil];
	} else {
		[[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
			if (session) {
				TWTRComposerViewController *composer = [[TWTRComposerViewController alloc] initWithInitialText:self.text && self.URL ? self.text.length + self.URL.absoluteString.length < 140 ? [NSString stringWithFormat:@"%@ %@", self.text, self.URL] : self.URL.absoluteString : self.text ? self.text : self.URL.absoluteString image:self.image videoURL:Nil];
				composer.delegate = self;

				[fromController presentViewController:composer animated:YES completion:Nil];
			}

			if (error)
				NSLog(@"logInWithCompletion: %@", [error debugDescription]);
		}];
	}
}

@end
