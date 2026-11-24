// iPASTORENetflixHades.dylib — stub bypass login
// Load path: @executable_path/Frameworks/iPASTORENetflixHades.dylib
// Dylib này trong bản crack gốc bypass màn hình Netflix login.
// Stub này đủ để dyld không crash; login bypass được xử lý bởi
// NetflixGamesSDK stub (requestPlayerAccess luôn trả về YES).

#import <Foundation/Foundation.h>

__attribute__((constructor))
static void iPASTOREInit(void) {
    NSLog(@"[iPASTORENetflixHades] loaded (stub)");
}
