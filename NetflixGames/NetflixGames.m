#import "NetflixGames.h"
#import <objc/runtime.h>

#define HLOG(fmt, ...) NSLog(@"[HadesStub] " fmt, ##__VA_ARGS__)

__attribute__((constructor)) static void HadesNGLoaded(void) {
    HLOG(@"NetflixGames loaded (stub, logging build)");
}

// NSError giống hệt helper "refuse" trong libhades.so:
// domain "HadesPort", code 1, NSLocalizedDescription "Netflix services are not part of this port"
static NSError *HadesRefuseError(void) {
    return [NSError errorWithDomain:@"HadesPort"
                               code:1
                           userInfo:@{ NSLocalizedDescriptionKey: @"Netflix services are not part of this port" }];
}

// ── HadesNetflixProfile ───────────────────────────────────────────────────────
@implementation HadesNetflixProfile
- (NSString *)playerID          { return @"HadesPortPlayer"; }
- (NSString *)preferredLanguage { return @"en"; }
@end

// ── HadesNetflixAccessEvent ───────────────────────────────────────────────────
@implementation HadesNetflixAccessEvent
- (id)current  { return self; }
- (id)previous { return nil; }   // .so: mov x0, xzr
@end

// ── NetflixBlobContainer ──────────────────────────────────────────────────────
@implementation NetflixBlobContainer {
    NSData *_data;
}
- (instancetype)initWithData:(NSData *)data {
    if ((self = [super init])) { _data = data; }
    return self;
}
- (NSData *)data { return _data; }
@end

// ── NetflixGamesSDK ───────────────────────────────────────────────────────────
@implementation NetflixGamesSDK

+ (instancetype)shared { HLOG(@"%@", @"+ (instancetype)shared");
    static NetflixGamesSDK *s = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ s = [[self alloc] init]; });
    return s;
}

// 5 sub-API đều trả về cùng một đối tượng (ở đây: self)
- (instancetype)accessAPI       { HLOG(@"%@", @"- (instancetype)accessAPI"); return self; }
- (instancetype)profilesAPI     { HLOG(@"%@", @"- (instancetype)profilesAPI"); return self; }
- (instancetype)telemetryAPI    { HLOG(@"%@", @"- (instancetype)telemetryAPI"); return self; }
- (instancetype)blobStoreAPI    { HLOG(@"%@", @"- (instancetype)blobStoreAPI"); return self; }
- (instancetype)achievementsAPI { HLOG(@"%@", @"- (instancetype)achievementsAPI"); return self; }

// Profile — luôn trả profile, error = nil
- (HadesNetflixProfile *)currentProfileAndReturnError:(NSError **)error { HLOG(@"%@", @"- (HadesNetflixProfile *)currentProfileAndReturnError:(NSError **)error");
    if (error) *error = nil;
    return [[HadesNetflixProfile alloc] init];
}
- (HadesNetflixProfile *)activeProfile { HLOG(@"%@", @"- (HadesNetflixProfile *)activeProfile");
    return [[HadesNetflixProfile alloc] init];
}

// Access — luôn cấp quyền: handler(YES, nil)
- (void)requestPlayerAccessWithCompletionHandler:(void(^)(BOOL granted, NSError *error))handler { HLOG(@"%@", @"- (void)requestPlayerAccessWithCompletionHandler:(void(^)(BOOL granted, NSError *error))handler");
    if (handler) dispatch_async(dispatch_get_main_queue(), ^{ handler(YES, nil); });
}
- (void)onPlayerAccessChangeWithAccessEvent:(id)event { HLOG(@"%@", @"- (void)onPlayerAccessChangeWithAccessEvent:(id)event");}
- (void)showNetflixAccessButton { HLOG(@"%@", @"- (void)showNetflixAccessButton");}
- (void)hideNetflixAccessButton { HLOG(@"%@", @"- (void)hideNetflixAccessButton");}
- (void)registerEventHandler:(id)handler { HLOG(@"%@", @"- (void)registerEventHandler:(id)handler");}
- (void)setUserStateChangeHandler:(id)handler { HLOG(@"%@", @"- (void)setUserStateChangeHandler:(id)handler");}

// Telemetry — no-op
- (void)logWithEvent:(id)event { HLOG(@"%@", @"- (void)logWithEvent:(id)event");}
- (void)recordEvent:(id)event { HLOG(@"%@", @"- (void)recordEvent:(id)event");}

