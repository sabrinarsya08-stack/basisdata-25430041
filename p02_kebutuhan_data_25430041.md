# Dokumen Kebutuhan Data: Perpustakaan Cendekia SRP

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
```
## 4. Entitas kandidat dan elemen data
1. **Anggota:** NIM, nama, no_hp, status_aktif
2. **Petugas:** ID_petugas, nama, peran
3. **Buku:** ISBN, judul, pengarang, kategori
4. **Eksemplar_Buku:** kode_barcode, kondisi, status_pinjam
5. **Peminjaman:** no_slip, tgl_pinjam, batas_kembali, id_petugas, nim_anggota
6. **Detail_Peminjaman:** no_slip, kode_barcode, tgl_dikembalikan, denda
7. **Pemasok:** id_pemasok, nama_pemasok, kontak

## 5. Aturan bisnis
| Kode | Aturan Bisnis |
|---|---|
| AB-01 | NIM anggota unik dan tidak boleh ganda. |
| AB-02 | Maksimal buku yang dapat dipinjam dalam 1 transaksi adalah 8 buku (P+2). |
| AB-03 | Denda keterlambatan adalah Rp6.000 per hari per buku (P x Rp1.000). |
| AB-04 | Anggota dengan denda belum lunas tidak bisa meminjam buku baru. |
| AB-05 | Eksemplar yang dipinjam otomatis berstatus "Sedang Dipinjam". |
| AB-06 | Setiap transaksi peminjaman wajib memiliki minimal 1 eksemplar buku. |
| AB-07 | Batas waktu peminjaman adalah 7 hari. |
| AB-08 | Peminjaman wajib mencatat identitas anggota yang valid. |

## 6. Kebutuhan informasi
| Kode | Kebutuhan Informasi |
|---|---|
| KI-01 | Total nominal denda per bulan |
| KI-02 | 5 judul buku paling sering dipinjam |
| KI-03 | Anggota yang belum mengembalikan buku lewat jatuh tempo |
| KI-04 | Ketersediaan eksemplar fisik untuk satu judul buku |
| KI-05 | Jumlah transaksi per petugas per bulan |

## 7. Matriks CRUD
| Proses | Anggota | Petugas | Buku | Eksemplar | Peminjaman | Detail | Pemasok |
|---|---|---|---|---|---|---|---|
| PB-01 (Daftar anggota) | C | R | | | | | |
| PB-02 (Kelola katalog) | | R | C, U | C, U | | | R |
| PB-03 (Catat pinjam) | R | R | R | U | C | C | |
| PB-04 (Catat kembali) | R | R | | U | R | U | |
| PB-05 (Daftar pemasok) | | R | | | | | C |

## 8. Kamus data awal
| Elemen | Arti | Aturan | Penanggung Jawab |
|---|---|---|---|
| nim_anggota | NIM mahasiswa | Unik, 10 digit | Kepala Perpus |
| nama_anggota | Nama lengkap anggota | Wajib diisi | Kepala Perpus |
| no_hp_anggota | Nomor kontak | Pribadi, akses terbatas | Kepala Perpus |
| status_aktif | Status keanggotaan | 'aktif' atau 'nonaktif' | Kepala Perpus |
| id_petugas | ID unik petugas | Unik | Kepala Perpus |
| nama_petugas | Nama lengkap petugas | Wajib diisi | Kepala Perpus |
| peran_petugas | Peran petugas | 'admin', 'sirkulasi', 'pustakawan' | Kepala Perpus |
| isbn | Nomor ISBN buku | Unik per judul buku | Pustakawan |
| judul_buku | Judul buku | Wajib diisi | Pustakawan |
| pengarang | Nama pengarang/penulis | Wajib diisi | Pustakawan |
| kategori_buku | Kategori/genre | Wajib diisi | Pustakawan |
| kode_barcode | Kode fisik eksemplar buku | Unik per fisik buku | Pustakawan |
| kondisi_buku | Kondisi fisik buku | 'baik', 'rusak', 'hilang' | Pustakawan |
| status_pinjam | Ketersediaan di rak | 'tersedia', 'dipinjam' | Petugas Sirkulasi |
| no_slip_pinjam | Nomor transaksi pinjam | Unik | Petugas Sirkulasi |
| tgl_pinjam | Waktu buku dipinjam | Format Datetime | Petugas Sirkulasi |
| batas_kembali | Jatuh tempo peminjaman | Tgl pinjam + 7 hari | Petugas Sirkulasi |
| tgl_dikembalikan | Waktu buku dikembalikan | Format Datetime | Petugas Sirkulasi |
| nominal_denda | Nominal denda per buku | Angka >= 0 | Petugas Sirkulasi |
| id_pemasok | ID unik pemasok | Unik | Pustakawan |
| nama_pemasok | Nama penerbit/pemasok | Wajib diisi | Pustakawan |
| kontak_pemasok | Info kontak penerbit | Boleh kosong | Pustakawan |

## 9. Kebutuhan non-fungsional data
* **Parameter P:** P = (41 mod 9) + 1 = 5 + 1 = 6. (Batas pinjam 8 buku, Denda Rp6.000/hari).
* **Privasi:** Nomor HP anggota adalah data pribadi yang hanya boleh diakses oleh Kepala Perpustakaan.
* **Retensi:** Data peminjaman disimpan minimal 5 tahun.

## 10. Isu kualitas data yang diantisipasi
* Kesalahan penulisan format NIM (misal pakai strip atau kurang dari 10 digit).
* Duplikasi pendaftaran anggota baru karena salah ketik ejaan nama.