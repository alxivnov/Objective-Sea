//
//  ASHelper.h
//  Done!
//
//  Created by Alexander Ivanov on 13.06.14.
//  Copyright (c) 2014 Alex Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASHelper : NSObject

+ (void)playResource:(NSString *)name;
+ (void)play:(NSURL *)path;

+ (void)stop;
+ (void)stopAll;

@end