// Cloud save / achievements — refuse: handler(NO/nil, HadesRefuseError)
- (void)playerBlobsWithCompletionHandler:(void(^)(NSArray *blobs, NSError *error))handler { HLOG(@"%@", @"- (void)playerBlobsWithCompletionHandler:(void(^)(NSArray *blobs, NSError *error))handler");
    if (handler) dispatch_async(dispatch_get_main_queue(), ^{ handler(nil, HadesRefuseError()); });
}
- (void)readPlayerBlobWithName:(NSString *)name completionHandler:(void(^)(NetflixBlobContainer *blob, NSError *error))handler { HLOG(@"%@", @"- (void)readPlayerBlobWithName:(NSString *)name completionHandler:(void(^)(NetflixBlobContainer *blob, NSError *error))handler");
    if (handler) dispatch_async(dispatch_get_main_queue(), ^{ handler(nil, HadesRefuseError()); });
}
- (void)writePlayerBlobWithName:(NSString *)name blobContainer:(NetflixBlobContainer *)container completionHandler:(void(^)(BOOL success, NSError *error))handler { HLOG(@"%@", @"- (void)writePlayerBlobWithName:(NSString *)name blobContainer:(NetflixBlobContainer *)container completionHandler:(void(^)(BOOL success, NSError *error))handler");
    if (handler) dispatch_async(dispatch_get_main_queue(), ^{ handler(NO, HadesRefuseError()); });
}
- (void)deletePlayerBlobWithName:(NSString *)name completionHandler:(void(^)(BOOL success, NSError *error))handler { HLOG(@"%@", @"- (void)deletePlayerBlobWithName:(NSString *)name completionHandler:(void(^)(BOOL success, NSError *error))handler");
    if (handler) dispatch_async(dispatch_get_main_queue(), ^{ handler(NO, HadesRefuseError()); });
}
- (void)resolveConflictWithName:(NSString *)name resolution:(NSInteger)resolution completionHandler:(void(^)(BOOL success, NSError *error))handler { HLOG(@"%@", @"- (void)resolveConflictWithName:(NSString *)name resolution:(NSInteger)resolution completionHandler:(void(^)(BOOL success, NSError *error))handler");
    if (handler) dispatch_async(dispatch_get_main_queue(), ^{ handler(NO, HadesRefuseError()); });
}
- (void)unlockAchievementWithAchievementName:(NSString *)name completionHandler:(void(^)(BOOL success, NSError *error))handler { HLOG(@"%@", @"- (void)unlockAchievementWithAchievementName:(NSString *)name completionHandler:(void(^)(BOOL success, NSError *error))handler");
    if (handler) dispatch_async(dispatch_get_main_queue(), ^{ handler(NO, HadesRefuseError()); });
}


// ── Bắt mọi selector lạ: log + tự gọi block (thành công, kết quả rỗng) ───────
static NSMethodSignature *HadesSig(SEL sel) {
    NSUInteger args = [[NSStringFromSelector(sel) componentsSeparatedByString:@":"] count] - 1;
    NSMutableString *t = [NSMutableString stringWithString:@"@@:"];
    for (NSUInteger i = 0; i < args; i++) [t appendString:@"@"];
    return [NSMethodSignature signatureWithObjCTypes:t.UTF8String];
}
static void HadesFireBlocks(NSInvocation *inv) {
    NSUInteger n = inv.methodSignature.numberOfArguments;
    for (NSUInteger i = 2; i < n; i++) {
        __unsafe_unretained id a = nil;
        [inv getArgument:&a atIndex:i];
        if (a && [NSStringFromClass([a class]) containsString:@"Block"]) {
            HLOG(@"  -> firing block arg %lu", (unsigned long)i);
            void (^b)(id, id) = a;
            dispatch_async(dispatch_get_main_queue(), ^{ b(nil, nil); });
        }
    }
    id ret = nil;
    if (inv.methodSignature.methodReturnType[0] == '@') [inv setReturnValue:&ret];
}
- (BOOL)respondsToSelector:(SEL)sel {
    BOOL r = [super respondsToSelector:sel];
    if (!r) HLOG(@"respondsToSelector NO: %@", NSStringFromSelector(sel));
    return r;
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [super methodSignatureForSelector:sel] ?: HadesSig(sel);
}
- (void)forwardInvocation:(NSInvocation *)inv {
    HLOG(@"UNKNOWN -[NetflixGamesSDK %@]", NSStringFromSelector(inv.selector));
    HadesFireBlocks(inv);
}
+ (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [super methodSignatureForSelector:sel] ?: HadesSig(sel);
}
+ (void)forwardInvocation:(NSInvocation *)inv {
    HLOG(@"UNKNOWN +[NetflixGamesSDK %@]", NSStringFromSelector(inv.selector));
    HadesFireBlocks(inv);
}
@end

// ── Base nuốt mọi selector lạ cho các class analytics event ───────────────────
// Game có thể gọi initWithStepNumber:... / initWithCheckpointNumber:... trên các
// class này. Vì analytics là no-op, ta chấp nhận mọi message và trả nil/0.
@implementation HadesNoopEvent
+ (NSMethodSignature *)sigFor:(SEL)sel {
    NSString *n = NSStringFromSelector(sel);
    NSUInteger args = [[n componentsSeparatedByString:@":"] count] - 1;
    NSMutableString *t = [NSMutableString stringWithString:@"@@:"]; // ret id, self, _cmd
    for (NSUInteger i = 0; i < args; i++) [t appendString:@"@"];
    return [NSMethodSignature signatureWithObjCTypes:t.UTF8String];
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSMethodSignature *s = [super methodSignatureForSelector:sel];
    return s ?: [HadesNoopEvent sigFor:sel];
}
- (void)forwardInvocation:(NSInvocation *)inv {
    HLOG(@"event -[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(inv.selector));
    id nilv = nil;
    const char *rt = inv.methodSignature.methodReturnType;
    if (rt[0] == '@') [inv setReturnValue:&nilv];
}
+ (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSMethodSignature *s = [super methodSignatureForSelector:sel];
    return s ?: [HadesNoopEvent sigFor:sel];
}
+ (void)forwardInvocation:(NSInvocation *)inv {
    HLOG(@"event +[%@ %@]", NSStringFromClass(self), NSStringFromSelector(inv.selector));
    id nilv = nil;
    const char *rt = inv.methodSignature.methodReturnType;
    if (rt[0] == '@') [inv setReturnValue:&nilv];
}
@end

@implementation FirstTimeUserExperienceStart        @end
@implementation FirstTimeUserExperienceStepComplete @end
@implementation FirstTimeUserExperienceComplete     @end
@implementation NewGameStart                        @end
@implementation GameComplete                        @end
@implementation ProgressCheckpointComplete          @end


