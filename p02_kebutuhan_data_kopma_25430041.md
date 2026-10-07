# Dokumen Kebutuhan Data: Koperasi Mahasiswa Sejahtera (Kopma)

## 1. Latar belakang dan aktivitas organisasi
Kopma menjual alat tulis, makanan ringan, dan minuman di lingkungan kampus. Pembeli dapat berupa anggota (mahasiswa) atau umum. Anggota aktif memperoleh diskon 5% untuk setiap nota. (MODIFIKASI: Kopma kini menerapkan sistem poin loyalitas bagi anggota untuk ditukarkan dengan potongan harga belanja).

## 2. Aktor dan proses bisnis
| Kode | Proses Bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Mendaftarkan anggota | Kasir (atas permintaan mahasiswa) | Mahasiswa ingin menjadi anggota |
| PB-02 | Mencatat penjualan | Kasir | Pembeli membayar di kasir |
| PB-03 | Memesan barang ke pemasok | Petugas gudang | Stok di bawah batas minimum |
| PB-04 | Menerima barang dari pemasok | Petugas gudang | Barang datang bersama faktur |
| PB-05 | Menyusun laporan bulanan | Ketua koperasi | Awal bulan |

## 3. Dokumen sumber yang dianalisis
- Nota Penjualan Kopma.
- Formulir Pendaftaran Anggota.
- Faktur Pemasok.

## 4. Entitas kandidat dan elemen data
- **Anggota:** nomor anggota, NIM, nama, program studi, nomor HP, status aktif, **poin_loyalitas (TAMBAHAN E.1)**.
- **Barang:** kode, nama, kategori, harga jual, stok, batas minimum stok.
- **Penjualan:** nomor nota, tanggal-jam, kasir, anggota, bayar, **poin_didapat (TAMBAHAN E.1)**, **poin_ditukar (TAMBAHAN E.1)**.
- **Detail penjualan:** nomor nota, barang, qty, harga saat transaksi.
- **Petugas:** kode petugas, nama, peran.
- **Pemasok:** kode, nama, telepon, alamat.
- **Pembelian dan detailnya:** nomor faktur, tanggal, pemasok, barang, qty, harga beli.

## 5. Aturan bisnis
| Kode | Aturan bisnis |
|---|---|
| AB-01 | Setiap nota memiliki nomor unik dan minimal satu baris barang. |
| AB-02 | Penjualan boleh tanpa anggota (pembeli umum); jika ada, anggota harus berstatus aktif untuk memperoleh diskon 5%. |
| AB-03 | Stok barang tidak boleh negatif; penjualan ditolak bila qty melebihi stok tersedia. |
| AB-04 | Harga jual yang dipakai pada nota disimpan per baris dan tidak berubah meski harga barang kemudian naik. |
| AB-05 | NIM anggota unik; pencarian anggota dapat dilakukan lewat nomor anggota atau NIM. |
| AB-06 | Pesanan pembelian dibuat bila stok kurang dari batas minimum barang tersebut. |
| **AB-07** | **(TAMBAHAN E.1) Setiap kelipatan Rp10.000 belanja anggota bernilai 1 poin loyalitas.** |
| **AB-08** | **(TAMBAHAN E.1) 50 poin loyalitas dapat ditukar dengan potongan Rp5.000.** |

## 6. Kebutuhan informasi
| Kode | Kebutuhan Informasi | Data yang diperlukan |
|---|---|---|
| KI-01 | Omzet dan jumlah nota per hari dan per bulan | Penjualan, detail penjualan |
| KI-02 | Lima barang terlaris per bulan berdasarkan qty | Detail penjualan, barang |
| KI-03 | Barang dengan stok di bawah batas minimum | Barang |
| KI-04 | Sepuluh anggota dengan belanja terbesar per bulan | Penjualan, detail penjualan, anggota |
| **KI-05** | **(TAMBAHAN E.1) Rekapitulasi perolehan dan penukaran poin loyalitas anggota per bulan** | **Anggota, Penjualan** |

## 7. Matriks CRUD
*(Terdapat pembaruan pada PB-02: Entitas Anggota yang sebelumnya hanya 'R', kini menjadi 'R, U' karena saldo poinnya bertambah/berkurang saat transaksi)*

| Proses | Anggota | Barang | Penjualan | Detail | Pemasok | Pembelian |
|---|---|---|---|---|---|---|
| PB-01 Daftar anggota | C | | | | | |
| PB-02 Catat penjualan | **R, U** | R, U | C | C | | |
| PB-03 Pesan ke pemasok | | R | | | R | C |
| PB-04 Terima barang | | U | | | R | U |
| PB-05 Laporan bulanan | R | R | R | R | | R |

## 8. Kamus data awal (Cuplikan)
| Elemen | Arti | Contoh | Aturan | Penanggung jawab |
|---|---|---|---|---|
| no_anggota | Nomor anggota koperasi | A-0457 | Unik, format A-4 digit | Ketua |
| nim_anggota | NIM anggota | 2301010123 | Unik, 10 digit | Ketua |
| no_hp_anggota | Nomor HP anggota | 0812xxxx | Data pribadi, akses terbatas | Ketua |
| no_nota_penjualan | Nomor nota penjualan | PJ-2609-0142 | Unik per nota | Kasir |
| harga_satuan_detail | Harga jual saat transaksi | 4000 | Bilangan bulat $\ge 0$ (rupiah) | Kasir |
| stok_barang | Jumlah barang tersedia | 35 | Bilangan bulat $\ge 0$ (AB-03) | Petugas gudang |
| poin_loyalitas | Saldo poin anggota | 150 | Bilangan bulat $\ge 0$ | Ketua |

## 9. Kebutuhan non-fungsional data
- Perkiraan $\pm 150$ nota per hari.
- Data transaksi disimpan minimal lima tahun.
- Nomor HP anggota hanya boleh dilihat oleh ketua karena pembatasan akses data pribadi sejalan dengan Undang-Undang Pelindungan Data Pribadi.

## 10. Isu kualitas data yang diantisipasi
- Kasir tidak mencantumkan nomor anggota pada nota saat pembeli lupa membawa kartu, yang mengakibatkan hilangnya rekam jejak poin loyalitas anggota.