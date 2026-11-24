#pragma once
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Tái dựng theo đúng bảng class/selector/hàm trích từ libhades.so (bản Android).
// Mọi hành vi (giá trị trả về, nil, NSError) khớp 1:1 với bản port đang chạy được.

// ── Profile (trả về bởi currentProfileAndReturnError:/activeProfile) ──────────
@interface HadesNetflixProfile : NSObject
- (NSString *)playerID;           // .so: "HadesPortPlayer"
- (NSString *)preferredLanguage;  // .so: "en"
@end

// ── Access event ─────────────────────────────────────────────────────────────
@interface HadesNetflixAccessEvent : NSObject
- (id)current;
- (id)previous;                   // .so: nil
@end

// ── Blob container (game import classref _OBJC_CLASS_$_NetflixBlobContainer) ──
@interface NetflixBlobContainer : NSObject
- (instancetype)initWithData:(NSData *)data;
@property (nonatomic, readonly) NSData *data;
@end

// ── SDK (game import classref _OBJC_CLASS_$__TtC12NetflixGames15NetflixGamesSDK) ─
__attribute__((objc_runtime_name("_TtC12NetflixGames15NetflixGamesSDK")))
@interface NetflixGamesSDK : NSObject

+ (instancetype)shared;           // .so: shared singleton

// 5 sub-API — trong .so đều trả về cùng một đối tượng API; ở đây trả về self.
- (instancetype)accessAPI;
- (instancetype)profilesAPI;
- (instancetype)telemetryAPI;
- (instancetype)blobStoreAPI;
- (instancetype)achievementsAPI;

// Profile — luôn báo đã đăng nhập
- (HadesNetflixProfile *)currentProfileAndReturnError:(NSError **)error;
- (HadesNetflixProfile *)activeProfile;

// Access — luôn cấp quyền
- (void)requestPlayerAccessWithCompletionHandler:(void(^)(BOOL granted, NSError *error))handler;
- (void)onPlayerAccessChangeWithAccessEvent:(id)event;
- (void)showNetflixAccessButton;
- (void)hideNetflixAccessButton;
- (void)registerEventHandler:(id)handler;
- (void)setUserStateChangeHandler:(id)handler;

// Telemetry — no-op (.so: ret)
- (void)logWithEvent:(id)event;
- (void)recordEvent:(id)event;

// Cloud save / achievements — .so: refuse (callback NO/nil + NSError HadesPort)
- (void)playerBlobsWithCompletionHandler:(void(^)(NSArray *blobs, NSError *error))handler;
- (void)readPlayerBlobWithName:(NSString *)name completionHandler:(void(^)(NetflixBlobContainer *blob, NSError *error))handler;
- (void)writePlayerBlobWithName:(NSString *)name blobContainer:(NetflixBlobContainer *)container completionHandler:(void(^)(BOOL success, NSError *error))handler;
- (void)deletePlayerBlobWithName:(NSString *)name completionHandler:(void(^)(BOOL success, NSError *error))handler;
- (void)resolveConflictWithName:(NSString *)name resolution:(NSInteger)resolution completionHandler:(void(^)(BOOL success, NSError *error))handler;
- (void)unlockAchievementWithAchievementName:(NSString *)name completionHandler:(void(^)(BOOL success, NSError *error))handler;

@end

// ── Analytics event classes (game import classref trực tiếp) ─────────────────
// Base nuốt mọi selector lạ (initWithCheckpointNumber:... v.v.) để không crash.
@interface HadesNoopEvent : NSObject @end

@interface FirstTimeUserExperienceStart : HadesNoopEvent @end
@interface FirstTimeUserExperienceStepComplete : HadesNoopEvent @end
@interface FirstTimeUserExperienceComplete : HadesNoopEvent @end
@interface NewGameStart : HadesNoopEvent @end
@interface GameComplete : HadesNoopEvent @end
@interface ProgressCheckpointComplete : HadesNoopEvent @end

