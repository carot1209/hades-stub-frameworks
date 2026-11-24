#import "NetflixGames.h"

// ── HadesNetflixProfile ───────────────────────────────────────────────────────
@implementation HadesNetflixProfile
- (NSString *)profileId    { return @"stub-profile-id"; }
- (NSString *)displayName  { return @"Player"; }
@end

// ── HadesNetflixAccessEvent ───────────────────────────────────────────────────
@implementation HadesNetflixAccessEvent
- (BOOL)hasAccess { return YES; }
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

+ (instancetype)sharedInstance {
    static NetflixGamesSDK *s = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ s = [[self alloc] init]; });
    return s;
}

// Profile — luôn báo đã đăng nhập
- (HadesNetflixProfile *)currentProfileAndReturnError:(NSError **)error {
    if (error) *error = nil;
    return [[HadesNetflixProfile alloc] init];
}
- (HadesNetflixProfile *)activeProfile {
    return [[HadesNetflixProfile alloc] init];
}

// Access — luôn cấp quyền
- (void)requestPlayerAccessWithCompletionHandler:(void(^)(BOOL granted, NSError *error))handler {
    if (handler) dispatch_async(dispatch_get_main_queue(), ^{ handler(YES, nil); });
}
- (void)onPlayerAccessChangeWithAccessEvent:(HadesNetflixAccessEvent *)event {}
- (void)showNetflixAccessButton {}
- (void)hideNetflixAccessButton {}

// Blob store — không có cloud save
- (void)playerBlobsWithCompletionHandler:(void(^)(NSArray *blobs, NSError *error))handler {
    if (handler) dispatch_async(dispatch_get_main_queue(), ^{ handler(@[], nil); });
}
- (void)readPlayerBlobWithName:(NSString *)name completionHandler:(void(^)(NetflixBlobContainer *blob, NSError *error))handler {
    if (handler) dispatch_async(dispatch_get_main_queue(), ^{ handler(nil, nil); });
}
- (void)writePlayerBlobWithName:(NSString *)name blobContainer:(NetflixBlobContainer *)container completionHandler:(void(^)(BOOL success, NSError *error))handler {
    if (handler) dispatch_async(dispatch_get_main_queue(), ^{ handler(NO, nil); });
}
- (void)deletePlayerBlobWithName:(NSString *)name completionHandler:(void(^)(BOOL success, NSError *error))handler {
    if (handler) dispatch_async(dispatch_get_main_queue(), ^{ handler(NO, nil); });
}

// Achievements — từ chối
- (void)unlockAchievementWithAchievementName:(NSString *)name completionHandler:(void(^)(BOOL success, NSError *error))handler {
    if (handler) dispatch_async(dispatch_get_main_queue(), ^{ handler(NO, nil); });
}

@end

// ── Analytics event classes (stub rỗng) ───────────────────────────────────────
@implementation FirstTimeUserExperienceStart @end
@implementation FirstTimeUserExperienceStepComplete @end
@implementation FirstTimeUserExperienceComplete @end
@implementation NewGameStart @end
@implementation GameComplete @end
@implementation ProgressCheckpointComplete @end

// ── NetflixSplashViewController ───────────────────────────────────────────────
@implementation NetflixSplashViewController
- (void)viewDidLoad { [super viewDidLoad]; }
@end
