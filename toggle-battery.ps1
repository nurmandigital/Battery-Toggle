#Requires -RunAsAdministrator

param(
    [ValidateSet("Toggle", "Enable", "Disable")]
    [string]$Action = "Toggle"
)

function Show-Spinner {
    param([int]$Seconds)
    $frames = @("|", "/", "-", "\")
    $end = (Get-Date).AddSeconds($Seconds)
    while ((Get-Date) -lt $end) {
        foreach ($f in $frames) {
            Write-Host "`r  $f Memproses..." -NoNewline -ForegroundColor Cyan
            Start-Sleep -Milliseconds 100
        }
    }
    Write-Host "`r" -NoNewline
}

function Show-Progress {
    param([string]$Text, [int]$Duration = 2)
    $width = 30
    for ($i = 0; $i -le $width; $i++) {
        $pct = [math]::Round($i / $width * 100)
        $bar = "#" * $i + "-" * ($width - $i)
        Write-Host "`r  $Text [$bar] $pct%" -NoNewline -ForegroundColor Green
        Start-Sleep -Milliseconds ($Duration * 1000 / $width)
    }
    Write-Host ""
}

function Show-Banner {
    Write-Host ""
    Write-Host "  +------------------------------------------+" -ForegroundColor Cyan
    Write-Host "  |  NURMAN DIGITAL - Battery Toggle v1.0    |" -ForegroundColor Cyan
    Write-Host "  +------------------------------------------+" -ForegroundColor Cyan
    Write-Host ""
}

$batteryDevice = Get-PnpDevice -Class Battery `
    -FriendlyName "*Control Method Battery*" `
    -ErrorAction SilentlyContinue

if (-not $batteryDevice) {
    Clear-Host
    Show-Banner
    Write-Host "  [ERROR] Baterai tidak ditemukan!" -ForegroundColor Red
    Write-Host ""
    exit 1
}

$acAdapter = Get-PnpDevice -Class Battery `
    -FriendlyName "*AC Adapter*" `
    -ErrorAction SilentlyContinue

$acConnected = $acAdapter.Status -eq "OK"

function Show-Status {
    $b = Get-PnpDevice -InstanceId $batteryDevice.InstanceId -ErrorAction SilentlyContinue
    $bat = Get-CimInstance -ClassName Win32_Battery
    $icon = if ($b.Status -eq "OK") { "[BATT]" } else { "[AC  ]" }
    $label = if ($b.Status -eq "OK") { "TERHUBUNG" } else { "TERPUTUS" }
    $color = if ($b.Status -eq "OK") { "Yellow" } else { "Cyan" }

    Write-Host "  +------------------------------------------+" -ForegroundColor DarkGray
    Write-Host "  | $icon Status : " -NoNewline -ForegroundColor DarkGray
    Write-Host $label.PadRight(24) -NoNewline -ForegroundColor $color
    Write-Host "|" -ForegroundColor DarkGray
    if ($bat -and $bat.EstimatedChargeRemaining) {
        $pct = $bat.EstimatedChargeRemaining
        $barLen = [math]::Floor($pct / 5)
        $barFill = "#" * $barLen
        $barEmpty = "-" * (20 - $barLen)
        Write-Host "  |  Daya   : $pct%  $barFill$barEmpty|" -ForegroundColor DarkGray
    }
    if ($acConnected) {
        Write-Host "  |  AC     : Terhubung                    |" -ForegroundColor DarkGray
    } else {
        Write-Host "  |  AC     : Tidak terhubung              |" -ForegroundColor DarkRed
    }
    Write-Host "  +------------------------------------------+" -ForegroundColor DarkGray
    Write-Host ""
}

Clear-Host
Show-Banner
Show-Status

Write-Host "  Cara pakai:" -ForegroundColor DarkCyan
Write-Host "    .\toggle-battery.ps1           Toggle otomatis" -ForegroundColor DarkGray
Write-Host "    .\toggle-battery.ps1 -Disable  Paksa putus baterai" -ForegroundColor DarkGray
Write-Host "    .\toggle-battery.ps1 -Enable   Paksa sambung baterai" -ForegroundColor DarkGray
Write-Host ""

switch ($Action) {
    "Disable" {
        if (-not $acConnected) {
            Write-Host "  [ERROR] AC tidak terhubung! Baterai tidak bisa dimatikan." -ForegroundColor Red
            Write-Host ""
            exit 1
        }
        if ($batteryDevice.Status -eq "OK") {
            $confirm = Read-Host "  Putus koneksi baterai. Yakin? [Y/N]"
            if ($confirm -ne "Y") {
                Write-Host "  Dibatalkan." -ForegroundColor Yellow
                Write-Host ""
                exit 0
            }
            Show-Progress "Memutus koneksi baterai" 1.5
            Disable-PnpDevice -InstanceId $batteryDevice.InstanceId -Confirm:$false | Out-Null
        } else {
            Write-Host "  [!] Baterai sudah dalam keadaan terputus." -ForegroundColor Yellow
        }
    }
    "Enable" {
        if ($batteryDevice.Status -ne "OK") {
            $confirm = Read-Host "  Sambung kembali baterai. Yakin? [Y/N]"
            if ($confirm -ne "Y") {
                Write-Host "  Dibatalkan." -ForegroundColor Yellow
                Write-Host ""
                exit 0
            }
            Show-Progress "Menyambung kembali baterai" 1.5
            Enable-PnpDevice -InstanceId $batteryDevice.InstanceId -Confirm:$false | Out-Null
        } else {
            Write-Host "  [!] Baterai sudah dalam keadaan terhubung." -ForegroundColor Yellow
        }
    }
    "Toggle" {
        if ($batteryDevice.Status -eq "OK") {
            if (-not $acConnected) {
                Write-Host "  [ERROR] AC tidak terhubung! Baterai tidak bisa dimatikan." -ForegroundColor Red
                Write-Host ""
                exit 1
            }
            $confirm = Read-Host "  Putus koneksi baterai. Yakin? [Y/N]"
            if ($confirm -ne "Y") {
                Write-Host "  Dibatalkan." -ForegroundColor Yellow
                Write-Host ""
                exit 0
            }
            Show-Progress "Memutus koneksi baterai" 1.5
            Disable-PnpDevice -InstanceId $batteryDevice.InstanceId -Confirm:$false | Out-Null
        } else {
            $confirm = Read-Host "  Sambung kembali baterai. Yakin? [Y/N]"
            if ($confirm -ne "Y") {
                Write-Host "  Dibatalkan." -ForegroundColor Yellow
                Write-Host ""
                exit 0
            }
            Show-Progress "Menyambung kembali baterai" 1.5
            Enable-PnpDevice -InstanceId $batteryDevice.InstanceId -Confirm:$false | Out-Null
        }
    }
}

Start-Sleep -Milliseconds 500
Clear-Host
Show-Banner
Write-Host "  [OK] Operasi selesai!" -ForegroundColor Green
Write-Host ""
Show-Status
Write-Host ""
Write-Host "  Created with <3 by Nurman Digital" -ForegroundColor DarkGray
Write-Host "  github.com/nurmandigital" -ForegroundColor DarkGray
Write-Host ""
