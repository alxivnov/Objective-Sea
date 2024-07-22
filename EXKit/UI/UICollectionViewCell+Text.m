//
//  UICollectionViewCell+Text.m
//  CollectionView
//
//  Created by Alexander Ivanov on 21.11.14.
//  Copyright (c) 2014 Alexander Ivanov. All rights reserved.
//

#import "NSArray+Convenience.h"
#import "UICollectionViewCell+Text.h"

@implementation UICollectionViewCell (Text)

- (UILabel *)text {
	UILabel *text = [self.contentView.subviews firstObject:^BOOL(id item) {
		return [item isKindOfClass:[UILabel class]];
	}];
	
	if (!text) {
		text = [[UILabel alloc] initWithFrame:CGRectIsEmpty(self.contentView.bounds) ? self.bounds : self.contentView.bounds];
		text.textAlignment = NSTextAlignmentCenter;
		
		[self.contentView addSubview:text];
	}
	
	return text;
}

@end
