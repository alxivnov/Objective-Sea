//
//  Compression+Convenience.h
//  Trend
//
//  Created by Alexander Ivanov on 11.10.2017.
//  Copyright © 2017 Pine 9. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Compression;

@interface NSData (Compression)

- (NSData *)compress:(compression_algorithm)algorithm;
- (NSData *)decompress:(compression_algorithm)algorithm;

@end
