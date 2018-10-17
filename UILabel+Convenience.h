//
//  UILabel+Convenience.h
//  Sleep Diary
//
//  Created by Alexander Ivanov on 19.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Convenience)

- (void)autoWidth;
- (void)autoHeight;

- (BOOL)autoSize:(CGSize)plus;
- (BOOL)autoSize;

@property (strong, nonatomic, readonly) UIFont *systemFont;
@property (strong, nonatomic, readonly) UIFont *boldSystemFont;
@property (strong, nonatomic, readonly) UIFont *italicSystemFont;

@end

typedef enum : NSUInteger {
	NSSizeExact,
	NSSizeLessThan,
	NSSizeGreaterThan,
} NSSizeOptions;

@interface NSAttributedString (UILabel)

- (UILabel *)labelWithSize:(CGSize)size options:(NSSizeOptions)flag;
- (UILabel *)labelWithSize:(CGSize)size;
- (UILabel *)label;

@end

@interface NSString (UILabel)

- (UILabel *)labelWithSize:(CGSize)size options:(NSSizeOptions)flag attributes:(NSDictionary<NSString *, id> *)attributes;
- (UILabel *)labelWithSize:(CGSize)size options:(NSSizeOptions)flag;
- (UILabel *)labelWithSize:(CGSize)size;
- (UILabel *)label;

@end
