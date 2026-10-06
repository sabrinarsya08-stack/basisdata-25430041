# Dokumen Kebutuhan Data: Perpustakaan Cendekia

## 1. Latar belakang dan aktivitas organisasi
Perpustakaan Cendekia adalah unit layanan literasi kampus yang memfasilitasi sivitas akademika dalam pencatatan keanggotaan, pengelolaan katalog buku, sirkulasi peminjaman dan pengembalian buku, pengelolaan denda keterlambatan, hingga pengadaan buku baru dari pemasok. Sistem ini dibangun untuk menggantikan pencatatan manual berbasis buku tulis dan spreadsheet yang rentan mengalami anomali data, hilangnya riwayat harga/tarif, serta kesalahan perhitungan stok.

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
* Formulir Pendaftaran Anggota Perpustakaan
* Slip / Bukti Transaksi Peminjaman Buku
* Faktur Pengadaan Buku dari Pemasok
* Laporan Sirkulasi Bulanan Perpustakaan

## 4. Entitas kandidat dan elemen data
* **Anggota:** id_anggota, no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota.
* **Buku:** id_buku, kode_buku, judul_buku, penulis_buku, penerbit_buku, tahun_terbit, kategori_buku, harga_buku, stok_buku, stok_min_buku.
* **Petugas:** id_petugas, kode_petugas, nama_petugas, peran_petugas.
* **Pemasok:** id_pemasok, nama_pemasok, telepon_pemasok, alamat_pemasok.
* **Peminjaman:** id_peminjaman, no_transaksi_pinjam, tgl_pinjam, tgl_jatuh_tempo, id_petugas, id_anggota.
* **Detail Peminjaman:** id_peminjaman, id_buku, qty_pinjam, kondisi_buku_keluar.
* **Pengembalian:** id_pengembalian, tgl_kembali, denda_keterlambatan, kondisi_buku_kembali, id_petugas, id_peminjaman.
* **Pengadaan (Pembelian):** id_pembelian, no_faktur_pembeli, tgl_pembelian, id_pemasok, status_pembelian.
* **Detail Pengadaan:** id_pembelian, id_buku, qty_beli, harga_beli.

## 5. Aturan bisnis
| Kode | Aturan bisnis |
|---|---|
| AB-01 | Setiap transaksi peminjaman memiliki nomor unik dan mencakup minimal satu eksemplar buku. |
| AB-02 | Anggota yang meminjam buku wajib berstatus aktif; anggota nonaktif atau umum tidak diizinkan meminjam. |
| AB-03 | Stok buku fisik di perpustakaan tidak boleh bernilai negatif; peminjaman ditolak jika stok habis. |
| AB-04 | Data riwayat peminjaman wajib mencatat kondisi buku saat keluar dan saat dikembalikan. |
| AB-05 | NIM anggota bersifat unik; pencarian data anggota dapat dilakukan melalui nomor anggota atau NIM. |
| AB-06 | Pemesanan pengadaan buku baru dilakukan secara otomatis apabila stok buku di bawah batas minimum. |
| AB-07 | Keterlambatan pengembalian melebihi tanggal jatuh tempo dikenakan denda harian per buku. |
| AB-08 | Nomor HP dan data privasi anggota perpustakaan dikelola secara terbatas sesuai ketentuan perlindungan data pribadi. |

## 6. Kebutuhan informasi
| Kode | Kebutuhan informasi | Data yang diperlukan |
|---|---|---|
| KI-01 | Rekapitulasi jumlah peminjaman, pengembalian, dan total denda per hari/bulan | Peminjaman, Pengembalian |
| KI-02 | Lima buku yang paling sering dipinjam per bulan | Peminjaman, Detail Peminjaman, Buku |
| KI-03 | Daftar buku yang stoknya di bawah batas minimum (perlu pengadaan) | Buku |
| KI-04 | Sepuluh anggota perpustakaan dengan frekuensi peminjaman terbanyak | Anggota, Peminjaman |
| KI-05 | Daftar buku yang sedang mengalami keterlambatan pengembalian | Peminjaman, Pengembalian |

