//
//  NSWorkspace+Ex.m
//  Guardian
//
//  Created by Alexander Ivanov on 13/07/16.
//  Copyright © 2016 NATEK. All rights reserved.
//

#import "NSWorkspace+Ex.h"

@implementation NSWorkspace (Ex)

- (void)activateFileViewerSelectingURL:(NSURL *)fileURL {
	if (fileURL)
		[self activateFileViewerSelectingURLs:@[ fileURL ]];
}

@end
