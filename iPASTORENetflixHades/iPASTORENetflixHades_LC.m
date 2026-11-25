// iPASTORENetflixHades.dylib — stub + window fix
// Load path: @executable_path/Frameworks/iPASTORENetflixHades.dylib
//
// Vấn đề: AppDelegate của game (application:didFinishLaunchingWithOptions:) gọi
//   [[self window] setRootViewController:<NetflixSplash VC>]
// nhưng window vốn do Main.storyboard tạo. Bản này không có Main storyboard hợp lệ
// nên [self window] == nil -> splash gán vào nil -> không có window nào -> màn đen.
// Fix: thay getter -window của AppDelegate: nếu nil thì tạo UIWindow, gán lại và hiện lên.
// Chỉ dùng Foundation + objc runtime (không cần link UIKit, workflow giữ nguyên).

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <mach-o/dyld.h>
#include <string.h>

#define HLOG(fmt, ...) NSLog(@"[HadesStub] " fmt, ##__VA_ARGS__)

typedef struct { double x, y, w, h; } HRect;

static IMP gOrigWindow = NULL;
static void HadesRequestLandscape(void);
static BOOL gMadeWindow = NO;

static id HadesFindWindowScene(void) {
    id app = ((id(*)(id, SEL))objc_msgSend)((id)NSClassFromString(@"UIApplication"), sel_registerName("sharedApplication"));
    if (!app) return nil;
    id scenes = ((id(*)(id, SEL))objc_msgSend)(app, sel_registerName("connectedScenes"));
    Class wsCls = NSClassFromString(@"UIWindowScene");
    for (id s in scenes) if ([s isKindOfClass:wsCls]) return s;
    return nil;
}

static id HadesWindowGetter(id self, SEL _cmd) {
    id w = gOrigWindow ? ((id(*)(id, SEL))gOrigWindow)(self, _cmd) : nil;
    if (w || gMadeWindow) return w;
    gMadeWindow = YES;

    Class winCls = NSClassFromString(@"UIWindow");
    id scene = HadesFindWindowScene();
    if (scene) {
        w = ((id(*)(id, SEL, id))objc_msgSend)([winCls alloc], sel_registerName("initWithWindowScene:"), scene);
        HLOG(@"window was nil -> created UIWindow with scene");
    } else {
        id screen = ((id(*)(id, SEL))objc_msgSend)((id)NSClassFromString(@"UIScreen"), sel_registerName("mainScreen"));
        HRect r = ((HRect(*)(id, SEL))objc_msgSend)(screen, sel_registerName("bounds"));
        w = ((id(*)(id, SEL, HRect))objc_msgSend)([winCls alloc], sel_registerName("initWithFrame:"), r);
        HLOG(@"window was nil -> created UIWindow with screen bounds %.0fx%.0f", r.w, r.h);
    }
    if ([self respondsToSelector:sel_registerName("setWindow:")])
        ((void(*)(id, SEL, id))objc_msgSend)(self, sel_registerName("setWindow:"), w);
    ((void(*)(id, SEL))objc_msgSend)(w, sel_registerName("makeKeyAndVisible"));
    HadesRequestLandscape();
    // trả lại qua getter gốc nếu được (đã setWindow), nếu không thì trả w
    id w2 = gOrigWindow ? ((id(*)(id, SEL))gOrigWindow)(self, _cmd) : nil;
    return w2 ?: w;
}


// ── LiveContainer: ép landscape ───────────────────────────────────────────────
// Trong LiveContainer, Info.plist là của LiveContainer (cho phép portrait), nên
// Hades bị vẽ xoay/nhỏ ở góc. Ép mọi VC chỉ landscape + yêu cầu scene xoay ngang.
#define HADES_MASK_LANDSCAPE 24   // UIInterfaceOrientationMaskLandscape
static NSUInteger HadesLandscapeMask(id self, SEL _cmd) { return HADES_MASK_LANDSCAPE; }
static BOOL HadesYes(id self, SEL _cmd) { return YES; }
static NSInteger HadesPrefOrientation(id self, SEL _cmd) { return 4; } // UIInterfaceOrientationLandscapeLeft = 4

