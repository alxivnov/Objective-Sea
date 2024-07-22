//
//  XMLParserBase.h
//  Guardian
//
//  Created by Alexander Ivanov on 22.09.14.
//  Copyright (c) 2014 NATEK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSFileManager+Convenience.h"
#import "NSXMLDictionary.h"

@interface NSXMLDictionaryBase : NSObject

@property (strong, nonatomic) NSDictionary *dictionary;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithData:(NSData *)data;

+ (NSString *)fileName;
+ (NSURL *)filePath;

+ (instancetype)createWithContentsOfURL:(NSURL *)url;
+ (instancetype)createWithString:(NSString *)string;

+ (instancetype)readFromURL:(NSURL *)url;
- (void)writeToURL:(NSURL *)url;

@end
