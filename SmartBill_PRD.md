
# 🧾 Product Requirements Document (PRD) — SmartBill

## 🏷️ 1. Informasi Umum
| Item | Keterangan |
|------|-------------|
| **Nama Aplikasi** | SmartBill |
| **Kategori** | Keuangan / Produktivitas |
| **Platform** | Android (Offline Support) |
| **Target Pengguna** | Pengguna individu yang ingin mengelola dan mengingat pembayaran tagihan (listrik, air, internet, pajak, dll) |
| **Versi Awal** | 1.0.0 |
| **Mode Pengembangan** | Offline-first dengan opsi fitur premium (cloud sync & analisis) |

---

## 🎯 2. Tujuan Produk
SmartBill bertujuan membantu pengguna **mengatur dan mengingat pembayaran tagihan secara offline** dengan notifikasi otomatis, suara pengingat (ringtone), serta pencatatan status pembayaran.  
Aplikasi juga menyediakan fitur premium seperti **sinkronisasi cloud, tema eksklusif, dan analisis keuangan otomatis**.

---

## 👥 3. Persona Pengguna
| Persona | Deskripsi |
|----------|------------|
| **Pengguna Individu** | Karyawan, mahasiswa, atau kepala keluarga yang memiliki banyak tagihan rutin. |
| **Usia** | 20–50 tahun |
| **Kebutuhan utama** | Mengingat tanggal pembayaran tagihan agar tidak terlambat. |
| **Masalah saat ini** | Lupa membayar tagihan, tidak ada pengingat yang terpusat, pencatatan manual. |

---

## ⚙️ 4. Fitur Utama (Gratis / Offline)
| Fitur | Deskripsi | Status |
|-------|------------|--------|
| **Manajemen Tagihan Offline (CRUD)** | Tambah, ubah, hapus, dan tandai tagihan sebagai sudah dibayar. | ✅ |
| **Notifikasi Pengingat Otomatis** | Notifikasi muncul sesuai jadwal dan membunyikan ringtone. | ✅ |
| **Kalender Tagihan** | Tampilan kalender untuk melihat jadwal tagihan. | ✅ |
| **Mode Gelap (Dark Mode)** | Tema gelap otomatis sesuai sistem. | ✅ |
| **Backup Lokal** | Menyimpan data di penyimpanan lokal tanpa internet. | ✅ |

---

## 💎 5. Fitur Premium
| Fitur Premium | Deskripsi |
|----------------|------------|
| **Sinkronisasi Cloud** | Menyimpan data pengguna ke server cloud agar tidak hilang. |
| **Multi-Notifikasi** | Pengguna bisa menambah lebih dari satu pengingat untuk setiap tagihan. |
| **Tema Eksklusif & Tanpa Iklan** | Tampilan premium tanpa gangguan iklan. |
| **Analisis Keuangan Otomatis** | Grafik dan statistik otomatis berdasarkan pembayaran tagihan. |
| **Integrasi QR Pembayaran** | Menampilkan QR atau link pembayaran langsung dari aplikasi. |

---

## 🧱 6. Arsitektur Aplikasi
- **Frontend:** Flutter (Dart)
- **Local Database:** Hive
- **Notifications:** flutter_local_notifications + timezone
- **Desain UI:** Material 3 + Custom Theme
- **Offline-first Design:** Semua fitur inti dapat berjalan tanpa koneksi internet.

---

## 🧩 7. Struktur Direktori Utama
```
lib/
 ├── main.dart
 ├── model/
 │    └── bill.dart
 ├── pages/
 │    ├── home_page.dart
 │    ├── add_bill_page.dart
 │    └── statistics_page.dart
 └── services/
      ├── notification_service.dart
      └── hive_service.dart
```

---

## 📅 8. Roadmap Pengembangan
| Tahap | Deskripsi | Target |
|--------|------------|--------|
| **Versi 1.0.0** | Fitur offline dasar + notifikasi | Selesai |
| **Versi 1.1.0** | Kalender + statistik keuangan sederhana | 1 bulan |
| **Versi 1.2.0** | Fitur premium (cloud, tema, analisis) | 3 bulan |
| **Versi 2.0.0** | Integrasi QR & multi-user sync | 6 bulan |

---

## 📊 9. Indikator Keberhasilan
- Aplikasi bisa berjalan **tanpa internet**
- Notifikasi berjalan tepat waktu
- Tidak ada data hilang setelah restart
- Pengguna dapat menambah minimal 20 tagihan tanpa lag
- Crash rate < 1% di Play Console

---

## 🔒 10. Risiko & Mitigasi
| Risiko | Dampak | Mitigasi |
|--------|---------|-----------|
| Notifikasi gagal muncul | Pengingat tidak aktif | Cek izin notifikasi di awal aplikasi |
| Data hilang setelah reinstall | Kehilangan catatan tagihan | Tambah fitur backup lokal otomatis |
| Pengguna mengeluh iklan | Menurunkan rating | Sediakan opsi Premium tanpa iklan |

---

## 🧠 11. Kesimpulan
SmartBill adalah solusi **offline-first** untuk manajemen tagihan dengan pengalaman pengguna yang sederhana, cepat, dan tetap aman.  
Pengembangan berikutnya akan fokus pada **fitur cloud dan AI analytics** untuk menambah nilai bagi pengguna premium.
