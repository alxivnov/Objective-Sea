//
//  NSLib.h
//  Done!
//
//  Created by Alexander Ivanov on 17.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Dispatch+Convenience.h"

#define cls(cls, obj) ({ __typeof__(obj) __obj = (obj); [__obj isKindOfClass:[cls class]] ? (cls *)__obj : Nil; })

#define arr_(obj) ({ __typeof__(obj) __obj = (obj); __obj ? @[ __obj ] : Nil; })
#define arr__(obj0, obj1) ({ __typeof__(obj0) __obj0 = (obj0); __typeof__(obj1) __obj1 = (obj1); __obj0 && __obj1 ? @[ __obj0, __obj1 ] : __obj0 ? @[ __obj0 ] : __obj1 ? @[ __obj1 ] : Nil; })
//#define arr___(obj0, obj1, obj2) ({ __typeof__(obj0) __obj0 = (obj0); __typeof__(obj1) __obj1 = (obj1); __typeof__(obj2) __obj2 = (obj2); !__obj0 ? arr__(__obj1, __obj2) : !__obj1 ? arr__(__obj0, __obj2) : !__obj2 ? arr__(__obj0, __obj1) : @[ __obj0, __obj1, __obj2 ]; })
#define idx(arr, idx) ({ __typeof__(arr) __arr = (arr); __typeof__(idx) __idx = (idx); __idx >= 0 && __idx < [__arr count] ? __arr[__idx] : Nil; })

#define dic_(key0, val0) ({ __typeof__(key0) __key0 = (key0); __typeof__(val0) __val0 = (val0); __key0 && __val0 ? @{ __key0 : __val0 } : Nil; })
#define dic__(key0, val0, key1, val1) ({ __typeof__(key0) __key0 = (key0); __typeof__(val0) __val0 = (val0); __typeof__(key1) __key1 = (key1); __typeof__(val1) __val1 = (val1); __key0 && __val0 && __key1 && __val1 ? @{ __key0 : __val0, __key1 : __val1 } : __key0 && __val0 ? @{ __key0 : __val0 } : __key1 && __val1 ? @{ __key1 : __val1 } : Nil; })

#define sel(obj, sel) ({ __typeof__(obj) __obj = (obj); [__obj respondsToSelector:@selector(sel)] ? [__obj performSelector:@selector(sel)] : Nil; })
#define sel_(obj, sel, arg) ({ __typeof__(obj) __obj = (obj); id __arg= (arg); [__obj respondsToSelector:@selector(sel)] ? [__obj performSelector:@selector(sel) withObject:__arg] : Nil; })
#define sel__(obj, sel, arg1, arg2) ({ __typeof__(obj) __obj = (obj); id __arg1 = (arg1); id __arg2 = (arg2); [__obj respondsToSelector:@selector(sel)] ? [__obj performSelector:@selector(sel) withObject:__arg1 withObject:__arg2] : Nil; })

#define _sel(obj, sel) { __typeof__(obj) __obj = (obj); if ([__obj respondsToSelector:@selector(sel)]) { [__obj performSelector:@selector(sel)]; } }
#define _sel_(obj, sel, arg) { __typeof__(obj) __obj = (obj); id __arg= (arg); if ([__obj respondsToSelector:@selector(sel)]) { [__obj performSelector:@selector(sel) withObject:__arg]; } }
#define _sel__(obj, sel, arg1, arg2) { __typeof__(obj) __obj = (obj); id __arg1 = (arg1); id __arg2 = (arg2); if ([__obj respondsToSelector:@selector(sel)]) { [__obj performSelector:@selector(sel) withObject:__arg1 withObject:__arg2]; } }

#define _nil(obj, init) ({ __typeof__(obj) __obj = (obj); __obj ? __obj : init; })

#define NOW(var) NSDate *var = [NSDate date]

#define __property(type, name, init) - (type)name { if (!_##name) { _##name = init; } return _##name; }
#define __synthesize(type, name, init) @synthesize name = _##name; - (type)name { if (!_##name) { _##name = init; } return _##name; }
#define __static(type, name, init) static type _##name; + (type)name { @synchronized(self) { if (!_##name) _##name = init; } return _##name; }

#define LNG_RU @"ru"

#define STR_ASTERISK @"*"
#define STR_AMPERSAND @"&"
#define STR_COLON @":"
#define STR_COMMA @","
#define STR_DOT @"."
#define STR_EMPTY @""
#define STR_EQUALITY @"="
#define STR_HYPHEN @"-"
#define STR_NEW_LINE @"\n"
#define STR_NUMBER @"#"
#define STR_PLUS @"+"
#define STR_SLASH @"/"
#define STR_SPACE @" "
#define STR_UNDERSCORE @"_"
#define STR_VERTICAL_BAR @"|"

#define DIV_FLOOR(a, b) a / b
#define DIV_CEIL(a, b) (a + b - 1) / b
#define DIV_ROUND(a, b) (a + b / 2) / b

#define FLT_EQUALS(x, y) ({ __typeof__(x) __x = (x); __typeof__(y) __y = y; fabsf(__x - __y) < FLT_EPSILON; })
#define DBL_EQUALS(x, y) ({ __typeof__(x) __x = (x); __typeof__(y) __y = y; fabs(__x - __y) < DBL_EPSILON; })

#define NSLocalize(key) NSLocalizedString(key, Nil)
#define NSLocalizeMethod(method, key) + (NSString *)method { return NSLocalizedString(key, Nil); }

#define MEM_PAGE_SIZE 4096

#ifdef DEBUG
#define IS_DEBUGGING YES
#else
#define IS_DEBUGGING NO
#endif

#if (TARGET_IPHONE_SIMULATOR)
#define IS_SIMULATOR YES
#else
#define IS_SIMULATOR NO
#endif

#define DEG_360 (2.0 * M_PI)

@interface NSHelper : NSObject

+ (BOOL)wait:(NSTimeInterval)interval flag:(BOOL *)flag step:(NSTimeInterval)step;
+ (BOOL)wait:(NSTimeInterval)interval flag:(BOOL *)flag;

+ (BOOL)string:(NSString *)value1 isEqualTo:(NSString *)value2;
+ (BOOL)number:(NSNumber *)value1 isEqualTo:(NSNumber *)value2;
+ (BOOL)date:(NSDate *)value1 isEqualTo:(NSDate *)value2;
+ (BOOL)data:(NSData *)value1 isEqualTo:(NSData *)value2;
+ (NSComparisonResult)string:(NSString *)value1 compare:(NSString *)value2;
+ (NSComparisonResult)number:(NSNumber *)value1 compare:(NSNumber *)value2;
+ (NSComparisonResult)date:(NSDate *)value1 compare:(NSDate *)value2;

@end

@interface NSString (Log)

- (void)log:(NSString *)message;

@end

@interface NSError (Log)

- (void)log:(NSString *)message;
- (void)log;

@end
