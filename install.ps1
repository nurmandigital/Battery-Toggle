#Requires -RunAsAdministrator

$sourceFile = Join-Path $PSScriptRoot "toggle-battery.ps1"
$installDir = "$env:ProgramFiles\NurmanDigital\BatteryToggle"
$targetFile = Join-Path $installDir "toggle-battery.ps1"
$wrapperFile = Join-Path $installDir "battery-toggle.cmd"

Write-Host "  +------------------------------------------+" -ForegroundColor Cyan
Write-Host "  |  NURMAN DIGITAL - Battery Toggle v1.0    |" -ForegroundColor Cyan
Write-Host "  |          I N S T A L L E R               |" -ForegroundColor Cyan
Write-Host "  +------------------------------------------+" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $sourceFile)) {
    Write-Host "  [ERROR] toggle-battery.ps1 tidak ditemukan!" -ForegroundColor Red
    Write-Host "  Jalankan install.ps1 dari folder yang sama dengan toggle-battery.ps1" -ForegroundColor Yellow
    exit 1
}

if (-not (Test-Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir -Force | Out-Null
    Write-Host "  [+] Folder dibuat: $installDir" -ForegroundColor Green
}

Copy-Item -Path $sourceFile -Destination $targetFile -Force
Write-Host "  [+] toggle-battery.ps1 disalin ke $installDir" -ForegroundColor Green

$wrapperContent = @'
@echo off
powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0toggle-battery.ps1" %*
'@
Set-Content -Path $wrapperFile -Value $wrapperContent -Encoding ASCII
Write-Host "  [+] battery-toggle.cmd dibuat di $installDir" -ForegroundColor Green

$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
$installDirUser = [Environment]::GetFolderPath("UserProfile") + "\AppData\Local\NurmanDigital\BatteryToggle"

if ($userPath -notlike "*$installDir*" -and $userPath -notlike "*$installDirUser*") {
    $confirm = Read-Host "  Tambah ke PATH user agar bisa dipanggil dari mana aja? [Y/N]"
    if ($confirm -eq "Y") {
        [Environment]::SetEnvironmentVariable("Path", $userPath + ";$installDir", "User")
        Write-Host "  [+] Folder ditambahkan ke PATH user" -ForegroundColor Green
        Write-Host "  [!] Restart PowerShell atau buka terminal baru agar PATH berlaku" -ForegroundColor Yellow
    } else {
        Write-Host "  [-] PATH tidak diubah" -ForegroundColor DarkGray
    }
} else {
    Write-Host "  [i] Folder sudah ada di PATH" -ForegroundColor DarkCyan
}

Write-Host ""
Write-Host "  +------------------------------------------+" -ForegroundColor Green
Write-Host "  |  INSTALLASI SELESAI!                      |" -ForegroundColor Green
Write-Host "  +------------------------------------------+" -ForegroundColor Green
Write-Host ""
Write-Host "  Setelah restart PowerShell, bisa pake dari mana aja:" -ForegroundColor Cyan
Write-Host "    battery-toggle           Toggle otomatis" -ForegroundColor DarkGray
Write-Host "    battery-toggle -Disable  Paksa putus baterai" -ForegroundColor DarkGray
Write-Host "    battery-toggle -Enable   Paksa sambung baterai" -ForegroundColor DarkGray
Write-Host ""