static void HadesRequestLandscape(void) {
    id scene = HadesFindWindowScene();
    if (!scene) { HLOG(@"landscape: no scene yet"); return; }
    Class prefCls = NSClassFromString(@"UIWindowSceneGeometryPreferencesIOS");
    SEL req = sel_registerName("requestGeometryUpdateWithPreferences:errorHandler:");
    if (prefCls && [scene respondsToSelector:req]) {
        id pref = ((id(*)(id, SEL, NSUInteger))objc_msgSend)([prefCls alloc], sel_registerName("initWithInterfaceOrientations:"), (NSUInteger)HADES_MASK_LANDSCAPE);
        void (^err)(NSError *) = ^(NSError *e) { HLOG(@"landscape request error: %@", e); };
        ((void(*)(id, SEL, id, id))objc_msgSend)(scene, req, pref, err);
        HLOG(@"landscape: requested geometry update");
    }
    // báo các VC cập nhật lại orientation
    id app = ((id(*)(id, SEL))objc_msgSend)((id)NSClassFromString(@"UIApplication"), sel_registerName("sharedApplication"));
    for (id w in ((id(*)(id, SEL))objc_msgSend)(scene, sel_registerName("windows"))) {
        id vc = ((id(*)(id, SEL))objc_msgSend)(w, sel_registerName("rootViewController"));
        SEL upd = sel_registerName("setNeedsUpdateOfSupportedInterfaceOrientations");
        if (vc && [vc respondsToSelector:upd]) ((void(*)(id, SEL))objc_msgSend)(vc, upd);
    }
    (void)app;
}

static void HadesForceLandscapeSetup(void) {
    Class vc = NSClassFromString(@"UIViewController");
    if (vc) {
        class_replaceMethod(vc, sel_registerName("supportedInterfaceOrientations"), (IMP)HadesLandscapeMask, "Q16@0:8");
        class_replaceMethod(vc, sel_registerName("shouldAutorotate"), (IMP)HadesYes, "B16@0:8");
        class_replaceMethod(vc, sel_registerName("preferredInterfaceOrientationForPresentation"), (IMP)HadesPrefOrientation, "q16@0:8");
    }
    // các VC của game tự override -> ép luôn trong image game
    unsigned int n = 0;
    const char *img = NULL;
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        const char *nm = _dyld_get_image_name(i);
        if (nm && strstr(nm, "/Game.iOS.Netflix")) { img = nm; break; }
    }
    if (img) {
        const char **names = objc_copyClassNamesForImage(img, &n);
        for (unsigned int i = 0; i < n; i++) {
            Class c = objc_getClass(names[i]);
            if (c && vc && [c isSubclassOfClass:vc]) {
                class_replaceMethod(c, sel_registerName("supportedInterfaceOrientations"), (IMP)HadesLandscapeMask, "Q16@0:8");
                HLOG(@"landscape forced on %s", names[i]);
            }
            SEL appMask = sel_registerName("application:supportedInterfaceOrientationsForWindow:");
            if (c && class_getInstanceMethod(c, appMask))
                class_replaceMethod(c, appMask, (IMP)HadesLandscapeMask, "Q32@0:8@16@24");
        }
        free(names);
    }
    for (double t = 0.3; t < 6; t *= 2) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(t * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ HadesRequestLandscape(); });
    }
}

__attribute__((constructor))
static void iPASTOREInit(void) {
    HLOG(@"iPASTORENetflixHades loaded (LiveContainer build)");
    HadesForceLandscapeSetup();
    // Sideload thường: game là image 0. LiveContainer: image 0 là LiveContainer,
    // game được dlopen sau -> tìm image chứa Game.iOS.Netflix thay vì lấy image 0.
    SEL dfl = sel_registerName("application:didFinishLaunchingWithOptions:");
    const char *gameImage = NULL;
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        const char *nm = _dyld_get_image_name(i);
        if (nm && strstr(nm, "/Game.iOS.Netflix")) { gameImage = nm; break; }
    }
    if (!gameImage) gameImage = _dyld_get_image_name(0);
    HLOG(@"game image: %s", gameImage);
    unsigned int n = 0;
    const char **names = objc_copyClassNamesForImage(gameImage, &n);
    BOOL hooked = NO;
    for (unsigned int i = 0; i < n; i++) {
        Class c = objc_getClass(names[i]);
        if (!c || !class_getInstanceMethod(c, dfl)) continue;
        Method m = class_getInstanceMethod(c, sel_registerName("window"));
        if (!m) { HLOG(@"%s has no -window", names[i]); continue; }
        gOrigWindow = method_getImplementation(m);
        class_replaceMethod(c, sel_registerName("window"), (IMP)HadesWindowGetter, method_getTypeEncoding(m));
        HLOG(@"hooked -[%s window]", names[i]);
        hooked = YES;
    }
    free(names);
    if (!hooked) {
        Class c = objc_getClass("AppDelegate");
        Method m = c ? class_getInstanceMethod(c, sel_registerName("window")) : NULL;
        if (m) {
            gOrigWindow = method_getImplementation(m);
            class_replaceMethod(c, sel_registerName("window"), (IMP)HadesWindowGetter, method_getTypeEncoding(m));
            HLOG(@"hooked -[AppDelegate window] (fallback by name)");
        } else HLOG(@"WARNING: AppDelegate not found, window not hooked");
    }
}
