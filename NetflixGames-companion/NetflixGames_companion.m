// NetflixGames-companion.framework — stub
// Được load trực tiếp bởi Game.iOS.Netflix (LC_LOAD_DYLIB).
// Không có thông tin về API cụ thể — stub rỗng đủ để dyld resolve.

#import <Foundation/Foundation.h>

// Constructor chạy khi framework được load
__attribute__((constructor))
static void NetflixGamesCompanionInit(void) {
    NSLog(@"[NetflixGames-companion] loaded (stub)");
}
