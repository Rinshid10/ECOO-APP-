# Flutter Web Build Script
# This script builds your Flutter web app with the correct flags

Write-Host "`n🚀 Building Flutter Web App..." -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

# Build command with necessary flags
flutter build web --no-tree-shake-icons --release

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ Build successful!" -ForegroundColor Green
    Write-Host "📦 Output: build\web\" -ForegroundColor Cyan
    Write-Host "`n💡 Next steps:" -ForegroundColor Yellow
    Write-Host "   1. Upload the contents of 'build\web' to your hosting provider" -ForegroundColor White
    Write-Host "   2. Or use: .\deploy-firebase.ps1 (if Firebase is set up)" -ForegroundColor White
} else {
    Write-Host "`n❌ Build failed!" -ForegroundColor Red
    Write-Host "Check the error messages above for details." -ForegroundColor Yellow
    exit 1
}
