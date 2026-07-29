# Script untuk memperbaiki error indexing di IDE
Write-Host "Memperbaiki error indexing Flutter..." -ForegroundColor Green

# 1. Flutter clean
Write-Host "`n1. Membersihkan build cache..." -ForegroundColor Yellow
flutter clean

# 2. Flutter pub get
Write-Host "`n2. Menginstall dependencies..." -ForegroundColor Yellow
flutter pub get

# 3. Flutter pub cache repair
Write-Host "`n3. Memperbaiki pub cache..." -ForegroundColor Yellow
flutter pub cache repair

Write-Host "`n✅ Selesai! Sekarang:" -ForegroundColor Green
Write-Host "1. Tutup VS Code/Android Studio sepenuhnya" -ForegroundColor Cyan
Write-Host "2. Buka kembali project" -ForegroundColor Cyan
Write-Host "3. Tunggu beberapa menit hingga IDE selesai indexing" -ForegroundColor Cyan
Write-Host "`nAtau di VS Code:" -ForegroundColor Yellow
Write-Host "- Tekan Ctrl+Shift+P" -ForegroundColor Cyan
Write-Host "- Ketik 'Dart: Restart Analysis Server'" -ForegroundColor Cyan
Write-Host "- Pilih opsi tersebut" -ForegroundColor Cyan

