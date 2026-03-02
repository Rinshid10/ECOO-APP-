# Debugging White Screen / Bootstrap Loading Error

## 🔍 Issue: "Failed to load Flutter bootstrap script"

This error means the browser cannot find or load `flutter_bootstrap.js`.

## ✅ Quick Fixes

### 1. **Check File Existence**
Verify these files exist in `build/web/`:
- ✅ `flutter_bootstrap.js`
- ✅ `flutter.js`
- ✅ `main.dart.js`
- ✅ `index.html`

### 2. **Check Browser Console (F12)**
Open browser DevTools (F12) and check:
- **Console Tab**: Look for 404 errors or CORS errors
- **Network Tab**: Check if `flutter_bootstrap.js` returns 404

### 3. **Common Causes & Solutions**

#### A. **Files Not Uploaded**
**Problem**: Not all files from `build/web/` were uploaded to server.

**Solution**: 
- Upload ALL contents of `build/web/` folder
- Don't skip any files or folders
- Ensure folder structure is preserved

#### B. **Base Href Mismatch**
**Problem**: App built with `--base-href` but served from different path.

**Solution**:
- If deploying to root: `flutter build web --no-tree-shake-icons --release`
- If deploying to subdirectory: `flutter build web --no-tree-shake-icons --release --base-href "/your-path/"`

#### C. **Server Configuration**
**Problem**: Server not configured for SPA routing.

**Solution**: 
- Configure server to serve `index.html` for all routes
- See `server-configs/` folder for examples

#### D. **CORS Issues**
**Problem**: Cross-origin resource sharing blocking files.

**Solution**: 
- Ensure all files served from same domain
- Check server CORS headers

#### E. **Service Worker Issues**
**Problem**: Old service worker caching broken files.

**Solution**:
1. Open DevTools (F12)
2. Go to **Application** tab
3. Click **Service Workers**
4. Click **Unregister**
5. Clear cache and reload

### 4. **Test Locally First**

Before deploying, test locally:

```powershell
# Option 1: Use Flutter's built-in server
cd build/web
python -m http.server 8000
# Or
python3 -m http.server 8000

# Then open: http://localhost:8000
```

Or use a simple HTTP server:
```powershell
# Install if needed: npm install -g http-server
cd build/web
http-server -p 8000
```

### 5. **Verify Build Output**

Check that build completed successfully:
```powershell
flutter build web --no-tree-shake-icons --release
# Should end with: √ Built build\web
```

### 6. **Check File Sizes**

Files should have reasonable sizes:
- `flutter_bootstrap.js`: ~10-50 KB
- `main.dart.js`: ~500 KB - 2 MB
- `flutter.js`: ~50-200 KB

If files are 0 bytes or missing, rebuild.

## 🐛 Step-by-Step Debugging

1. **Open Browser DevTools (F12)**
2. **Go to Network Tab**
3. **Reload Page**
4. **Look for Red Entries** (failed requests)
5. **Check the Request URL** - Is it correct?
6. **Check Response** - 404? CORS error? Other?

## 📋 Deployment Checklist

Before deploying, ensure:
- [ ] Build completed without errors
- [ ] All files in `build/web/` exist
- [ ] Base href matches deployment path
- [ ] Server configured for SPA routing
- [ ] Tested locally first
- [ ] Browser cache cleared
- [ ] Service workers unregistered (if needed)

## 🔧 Quick Test Script

Create a test file `test-build.html` in `build/web/`:

```html
<!DOCTYPE html>
<html>
<head>
  <title>Build Test</title>
</head>
<body>
  <h1>Build Files Check</h1>
  <script>
    const files = [
      'flutter_bootstrap.js',
      'flutter.js',
      'main.dart.js',
      'index.html'
    ];
    
    files.forEach(file => {
      fetch(file)
        .then(r => console.log(`✅ ${file}: ${r.status}`))
        .catch(e => console.error(`❌ ${file}: ${e.message}`));
    });
  </script>
</body>
</html>
```

Open this file in browser to check if files are accessible.

## 💡 Most Common Fix

**90% of cases**: Files not uploaded correctly or base href mismatch.

**Solution**:
1. Rebuild: `flutter build web --no-tree-shake-icons --release`
2. Upload ALL files from `build/web/` to server
3. Ensure base href matches your deployment path
4. Clear browser cache
5. Test again

## 📞 Still Not Working?

If still having issues:
1. Check browser console (F12) for specific error
2. Verify file paths in Network tab
3. Check server logs for errors
4. Ensure server supports serving `.js` files with correct MIME type
