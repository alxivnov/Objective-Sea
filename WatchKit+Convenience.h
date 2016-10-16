//
//  WatchKit+Convenience.h
//  Sleep Diary
//
//  Created by Alexander Ivanov on 14.10.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <WatchKit/WatchKit.h>

@interface WKInterfaceTable (Convenience)

- (void)setRows:(NSDictionary *)dictionary;

@end

@interface WKInterfaceTimer (Convenience)

- (void)setInterval:(NSTimeInterval)interval;

@end
