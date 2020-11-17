//
//  NSLib.h
//  Done!
//
//  Created by Alexander Ivanov on 17.10.13.
//  Copyright (c) 2013 Alex Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#define cls(cls, obj) ((cls *)[obj cast:[cls class]])

#define arr_(obj) [NSArray arrayWithObject:obj withObject:Nil withObject:Nil]
#define arr__(obj0, obj1) [NSArray arrayWithObject:obj0 withObject:obj1 withObject:Nil]
#define arr___(obj0, obj1, obj2) [NSArray arrayWithObject:obj0 withObject:obj1 withObject:obj2]
#define idx(arr, idx) [arr valueAtIndex:idx]

#define dic_(key0, val0) [NSDictionary dictionaryWithObject:val0 forKey:key0 withObject:Nil forKey:Nil withObject:Nil forKey:Nil]
#define dic__(key0, val0, key1, val1) [NSDictionary dictionaryWithObject:val0 forKey:key0 withObject:val1 forKey:key1 withObject:Nil forKey:Nil]
#define dic___(key0, val0, key1, val1, key2, val2) [NSDictionary dictionaryWithObject:val0 forKey:key0 withObject:val1 forKey:key1 withObject:val2 forKey:key2]

#define sel(obj, sel) [obj forwardSelector:@selector(sel)]
#define sel_(obj, sel, arg) [obj forwardSelector:@selector(sel) withObject:arg]
#define sel__(obj, sel, arg1, arg2) [obj forwardSelector:@selector(sel) withObject:arg1 withObject:arg2]

#define _set(struct, field, value) { __typeof(struct) tmp = struct; tmp.field = value; struct = tmp; }

#define NOW [NSDate date]
#define now(name) NSDate *name = [NSDate date]

#define __property(type, name, init) - (type)name { if (!_##name) { _##name = init; } return _##name; }
#define __synthesize(type, name, init) @synthesize name = _##name; - (type)name { if (!_##name) { _##name = init; } return _##name; }
#define __static(type, name, init) static type _##name; + (type)name { @synchronized(self) { if (!_##name) _##name = init; } return _##name; }

#define __defaults(type, get, set) - (type)get { return [NSUserDefaults.standardUserDefaults objectForKey:@#get]; } - (void)set:(type)obj { [NSUserDefaults.standardUserDefaults setObject:obj forKey:@#get]; }
#define __class(type, get, set) static type _##get; + (type)get { return _##get; } + (void)set:(type)get { _##get = get; }

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
#define STR_NULL @"\0"
#define STR_NUMBER @"#"
#define STR_PLUS @"+"
#define STR_SEMICOLON @";"
#define STR_SLASH @"/"
#define STR_SPACE @" "
#define STR_UNDERSCORE @"_"
#define STR_VERTICAL_BAR @"|"

#define DIV_FLOOR(a, b) (a / b)
#define DIV_CEIL(a, b) ((a + b - 1) / b)
#define DIV_ROUND(a, b) ((a + b / 2) / b)

#define FLT_EQUALS(x, y) (fabsf(x - y) < FLT_EPSILON)
#define DBL_EQUALS(x, y) (fabs(x - y) < DBL_EPSILON)

#define eql(x, y) (x == y || (x && y && [x compare:y] == NSOrderedSame))
#define cmp(x, y) (x == y ? NSOrderedSame : x == Nil ? NSOrderedAscending : y == Nil ? NSOrderedDescending : [x compare:y])

#define loc(key) NSLocalizedString(key, Nil)

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

#define str(d) [NSString stringWithFormat:@"%ld", (long)d]
#define fstr(f) [NSString stringWithFormat:@"%f", (double)f]

#define DEG_360 (2.0 * M_PI)

#define VER(major, minor) [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){ major, minor }]

@interface NSObject (Convenience)

- (id)cast:(Class)type;

- (void)log:(NSString *)message;

- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects;
- (id)performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2 withObject:(id)object3;

- (id)forwardSelector:(SEL)aSelector;
- (id)forwardSelector:(SEL)aSelector withObject:(id)object;
- (id)forwardSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2;

- (id)forwardSelector:(SEL)aSelector withObjects:(NSArray *)objects nextTarget:(id(^)(id target, BOOL responds, id returnValue))block;
- (id)forwardSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2 withObject:(id)object3 nextTarget:(id(^)(id target, BOOL responds, id returnValue))block;
- (id)forwardSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2 nextTarget:(id(^)(id target, BOOL responds, id returnValue))block;
- (id)forwardSelector:(SEL)aSelector withObject:(id)object1 nextTarget:(id(^)(id target, BOOL responds, id returnValue))block;
- (id)forwardSelector:(SEL)aSelector nextTarget:(id(^)(id target, BOOL responds, id returnValue))block;

- (BOOL)isEqualToAnyObject:(NSArray *)objects;

- (BOOL)isKindOfAnyClass:(NSArray<Class> *)classes;
- (BOOL)isMemberOfAnyClass:(NSArray<Class> *)classes;

@property (assign, nonatomic, readonly) BOOL isNull;

- (NSData *)archivedData;
+ (instancetype)createFromArchivedData:(NSData *)data;

- (id)tryGetValueForKey:(NSString *)key;
- (BOOL)trySetValue:(id)value forKey:(NSString *)key;

+ (instancetype)arrayWithObject:(id)obj0 withObject:(id)obj1 withObject:(id)obj2;

+ (instancetype)dictionaryWithObject:(id)obj0 forKey:(id<NSCopying>)key0 withObject:(id)obj1 forKey:(id<NSCopying>)key1 withObject:(id)obj2 forKey:(id<NSCopying>)key2;

- (id)valueForPath:(NSArray *)path;

@end

@interface NSMethodSignature (Convenience)

- (BOOL)methodReturnTypeIs:(char *)methodReturnType;

@end

@interface NSInvocation (Convenience)

- (id)getReturnValue;

@end

@interface NSNumber (Convenience)

@property (assign, nonatomic, readonly) BOOL isNotANumber;
@property (strong, nonatomic, readonly) NSDecimalNumber *decimalNumber;

@end

@interface NSArray<ObjectType> (Index)

- (ObjectType)valueAtIndex:(NSInteger)index;

@end
