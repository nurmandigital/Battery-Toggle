#Requires -RunAsAdministrator

$installDir = "$env:ProgramFiles\NurmanDigital\BatteryToggle"

Write-Host "  +------------------------------------------+" -ForegroundColor Cyan
Write-Host "  |  NURMAN DIGITAL - Battery Toggle v1.0    |" -ForegroundColor Cyan
Write-Host "  |      U N I N S T A L L E R               |" -ForegroundColor Cyan
Write-Host "  +------------------------------------------+" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $installDir)) {
    Write-Host "  [!] Battery Toggle tidak ditemukan di $installDir" -ForegroundColor Yellow
    Write-Host ""
    exit 0
}

$confirm = Read-Host "  Hapus Battery Toggle? [Y/N]"
if ($confirm -ne "Y") {
    Write-Host "  Dibatalkan" -ForegroundColor Yellow
    Write-Host ""
    exit 0
}

$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -like "*$installDir*") {
    $newPath = ($userPath -split ";" | Where-Object { $_ -ne $installDir }) -join ";"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "  [+] Folder dihapus dari PATH" -ForegroundColor Green
}

Remove-Item -Path $installDir -Recurse -Force
Write-Host "  [+] Folder $installDir dihapus" -ForegroundColor Green

Write-Host ""
Write-Host "  +------------------------------------------+" -ForegroundColor Green
Write-Host "  |  UNINSTALL SELESAI!                       |" -ForegroundColor Green
Write-Host "  +------------------------------------------+" -ForegroundColor Green
Write-Host ""
Write-Host "  Restart PowerShell agar PATH benar-benar bersih" -ForegroundColor Cyan
Write-Host "  Folder project di $PSScriptRoot tetap ada" -ForegroundColor DarkGray
Write-Host ""
