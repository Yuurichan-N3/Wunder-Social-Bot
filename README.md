# Wunder Sosial Bot
WunderClaim Bot adalah skrip Ruby yang dirancang untuk mengotomatiskan proses pengklaiman username di situs [wunder.social](https://www.wunder.social). Skrip ini mendukung dua mode: **manual** (input data pengguna) dan **random** (data otomatis), dengan kemampuan menjalankan beberapa claim secara paralel.

## ✨ Fitur
- **Mode Manual**: Masukkan data Anda sendiri untuk mengklaim username.
- **Mode Random**: Generate data acak untuk pengklaiman massal.
- **Paralel Processing**: Jalankan beberapa claim sekaligus menggunakan thread.
- **Logging**: Simpan log aktivitas ke file (`wunderclaim.log`) dan terminal.
- **Output Tabel**: Tampilan data claim dalam format tabel yang rapi.
- **Integrasi Guerrilla Mail**: Gunakan email sementara untuk setiap claim.

## 🛠 Prasyarat
Pastikan Anda memiliki:
- **Ruby**: Versi 3.0 atau lebih tinggi (tes pada Ruby 3.4 di Termux).
- **Termux** (opsional): Jika menjalankan di Android.
- Koneksi internet stabil.

## 📦 Instalasi
1. Clone repository ini:
   ```bash
   git clone https://github.com/Yuurichan-N3/Wunder-Social-Bot.git
   cd Wunder-Social-bot
   ```
2. Instal gem yang diperlukan:
   ```bash
   gem install terminal-table
   gem install colorize
   ```
3. Pastikan Ruby terinstal:
   ```bash
   ruby -v
   ```

## 🚀 Cara Penggunaan
1. Jalankan skrip:
   ```bash
   ruby bot.rb
   ```
2. Pilih mode:
   - **1**: Mode Manual - Masukkan data Anda secara manual.
   - **2**: Mode Random - Tentukan jumlah claim, dan bot akan generate data otomatis.
3. Ikuti petunjuk di terminal untuk memasukkan input sesuai mode yang dipilih.

### Contoh Output
```
╔══════════════════════════════════════════════╗
║      🌟 WunderClaim Bot - Username Claim     ║
║  Automate username claiming on wunder.social!║
║  Developed by: https://t.me/sentineldiscus   ║
╚══════════════════════════════════════════════╝
Pilih mode:
1. Manual (input data sendiri)
2. Random (data otomatis)
Masukkan pilihan (1 atau 2): 2
Mode Random: Data akan di-generate secara otomatis
Masukkan jumlah claim yang diinginkan: 1
Memulai 1 claim secara paralel...
I, [2025-04-10T20:25:01.380321 #9962]  INFO -- : Berhasil mendapatkan email: rnykoxtw@guerrillamailblock.com
I, [2025-04-10T20:25:01.386714 #9962]  INFO -- : Data disimpan ke data.json
+-------------------------------------------------+
|                   Data Claim                    |
+---------------+---------------------------------+
| Tanggal Lahir | 1993-12-09                      |
| Nama Depan    | ejabekayal                      |
| Nama Belakang | uqomiba                         |
| Handle Sosial | dugogemu.heh                    |
| Username      | dobajijiw51                     |
| Email         | rnykoxtw@guerrillamailblock.com |
+---------------+---------------------------------+
I, [2025-04-10T20:25:02.094868 #9962]  INFO -- : Success! Thanks for submitting the form.
```

## ⚙️ Struktur File
- `bot.rb`: Skrip utama bot.
- `data.json`: File output tempat data claim disimpan.
- `wunderclaim.log`: Log aktivitas bot.

## ⚠️ Catatan
- Skrip ini diuji pada Termux (Android) dan desktop. Pastikan lingkungan Anda mendukung Ruby dan gem yang dibutuhkan.
- Warna di terminal mungkin tidak muncul di beberapa konfigurasi Termux. Tambahkan `export TERM=xterm-256color` jika perlu.


## 📜 Lisensi
Script ini didistribusikan untuk keperluan pembelajaran dan pengujian. Penggunaan di luar tanggung jawab pengembang.  

Untuk update terbaru, bergabunglah di grup **Telegram**: [Klik di sini](https://t.me/sentineldiscus).

---

## 💡 Disclaimer
Penggunaan bot ini sepenuhnya tanggung jawab pengguna. Kami tidak bertanggung jawab atas penyalahgunaan skrip ini.
