# Flutter Web Build Guide

## ⚠️ Important: Always Use `--no-tree-shake-icons` Flag

Your Flutter web build **requires** the `--no-tree-shake-icons` flag due to a known issue with icon tree-shaking.

## 🚀 Quick Build

### Option 1: Use the Build Script (Recommended)
```powershell
.\build-web.ps1
```

### Option 2: Manual Build
```powershell
flutter build web --no-tree-shake-icons --release
```

## ❌ Why Not Just `flutter build web`?

If you run `flutter build web` without the flag, you'll get this error:
```
The value '0' (0) could not be parsed as a valid unicode codepoint; aborting.
IconTreeShakerException: Font subsetting failed with exit code -1.
```

This is a known Flutter bug with icon tree-shaking on Windows. The `--no-tree-shake-icons` flag disables this feature and allows the build to succeed.

## 📋 Build Flags Explained

- `--no-tree-shake-icons` - **Required** - Disables icon tree-shaking (fixes build error)
- `--release` - Builds in release mode (optimized, smaller size)
- `--base-href "/path/"` - Use if deploying to a subdirectory (e.g., GitHub Pages)

## 🎯 Build Output

After successful build:
- Location: `build/web/`
- Contains: All files needed to host your web app
- Size: ~2-5 MB (without tree-shaking, slightly larger but works!)

## 🔄 Alternative: Update Flutter

If you want to try fixing the tree-shaking issue:
```powershell
flutter upgrade
```

Then try building without the flag. However, the flag is safe to use and doesn't significantly impact performance.

## 📝 Build Scripts

- `build-web.ps1` - Simple build script
- `scripts/deploy-firebase.ps1` - Build + Deploy to Firebase
- `scripts/deploy-github.ps1` - Build + Deploy to GitHub Pages
- `scripts/deploy-netlify.ps1` - Build + Deploy to Netlify

## ✅ Verification

After building, check:
1. `build/web/index.html` exists
2. `build/web/main.dart.js` exists
3. `build/web/assets/` folder contains fonts and assets
4. No errors in the build output

Your app is ready to deploy! 🎉
