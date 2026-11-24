# hades-stub-frameworks

Stub frameworks cho Hades (Netflix iOS) — thay thế `Frameworks/` bị thiếu trong IPA.

## Nội dung

| File | Mô tả |
|---|---|
| `NetflixGames.framework` | Stub Netflix SDK — profile luôn signed in, access luôn granted, cloud save disabled |
| `NetflixGames-companion.framework` | Stub rỗng — chỉ cần để dyld không crash |
| `DeltaDNA.framework` | Stub analytics — không khởi động gì |
| `iPASTORENetflixHades.dylib` | Stub bypass login |

## Build

Push lên `main` → GitHub Actions tự build trên macOS arm64.  
Download artifact `hades-stub-frameworks` từ tab **Actions**.

## Cài vào IPA

```
Hades.app/
└── Frameworks/
    ├── NetflixGames.framework/
    │   ├── NetflixGames       ← binary
    │   └── Info.plist
    ├── NetflixGames-companion.framework/
    │   ├── NetflixGames-companion
    │   └── Info.plist
    ├── DeltaDNA.framework/
    │   ├── DeltaDNA
    │   └── Info.plist
    └── iPASTORENetflixHades.dylib
```

Sau đó re-sign IPA bằng Sideloadly.
