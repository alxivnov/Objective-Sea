//
//  NSXMLDictionary.m
//  Guardian
//
//  Created by Alexander Ivanov on 26.08.14.
//  Copyright (c) 2014 NATEK. All rights reserved.
//

#import "NSXMLDictionary.h"

@interface NSXMLDictionary ()
@property (strong, nonatomic) NSMutableDictionary *dictionary;
@property (strong, nonatomic) NSMutableDictionary *currentDic;

@property (assign, nonatomic) NSUInteger index;
@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) NSString *elementName;
@end

@implementation NSXMLDictionary

- (NSMutableDictionary *)dictionary {
	if (!_dictionary)
		_dictionary = [[NSMutableDictionary alloc] init];

	return _dictionary;
}

- (NSMutableArray *)array {
	if (!_array)
		_array = [[NSMutableArray alloc] init];

	return _array;
}

- (NSString *)elementName {
	return self.index ? self.array[self.index - 1] : Nil;
}

- (void)setElementName:(NSString *)elementName {
	NSUInteger count = 0;

	if (elementName) {
		NSString *current = [self.array count] > self.index ? self.array[self.index] : Nil;
		if ([current isEqualToString:elementName]) {
			NSObject *temp = self.currentDic[current];
			if (![temp isKindOfClass:[NSMutableArray class]])
				self.currentDic[current] = temp = temp ? [NSMutableArray arrayWithObject:temp] : Nil;
			[(NSMutableArray *)temp addObject:[NSMutableDictionary dictionary]];
		}

		self.array[self.index] = elementName;

		count = ++self.index;
	} else {
		if (self.index + 1 < [self.array count])
			[self.array removeObjectAtIndex:self.index + 1];

		count = self.index--;
	}

	NSMutableDictionary *temp = self.dictionary;
	if (count > 2) {
		count--;

		for (NSUInteger index = 1; index < count; index++) {
			NSString *elementName = self.array[index];

			NSObject *value = temp[elementName];
			if ([value isKindOfClass:[NSMutableArray class]]) {
				value = [(NSMutableArray *)value lastObject];
			} else if (![value isKindOfClass:[NSMutableDictionary class]]) {
				value = [[NSMutableDictionary alloc] init];
				temp[elementName] = value;
			}
			temp = (NSMutableDictionary *)value;
		}
	}

	self.currentDic = temp;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	self.elementName = elementName;

	if (attributeDict.count)
		self.currentDic[self.elementName] = [NSMutableDictionary dictionaryWithObject:attributeDict forKey:@"<attributes>"];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (!self.elementName || ![[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length])
		return;

	NSMutableString *value = self.currentDic[self.elementName];
	if (value)
		[value appendString:string];
	else
		value = [NSMutableString stringWithString:string];
	self.currentDic[self.elementName] = value;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	self.elementName = Nil;
}

+ (NSDictionary *)parseData:(NSData *)data {
	NSXMLDictionary *xml = [[NSXMLDictionary alloc] init];
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	parser.delegate = xml;
	BOOL r = [parser parse];
	return r ? xml.dictionary : [[NSDictionary alloc] init];
}

+ (NSDictionary *)parseContentsOfURL:(NSURL *)url {
	NSData *data = [NSData dataWithContentsOfURL:url];
	
	return [self parseData:data];
}

+ (NSDictionary *)parseString:(NSString *)string {
	NSData *data = [string dataUsingEncoding:NSUnicodeStringEncoding];
	
	return [self parseData:data];
}

@end
