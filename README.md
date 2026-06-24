# Battery Toggle v1.0

**by Nurman Digital**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Script PowerShell untuk memutus & menyambung koneksi baterai laptop secara software. Ideal untuk laptop yang sering dicas terus-menerus - baterai bisa "dicabut" tanpa colok-lepas fisik.

---

## Instalasi

### 1. Download repo

```powershell
git clone https://github.com/nurmandigital/Battery-Toggle.git
cd Battery-Toggle
```

Atau download ZIP dari [GitHub Releases](https://github.com/nurmandigital/Battery-Toggle/releases) dan ekstrak.

### 2. Jalankan installer

```powershell
# Pastikan masih di folder Battery-Toggle/
.\install.ps1
```

Installer akan:
- Copy toggle-battery.ps1 ke `C:\Program Files\NurmanDigital\BatteryToggle\`
- Buat file `battery-toggle.cmd` di folder yang sama
- Tanya: tambah ke PATH? Pilih Y

### 3. Selesai

Restart PowerShell. Sekarang tinggal ketik `battery-toggle` dari mana aja.

---

## Cara Pakai

Setelah install, dari terminal mana pun (termasuk `C:\Windows\system32`):

```powershell
battery-toggle           # Toggle otomatis (putus/sambung)
battery-toggle -Disable  # Paksa putus baterai
battery-toggle -Enable   # Paksa sambung baterai
```

Sebelum install (dari folder repo):
```powershell
.\toggle-battery.ps1           # Toggle otomatis
.\toggle-battery.ps1 -Disable  # Paksa putus baterai
.\toggle-battery.ps1 -Enable   # Paksa sambung baterai
```

---

## Uninstall

```powershell
# Buka folder repo / download ulang lalu
.\uninstall.ps1
```

Atau hapus manual:
```powershell
# PowerShell sebagai Administrator
Remove-Item -Path "$env:ProgramFiles\NurmanDigital\BatteryToggle" -Recurse -Force -ErrorAction SilentlyContinue
[Environment]::SetEnvironmentVariable("Path", (([Environment]::GetEnvironmentVariable("Path", "User") -split ";" | Where-Object { $_ -ne "$env:ProgramFiles\NurmanDigital\BatteryToggle" }) -join ";"), "User")
```

Dua-duanya akan:
- Hapus folder `C:\Program Files\NurmanDigital\BatteryToggle\`
- Hapus PATH entry
- File project tetap ada di folder repo

---

## Syarat & Peringatan

| Syarat | Keterangan |
|---|---|
| Run as Admin | Wajib, karena disable/enable device |
| AC terhubung | Charger HARUS colok saat mau putus baterai |
| Jangan cabut charger | Setelah baterai disabled, kalau charger dicabut -> laptop langsung mati |

---

## Cara Kerja

1. Menampilkan status baterai & AC saat ini
2. Meminta konfirmasi [Y/N] sebelum eksekusi
3. Disable/enable device baterai via Windows PnP
4. Tampilkan status akhir setelah operasi

---

## Kompatibilitas

- Semua laptop Windows dengan baterai ACPI
- Tidak terbatas brand tertentu
- Tested on: ASUS VivoBook X415EA

---

## Teknologi

- PowerShell 5.1+
- Windows PnP Device Management
- WMI Win32_Battery

---

## Lisensi

[MIT](LICENSE) &copy; 2026 Nurman Digital
