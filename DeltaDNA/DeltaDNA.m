// DeltaDNA.framework — stub
// Game import classref: _OBJC_CLASS_$_DDNASDK, _OBJC_CLASS_$_DDNAEvent.
// libhades.so: [DDNASDK sharedInstance] -> nil, [DDNAEvent eventWithName:] -> nil
// => mọi lời gọi analytics thành gửi message tới nil = no-op (analytics not started).
// 2 class vẫn phải tồn tại để dyld bind classref, tránh crash lúc mở app.

#import <Foundation/Foundation.h>

@interface DDNASDK : NSObject
+ (instancetype)sharedInstance;
@end

@implementation DDNASDK
+ (instancetype)sharedInstance { return nil; }   // .so: mov x0, xzr
@end

@interface DDNAEvent : NSObject
+ (instancetype)eventWithName:(NSString *)name;
@end

@implementation DDNAEvent
+ (instancetype)eventWithName:(NSString *)name { return nil; }   // .so: mov x0, xzr
@end
