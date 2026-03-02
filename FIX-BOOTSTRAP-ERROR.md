# Fix: "Failed to load Flutter bootstrap script"

## ✅ Solution Applied

I've fixed the script loading in `web/index.html`. The script now loads statically (Flutter's standard way) which properly respects the base href.

## 🔍 What Was Wrong

The script was being loaded dynamically via JavaScript, which can cause issues with:
- Base href resolution
- Loading order
- Error detection

## ✅ What's Fixed

1. **Static Script Tag**: Changed to Flutter's standard `<script src="flutter_bootstrap.js" async></script>`
2. **Better Error Handling**: Improved error detection for script loading failures
3. **Base Href Support**: Script now properly respects the base href tag

## 🚀 Next Steps

### 1. Rebuild Your App
```powershell
.\build-web.ps1
```

### 2. Test Locally First
```powershell
.\test-local-server.ps1
```
Then open: http://localhost:8000

**If it works locally but not on your server:**
- The issue is with your server configuration
- See deployment guide below

**If it doesn't work locally:**
- Check browser console (F12) for errors
- Verify all files exist in `build/web/`

### 3. Deploy to Your Server

#### For Root Domain:
```powershell
flutter build web --no-tree-shake-icons --release
# Upload ALL files from build/web/ to your server's root
```

#### For Subdirectory (e.g., /ec/):
```powershell
flutter build web --no-tree-shake-icons --release --base-href "/ec/"
# Upload ALL files from build/web/ to your server's /ec/ directory
```

## ⚠️ Important: Server Configuration

Your server MUST:
1. ✅ Serve `index.html` for all routes (SPA routing)
2. ✅ Serve `.js` files with correct MIME type: `application/javascript`
3. ✅ Support the base href path you used in build

### Apache (.htaccess)
```apache
RewriteEngine On
RewriteBase /
RewriteRule ^index\.html$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.html [L]
```

### Nginx
```nginx
location / {
    try_files $uri $uri/ /index.html;
}
```

## 🐛 Still Getting Error?

### Check Browser Console (F12)
1. Open DevTools (F12)
2. Go to **Console** tab
3. Look for red errors
4. Go to **Network** tab
5. Reload page
6. Check if `flutter_bootstrap.js` shows 404

### Common Issues:

**404 Error on flutter_bootstrap.js**
- ✅ Files not uploaded correctly
- ✅ Base href mismatch
- ✅ Wrong deployment path

**CORS Error**
- ✅ Files served from different domain
- ✅ Server CORS configuration

**Service Worker Error**
- ✅ Clear browser cache
- ✅ Unregister service worker in DevTools

## 📋 Verification Checklist

After deploying:
- [ ] All files from `build/web/` uploaded
- [ ] Base href matches deployment path
- [ ] Server configured for SPA routing
- [ ] Tested locally first (works)
- [ ] Browser cache cleared
- [ ] Checked browser console (no errors)

## 🎯 Quick Test

Open browser console and run:
```javascript
fetch('flutter_bootstrap.js')
  .then(r => console.log('✅ Bootstrap found:', r.status))
  .catch(e => console.error('❌ Bootstrap error:', e));
```

If this returns 404, the file isn't accessible (upload or path issue).
If it returns 200, the file is accessible (different issue).

---

**The fix is applied!** Rebuild and test. If you still see the error, check the browser console for the specific issue.
