# Dokumen Kebutuhan Data: Perpustakaan Cendekia

## 1. Latar belakang dan aktivitas organisasi
Perpustakaan Cendekia memfasilitasi sivitas akademika dalam pencatatan keanggotaan, katalog buku, sirkulasi peminjaman, pengembalian, pengelolaan denda, dan pengadaan buku dari pemasok. Sistem baru ini dirancang untuk mengatasi anomali data dari pencatatan manual, hilangnya riwayat denda, dan kesalahan hitung stok.

## 2. Aktor dan proses bisnis
| Kode | Proses bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Mendaftarkan anggota baru | Petugas Perpustakaan | Mahasiswa mendaftar menjadi anggota perpustakaan |
| PB-02 | Mencatat peminjaman buku | Petugas Perpustakaan | Anggota meminjam buku di meja sirkulasi |
| PB-03 | Mencatat pengembalian buku & denda | Petugas Perpustakaan | Anggota mengembalikan buku |
| PB-04 | Memesan buku ke pemasok | Pustakawan / Pengelola | Stok judul buku di bawah batas minimum |
| PB-05 | Menerima buku dari pemasok | Pustakawan / Pengelola | Pengiriman buku datang bersama faktur |
| PB-06 | Menyusun laporan bulanan | Kepala Perpustakaan | Memasuki awal bulan periode sirkulasi |

## 3. Dokumen sumber yang dianalisis
**A. Dokumen Riil (Fisik):**
* Formulir Pendaftaran Anggota Perpustakaan
* Faktur Pengadaan Buku dari Pemasok

**B. Rancangan Dokumen Fiktif & Pembedahannya (Slip Peminjaman):**
Slip ini dicetak dan diberikan kepada anggota saat meminjam buku di meja sirkulasi.

```text
-------------------------------------------------------------------
PERPUSTAKAAN CENDEKIA - SLIP PEMINJAMAN
-------------------------------------------------------------------
No. Transaksi : PJM-2610-001      [-> identitas transaksi]
Tanggal       : 06-10-2026 10:00  [-> identitas transaksi]
Petugas       : PTG-02 (Rina)     [-> relasi ke Petugas]
Anggota       : 25430041 (Sabrina)[-> relasi ke Anggota]

Daftar Pinjaman:
1. BKU-001 | Basis Data    | Qty: 1 | Baik  [-> buku, qty, kondisi saat transaksi]
2. BKU-045 | Sistem Cerdas | Qty: 1 | Baik  [-> buku, qty, kondisi saat transaksi]
-------------------------------------------------------------------
Total Buku Dipinjam: 2               [-> nilai turunan (dihitung dari baris)]
Batas Jatuh Tempo  : 13-10-2026      [-> data batas peminjaman]
-------------------------------------------------------------------