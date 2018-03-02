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

#define CGPointIsNan(point) (isnan(point.x) || isnan(point.y))
#define CGSizeIsNan(size) (isnan(size.width) || isnan(size.height))
#define CGRectIsNan(rect) (isnan(rect.origin.x) || isnan(rect.origin.y) || isnan(rect.size.width) || isnan(rect.size.height))

#define CGPointDescription(point) [NSString stringWithFormat:@"{%.1f,%.1f}", point.x, point.y]
#define CGSizeDescription(size) [NSString stringWithFormat:@"{%.1f,%.1f}", size.width, size.height]
#define CGRectDescription(rect)  [NSString stringWithFormat:@"{{%.1f,%.1f},{%.1f,%.1f}}", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height]

#define CGRectMakeWithOriginAndSize(origin, size) CGRectMake(origin.x, origin.y, size.width, size.height)
#define CGRectMakeWithSize(size) CGRectMakeWithOriginAndSize(CGPointZero, size)

#define CGRectIsHorizontal(rect) (rect.size.height < rect.size.width)
#define CGRectIsVertical(rect) (rect.size.height > rect.size.width)

#define CGRectRotate(rect) CGRectMake(rect.origin.x, rect.origin.y, rect.size.height, rect.size.width)

#define CGPointScale(point, dx, dy) CGPointMake(point.x * dx, point.y * dy)
#define CGSizeScale(size, dx, dy) CGSizeMake(size.height * dx, size.width * dy)
#define CGRectScale(rect, dx, dy) CGRectMake(rect.origin.x * dx, rect.origin.y * dy, rect.size.width * dx, rect.size.height * dy)

#define CGRectSetOrigin(rect, origin) ({ CGPoint __origin = (origin); CGRectMake(__origin.x, __origin.y, rect.size.width, rect.size.height); })
#define CGRectSetSize(rect, size) ({ CGSize __size = (size); CGRectMake(rect.origin.x, rect.origin.y, __size.width, __size.height); })
#define CGRectSetX(rect, x) ({ CGFloat __x = (x); CGRectMake(__x, rect.origin.y, rect.size.width, rect.size.height); })
#define CGRectSetY(rect, y) ({ CGFloat __y = (y); CGRectMake(rect.origin.x, __y, rect.size.width, rect.size.height); })
#define CGRectSetWidth(rect, width) ({ CGFloat __width = (width); CGRectMake(rect.origin.x, rect.origin.y, __width, rect.size.height); })
#define CGRectSetHeight(rect, height) ({ CGFloat __height = (height); CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, __height); })

#define CGRectOffsetOrigin(rect, Origin) ({ CGPoint __origin = (Origin); CGRectMake(rect.origin.x + __origin.x, rect.origin.y + __origin.y, rect.size.width, rect.size.height); })
#define CGRectOffsetSize(rect, Size) ({ CGSize __size = (Size); CGRectMake(rect.origin.x, rect.origin.y, rect.size.width + __size.width, rect.size.height + __size.height); })
#define CGRectOffsetX(rect, X) ({ CGFloat __x = (X); CGRectMake(rect.origin.x + __x, rect.origin.y, rect.size.width, rect.size.height); })
#define CGRectOffsetY(rect, Y) ({ CGFloat __y = (Y); CGRectMake(rect.origin.x, rect.origin.y + __y, rect.size.width, rect.size.height); })
#define CGRectOffsetWidth(rect, Width) ({ CGFloat __width = (width); CGRectMake(rect.origin.x, rect.origin.y, rect.size.width + __width, rect.size.height); })
#define CGRectOffsetHeight(rect, Height) ({ CGFloat __height = (height); CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height + __height); })

#define CGSizeCenter(size) CGPointMake(size.width / 2.0, size.height / 2.0)
#define CGRectCenter(rect) CGPointMake(rect.origin.x + rect.size.width / 2.0, rect.origin.y + rect.size.height / 2.0)

#define CGSizeCenterInSize(size1, size2) CGRectMake(0.0 + (size2.width - size1.width) / 2.0, 0.0 + (size2.height - size1.height) / 2.0, size1.width, size1.height)
#define CGSizeCenterInRect(size1, rect2) CGRectMake(rect2.origin.x + (rect2.size.width - size1.width) / 2.0, rect2.origin.y + (rect2.size.height - size1.height) / 2.0, size1.width, size1.height)
#define CGRectCenterInSize(rect1, size2) CGRectMake(0.0 + (size2.width - rect1.size.width) / 2.0, 0.0 + (size2.height - rect1.size.height) / 2.0, rect1.size.width, rect1.size.height)
#define CGRectCenterInRect(rect1, rect2) CGRectMake(rect2.origin.x + (rect2.size.width - rect1.size.width) / 2.0, rect2.origin.x + (rect2.size.height - rect1.size.height) / 2.0, rect1.size.width, rect1.size.height)

#define CGSizeAspectFill(size1, size2) ({ CGFloat __h = size1.height / size2.height; CGFloat __w = size1.width / size2.width; __h < __w ? CGSizeMake(size1.width / __h, size2.height) : CGSizeMake(size2.width, size1.height / __w); })
#define CGSizeAspectFit(size1, size2) ({ CGFloat __h = size1.height / size2.height; CGFloat __w = size1.width / size2.width; __h > __w ? CGSizeMake(size1.width / __h, size2.height) : CGSizeMake(size2.width, size1.height / __w); })

#define CGContextAddCircle(c, x, y, radius) CGContextAddArc(c, x, y, radius, 0.0, 2.0 * M_PI, YES)
