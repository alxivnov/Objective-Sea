//
//  CoreGraphics+Convenience.h
//  Ringtonic
//
//  Created by Alexander Ivanov on 15.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>

#define CGPointIsZero(point) CGPointEqualToPoint(point, CGPointZero)
#define CGSizeIsZero(size) CGSizeEqualToSize(size, CGSizeZero)
#define CGRectIsZero(rect) CGRectEqualToRect(rect, CGRectZero)

#define CGPointIsFinite(point) (isfinite(point.x) && isfinite(point.y))
#define CGSizeIsFinite(size) (isfinite(size.width) && isfinite(size.height))
#define CGRectIsFinite(rect) (isfinite(rect.origin.x) && isfinite(rect.origin.y) && isfinite(rect.size.width) && isfinite(rect.size.height))

#define CGPointDecription(point) [NSString stringWithFormat:@"{ x : %f, y : %f }", point.x, point.y]
#define CGSizeDescription(size) [NSString stringWithFormat:@"{ width : %f, height : %f }", size.width, size.height]
#define CGRectDescription(rect)  [NSString stringWithFormat:@"{ origin : { x : %f, y : %f }, size : { width : %f, height : %f } }", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height]

#define CGRectMakeWithOriginAndSize(origin, size) CGRectMake(origin.x, origin.y, size.width, size.height)
#define CGRectMakeWithSize(size) CGRectMakeWithOriginAndSize(CGPointZero, size)

#define CGRectIsHorizontal(rect) (rect.size.height < rect.size.width)
#define CGRectIsVertical(rect) (rect.size.height > rect.size.width)

#define CGRectRotate(rect) CGRectMake(rect.origin.x, rect.origin.y, rect.size.height, rect.size.width)

#define CGRectSetOrigin(rect, origin) CGRectMake(origin.x, origin.y, rect.size.width, rect.size.height)
#define CGRectSetSize(rect, size) CGRectMake(rect.origin.x, rect.origin.y, size.width, size.height)
#define CGRectSetX(rect, x) CGRectMake(x, rect.origin.y, rect.size.width, rect.size.height)
#define CGRectSetY(rect, y) CGRectMake(rect.origin.x, y, rect.size.width, rect.size.height)
#define CGRectSetWidth(rect, width) CGRectMake(rect.origin.x, rect.origin.y, width, rect.size.height)
#define CGRectSetHeight(rect, height) CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, height)

#define CGRectOffsetOrigin(rect, Origin) CGRectMake(rect.origin.x + Origin.x, rect.origin.y + Origin.y, rect.size.width, rect.size.height)
#define CGRectOffsetSize(rect, Size) CGRectMake(rect.origin.x, rect.origin.y, rect.size.width + Size.width, rect.size.height + Size.height)
#define CGRectOffsetX(rect, X) CGRectMake(rect.origin.x + X, rect.origin.y, rect.size.width, rect.size.height)
#define CGRectOffsetY(rect, Y) CGRectMake(rect.origin.x, rect.origin.y + Y, rect.size.width, rect.size.height)
#define CGRectOffsetWidth(rect, Width) CGRectMake(rect.origin.x, rect.origin.y, rect.size.width + Width, rect.size.height)
#define CGRectOffsetHeight(rect, Height) CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height + Height)

#define CGSizeCenter(size) CGPointMake(size.width / 2.0, size.height / 2.0)
#define CGRectCenter(rect) CGPointMake(rect.origin.x + rect.size.width / 2.0, rect.origin.y + rect.size.height / 2.0)

#define CGSizeCenterInSize(size1, size2) CGRectMake(0.0 + (size2.width - size1.width) / 2.0, 0.0 + (size2.height - size1.height) / 2.0, size1.width, size1.height)
#define CGSizeCenterInRect(size1, rect2) CGRectMake(rect2.origin.x + (rect2.size.width - size1.width) / 2.0, rect2.origin.y + (rect2.size.height - size1.height) / 2.0, size1.width, size1.height)
#define CGRectCenterInSize(rect1, size2) CGRectMake(0.0 + (size2.width - rect1.size.width) / 2.0, 0.0 + (size2.height - rect1.size.height) / 2.0, rect1.size.width, rect1.size.height)
#define CGRectCenterInRect(rect1, rect2) CGRectMake(rect2.orogin.x + (rect2.size.width - rect1.size.width) / 2.0, rect2.orogin.x + (rect2.size.height - rect1.size.height) / 2.0, rect1.size.width, rect1.size.height)

#define CGSizeAspectFill(size1, size2) ({ CGFloat __h = size1.height / size2.height; CGFloat __w = size1.width / size2.width; __h < __w ? CGSizeMake(size1.width / __h, size2.height) : CGSizeMake(size2.width, size1.height / __w); })
#define CGSizeAspectFit(size1, size2) ({ CGFloat __h = size1.height / size2.height; CGFloat __w = size1.width / size2.width; __h > __w ? CGSizeMake(size1.width / __h, size2.height) : CGSizeMake(size2.width, size1.height / __w); })