## 7. Matriks CRUD
| Proses Bisnis | Anggota | Buku | Petugas | Pemasok | Peminjaman | Detail Pinjam | Pengembalian | Pengadaan | Detail Beli |
|---|---|---|---|---|---|---|---|---|---|
| PB-01 Pendaftaran | C | R | R | - | - | - | - | - | - |
| PB-02 Peminjaman | R | U | R | - | C | C | - | - | - |
| PB-03 Pengembalian | R | U | R | - | R | R | C | - | - |
| PB-04 Pesan Buku | - | R | R | R | - | - | - | C | C |
| PB-05 Terima Buku | - | U | R | U | - | - | - | U | R |
| PB-06 Laporan | R | R | R | R | R | R | R | R | R |

## 8. Kamus data awal (Cuplikan Elemen Utama)
| Elemen | Arti | Contoh | Aturan / Format | Penanggung Jawab |
|---|---|---|---|---|
| id_anggota | ID internal anggota | 1 | Integer, Primary Key | Kepala Perpustakaan |
| no_anggota | Nomor kartu anggota | A-0123 | Unik, Format A-4 digit | Kepala Perpustakaan |
| nim_anggota | NIM mahasiswa | 25430041 | Unik, 10 digit | Kepala Perpustakaan |
| nama_anggota | Nama lengkap anggota | Sabrina Raisya | Wajib diisi | Kepala Perpustakaan |
| prodi_anggota | Program studi anggota | Ilmu Komputer | Wajib diisi | Kepala Perpustakaan |
| no_hp_anggota | Nomor telepon seluler | 08123456789 | Data Pribadi (PDP), boleh NULL | Kepala Perpustakaan |
| status_anggota | Status keaktifan anggota | aktif | ENUM ('aktif', 'nonaktif') | Kepala Perpustakaan |
| tgl_daftar_anggota | Tanggal pendaftaran | 2026-09-01 | Format DATE | Kepala Perpustakaan |
| id_buku | ID internal katalog buku | 101 | Integer, Primary Key | Pustakawan |
| kode_buku | Kode unik buku | BKU-001 | Unik, String | Pustakawan |
| judul_buku | Judul lengkap buku | Basis Data Relasional | Wajib diisi | Pustakawan |
| penulis_buku | Penulis / Pengarang | Dedi Irawan | Wajib diisi | Pustakawan |
| penerbit_buku | Nama penerbit | Andi Offset | Wajib diisi | Pustakawan |
| tahun_terbit | Tahun penerbitan | 2026 | Angka tahun valid | Pustakawan |
| kategori_buku | Klasifikasi buku | Teknologi | Wajib diisi | Pustakawan |
| stok_buku | Jumlah eksemplar tersedia | 5 | Bilangan bulat $\ge 0$ | Pustakawan |
| stok_min_buku | Batas minimum stok | 2 | Bilangan bulat $\ge 0$ | Pustakawan |
| id_peminjaman | ID transaksi peminjaman | 1 | Integer, Primary Key | Petugas Sirkulasi |
| tgl_pinjam | Waktu peminjaman buku | 2026-10-06 10:00 | DATETIME | Petugas Sirkulasi |
| tgl_jatuh_tempo | Batas waktu pengembalian | 2026-10-13 23:59 | DATETIME | Petugas Sirkulasi |

## 9. Kebutuhan non-fungsional data
* **Perhitungan Parameter $P$:** Berdasarkan dua digit terakhir NIM (`41`), nilai $P = (41 \pmod 9) + 1 = \mathbf{6}$.
* **Volume Transaksi Harian:** Estimasi transaksi sirkulasi harian berdasarkan parameter $P$ adalah $40 + (5 \times 6) = 70$ transaksi peminjaman per hari.
* **Batasan Item:** Batas maksimal eksemplar buku yang dapat dipinjam dalam satu kali transaksi adalah $P + 2 = 8$ item buku.
* **Retensi Data:** Seluruh catatan sirkulasi peminjaman, pengembalian, dan riwayat denda disimpan sekurang-kurangnya selama 5 tahun.
* **Privasi Data:** Data nomor telepon dan identitas pribadi anggota dikategorikan sebagai data sensitif yang hanya dapat diakses oleh petugas perpustakaan berwenang.

## 10. Isu kualitas data yang diantisipasi
* Potensi kesalahan ketik NIM anggota saat proses pemindaian atau pencatatan di meja sirkulasi.
* Ketidakkonsistenan penulisan nama penulis atau penerbit buku pada saat proses entri data katalog pengadaan baru.
* Risiko keterlambatan pencatatan pengembalian buku yang dapat berdampak pada selisih akumulasi denda keterlambatan di sistem.