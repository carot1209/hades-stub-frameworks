#pragma once
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// ── Profile ──────────────────────────────────────────────────────────────────
@interface HadesNetflixProfile : NSObject
@property (nonatomic, readonly) NSString *profileId;
@property (nonatomic, readonly) NSString *displayName;
@end

// ── Access Event ─────────────────────────────────────────────────────────────
@interface HadesNetflixAccessEvent : NSObject
@property (nonatomic, readonly) BOOL hasAccess;
@end

// ── Blob Container ───────────────────────────────────────────────────────────
// Game import: _OBJC_CLASS_$_NetflixBlobContainer
@interface NetflixBlobContainer : NSObject
- (instancetype)initWithData:(NSData *)data;
@property (nonatomic, readonly) NSData *data;
@end

// ── Main SDK ─────────────────────────────────────────────────────────────────
// Game import: _OBJC_CLASS_$__TtC12NetflixGames15NetflixGamesSDK (Swift-mangled).
// objc_runtime_name ép symbol xuất ra đúng tên Swift-mangled đó.
__attribute__((objc_runtime_name("_TtC12NetflixGames15NetflixGamesSDK")))
@interface NetflixGamesSDK : NSObject

+ (instancetype)sharedInstance;

// Profile API
- (HadesNetflixProfile *)currentProfileAndReturnError:(NSError **)error;
- (HadesNetflixProfile *)activeProfile;

// Access API
- (void)requestPlayerAccessWithCompletionHandler:(void(^)(BOOL granted, NSError *error))handler;
- (void)onPlayerAccessChangeWithAccessEvent:(HadesNetflixAccessEvent *)event;
- (void)showNetflixAccessButton;
- (void)hideNetflixAccessButton;

// Blob Store / Cloud Save
- (void)playerBlobsWithCompletionHandler:(void(^)(NSArray *blobs, NSError *error))handler;
- (void)readPlayerBlobWithName:(NSString *)name completionHandler:(void(^)(NetflixBlobContainer *blob, NSError *error))handler;
- (void)writePlayerBlobWithName:(NSString *)name blobContainer:(NetflixBlobContainer *)container completionHandler:(void(^)(BOOL success, NSError *error))handler;
- (void)deletePlayerBlobWithName:(NSString *)name completionHandler:(void(^)(BOOL success, NSError *error))handler;

// Achievements
- (void)unlockAchievementWithAchievementName:(NSString *)name completionHandler:(void(^)(BOOL success, NSError *error))handler;

@end

// ── Analytics event classes ──────────────────────────────────────────────────
// Game import các class này trực tiếp (classref). Game chỉ tạo instance rồi
// đẩy vào analytics; stub rỗng kế thừa NSObject là đủ để dyld bind + alloc/init.
@interface FirstTimeUserExperienceStart : NSObject @end
@interface FirstTimeUserExperienceStepComplete : NSObject @end
@interface FirstTimeUserExperienceComplete : NSObject @end
@interface NewGameStart : NSObject @end
@interface GameComplete : NSObject @end
@interface ProgressCheckpointComplete : NSObject @end

// ── Splash ───────────────────────────────────────────────────────────────────
@interface NetflixSplashViewController : UIViewController
@end
