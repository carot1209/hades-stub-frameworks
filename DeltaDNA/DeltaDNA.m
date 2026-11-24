// DeltaDNA.framework — stub
// Game import 2 class: _OBJC_CLASS_$_DDNASDK, _OBJC_CLASS_$_DDNAEvent.
// Analytics không được khởi động ("services: analytics not started"),
// nhưng 2 class phải tồn tại để dyld bind được classref → tránh crash lúc mở.

#import <Foundation/Foundation.h>

@interface DDNASDK : NSObject
+ (instancetype)sharedInstance;
@end

@implementation DDNASDK
+ (instancetype)sharedInstance {
    static DDNASDK *s = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ s = [[self alloc] init]; });
    return s;
}
@end

@interface DDNAEvent : NSObject
- (instancetype)initWithName:(NSString *)name;
@end

@implementation DDNAEvent
- (instancetype)initWithName:(NSString *)name { return [super init]; }
@end

__attribute__((constructor))
static void DeltaDNAInit(void) {
    NSLog(@"[DeltaDNA] loaded (stub — analytics not started)");
}
