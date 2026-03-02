# Test Flutter Web Build Locally
# This helps identify if the issue is with build files or server configuration

Write-Host "`n🌐 Starting Local Test Server..." -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

# Check if Python is available
$pythonCmd = $null
if (Get-Command python -ErrorAction SilentlyContinue) {
    $pythonCmd = "python"
} elseif (Get-Command python3 -ErrorAction SilentlyContinue) {
    $pythonCmd = "python3"
} elseif (Get-Command py -ErrorAction SilentlyContinue) {
    $pythonCmd = "py"
}

if ($pythonCmd) {
    Write-Host "✓ Python found: $pythonCmd" -ForegroundColor Green
    Write-Host "`n📂 Starting server in build\web..." -ForegroundColor Cyan
    Write-Host "`n🌐 Server will be available at:" -ForegroundColor Yellow
    Write-Host "   http://localhost:8000" -ForegroundColor White
    Write-Host "`n⚠️  Press Ctrl+C to stop the server" -ForegroundColor Yellow
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
    Write-Host ""
    
    Push-Location "build\web"
    & $pythonCmd -m http.server 8000
    Pop-Location
} else {
    Write-Host "❌ Python not found!" -ForegroundColor Red
    Write-Host "`n💡 Alternative options:" -ForegroundColor Yellow
    Write-Host "   1. Install Python: https://www.python.org/downloads/" -ForegroundColor White
    Write-Host "   2. Use Node.js: npm install -g http-server" -ForegroundColor White
    Write-Host "      Then run: http-server build\web -p 8000" -ForegroundColor White
    Write-Host "   3. Use VS Code Live Server extension" -ForegroundColor White
    Write-Host "   4. Use Flutter's dev server: flutter run -d chrome --web-port=8000" -ForegroundColor White
}
