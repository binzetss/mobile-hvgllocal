# Deploy Flutter Web to IIS - PowerShell Script
# Sửa các biến dưới đây trước khi chạy

# ============ CẤU HÌNH ============
$SERVER_IP = "192.168.1.100"           # IP server IIS của bạn
$SERVER_USER = "Administrator"          # Username server
$IIS_PATH = "C:\inetpub\wwwroot\hvgl"  # Path trên IIS server
$LOCAL_BUILD_PATH = "D:\Appmobilenoibo\hvgl\build\web"  # Path build local

# ============ DEPLOY ============

Write-Host "🚀 Bắt đầu deployment..." -ForegroundColor Green

# 1. Build Flutter Web (Release)
Write-Host "`n📦 Building Flutter Web..." -ForegroundColor Cyan
Set-Location "D:\Appmobilenoibo\hvgl"
flutter build web --release

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Build thất bại!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Build thành công!" -ForegroundColor Green

# 2. Copy files to IIS Server
Write-Host "`n📤 Copying files to server..." -ForegroundColor Cyan

# Tạo session ke server (nếu chưa connect)
$credential = Get-Credential -Message "Nhập thông tin server IIS" -UserName $SERVER_USER

# Copy folder build/web lên server
$sourcePath = $LOCAL_BUILD_PATH
$destinationPath = "\\$SERVER_IP\$($IIS_PATH -replace 'C:', 'C$')"

# Nếu folder đích tồn tại, backup trước
if (Test-Path $destinationPath) {
    Write-Host "📁 Backing up old files..." -ForegroundColor Yellow
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupPath = "\\$SERVER_IP\$($IIS_PATH -replace 'C:', 'C$')_backup_$timestamp"
    Copy-Item -Path $destinationPath -Destination $backupPath -Recurse -Force
    Write-Host "✅ Backup saved: $backupPath" -ForegroundColor Green
    
    # Clear folder
    Remove-Item -Path "$destinationPath\*" -Recurse -Force
}

# Copy files
Copy-Item -Path "$sourcePath\*" -Destination $destinationPath -Recurse -Force -Credential $credential

Write-Host "✅ Files copied successfully!" -ForegroundColor Green

# 3. Reset IIS (CÓ THỂ CẦN CHẠY GÓC ADMIN)
Write-Host "`n🔄 Resetting IIS..." -ForegroundColor Cyan
try {
    Invoke-Command -ComputerName $SERVER_IP -ScriptBlock {
        iisreset
    } -Credential $credential
    Write-Host "✅ IIS reset successful!" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Không thể reset IIS từ xa. Vui lòng chạy 'iisreset' thủ công trên server" -ForegroundColor Yellow
}

# 4. Kiểm tra deployment
Write-Host "`n✅ Deployment hoàn tất!" -ForegroundColor Green
Write-Host "🌐 Truy cập: http://$SERVER_IP" -ForegroundColor Cyan
Write-Host "📁 Server path: $IIS_PATH" -ForegroundColor Cyan

Write-Host "`n💡 Lưu ý:" -ForegroundColor Yellow
Write-Host "  - Đảm bảo URL Rewrite module đã cài trên IIS"
Write-Host "  - File web.config phải nằm tại: $IIS_PATH\web.config"
Write-Host "  - Chạy 'iisreset' nếu gặp lỗi 404"
