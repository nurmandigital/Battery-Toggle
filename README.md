# Battery Toggle v1.0

**by Nurman Digital**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Script PowerShell untuk memutus & menyambung koneksi baterai laptop secara software. Ideal untuk laptop yang sering dicas terus-menerus — baterai bisa "dicabut" tanpa colok-lepas fisik.

---

## Instalasi

```powershell
# Clone repo
git clone https://github.com/nurmandigital/Battery-Toggle.git
cd Battery-Toggle

# Jalankan installer (sebagai Administrator)
.\install.ps1
```

Atau unduh dari [GitHub Releases](https://github.com/nurmandigital/Battery-Toggle/releases).

---

## Cara Pakai

```powershell
# Run sebagai Administrator
toggle-battery.ps1           # Toggle otomatis (putus/sambung)
toggle-battery.ps1 -Disable  # Paksa putus baterai
toggle-battery.ps1 -Enable   # Paksa sambung baterai
```

Jika dari folder repo (belum install):
```powershell
.\toggle-battery.ps1           # Toggle otomatis
.\toggle-battery.ps1 -Disable  # Paksa putus baterai
.\toggle-battery.ps1 -Enable   # Paksa sambung baterai
```

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
