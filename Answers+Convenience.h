//
//  Answers+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 18.07.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import <Crashlytics/Crashlytics.h>

#import "NSDictionary+Convenience.h"

@interface Answers (Convenience)

+ (void)logError:(NSError *)error;

@end
