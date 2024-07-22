//
//  NSWorkspace+Ex.h
//  Guardian
//
//  Created by Alexander Ivanov on 13/07/16.
//  Copyright © 2016 NATEK. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSWorkspace (Ex)

- (void)activateFileViewerSelectingURL:(NSURL *)fileURL;

@end
