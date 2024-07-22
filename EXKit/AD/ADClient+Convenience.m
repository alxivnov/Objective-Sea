//
//  ADClient+Convenience.m
//  Air Tasks
//
//  Created by Alexander Ivanov on 22.06.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import "ADClient+Convenience.h"

@implementation ADClient (Convenience)

- (void)addClientToSegment:(NSString *)segmentIdentifier replaceExisting:(BOOL)replaceExisting {
	if (segmentIdentifier.length > 0 && [self respondsToSelector:@selector(addClientToSegments:replaceExisting:)])
		[self addClientToSegments:@[ segmentIdentifier ] replaceExisting:replaceExisting];
}

@end
