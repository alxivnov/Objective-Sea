//
//  ADClient+Convenience.h
//  Air Tasks
//
//  Created by Alexander Ivanov on 22.06.15.
//  Copyright (c) 2015 Alex Ivanov. All rights reserved.
//

#import <iAd/iAd.h>

@interface ADClient (Convenience)

- (void)addClientToSegment:(NSString *)segmentIdentifier replaceExisting:(BOOL)replaceExisting;

@end
