//
//  NSXMLDictionary.h
//  Guardian
//
//  Created by Alexander Ivanov on 26.08.14.
//  Copyright (c) 2014 NATEK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSXMLDictionary : NSObject <NSXMLParserDelegate>

+ (NSDictionary *)parseData:(NSData *)data;

+ (NSDictionary *)parseContentsOfURL:(NSURL *)url;

+ (NSDictionary *)parseString:(NSString *)string;

@end
