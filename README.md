# Battery Toggle v1.0

**by Nurman Digital**

Script PowerShell untuk memutus & menyambung koneksi baterai laptop secara software. Ideal untuk laptop yang sering dicas terus-menerus — baterai bisa "dicabut" tanpa colok-lepas fisik.

---

## Cara Pakai

```powershell
# Run sebagai Administrator
.\toggle-battery.ps1           # Toggle otomatis (putus/sambung)
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

Open source. Pakai bebas, modifikasi bebas.
