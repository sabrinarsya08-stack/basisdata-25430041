# Normalisasi Kopma - Pertemuan 4

**Nama:** Sabrina Raisya Putri  **NIM:** 25430041  **Kelas:** B

Dokumen ini berisi seluruh tahap normalisasi spreadsheet lama Kopma: UNF, 1NF, dependensi fungsional, 2NF, 3NF, keputusan nilai turunan, pencocokan dengan skema kanonik, dan pemeriksaan BCNF.

Tanda: **garis bawah** tidak tersedia di Markdown, maka kunci primer ditulis dengan `PK`, kunci tamu dengan `FK`.

---

## 1. Dari UNF ke 1NF

### 1.1 Relasi UNF

Satu nota menyimpan grup berulang barang (ditulis di dalam `{ }`).

```
NOTA_UNF (no_nota_penjualan, tgl_penjualan, kode_petugas, nama_petugas,
          no_anggota, nama_anggota,
          { kode_barang, nama_barang, qty_detail_penjualan,
            harga_satuan_detail_penjualan, subtotal_detail_penjualan },
          jumlah_penjualan, diskon_penjualan, total_penjualan)
```

### 1.2 Relasi 1NF

Grup berulang dihilangkan: satu baris untuk setiap barang di setiap nota. Kunci primer menjadi komposit.

```
NOTA_1NF (PK: no_nota_penjualan + kode_barang;
          tgl_penjualan, kode_petugas, nama_petugas, no_anggota, nama_anggota,
          nama_barang, qty_detail_penjualan, harga_satuan_detail_penjualan,
          subtotal_detail_penjualan, jumlah_penjualan, diskon_penjualan,
          total_penjualan)
```

---

## 2. Dependensi Fungsional

Diturunkan dari aturan bisnis Pertemuan 2, bukan dari isi spreadsheet.

| No | Dependensi fungsional | Dasar |
|---|---|---|
| FD1 | no_nota_penjualan -> tgl_penjualan, kode_petugas, no_anggota | AB-01 |
| FD2 | kode_petugas -> nama_petugas | Kode petugas tercetak di nota dan satu kode mewakili satu orang |
| FD3 | no_anggota -> nama_anggota | AB-05 |
| FD4 | kode_barang -> nama_barang | Kode barang unik |
| FD5 | (no_nota_penjualan, kode_barang) -> qty_detail_penjualan, harga_satuan_detail_penjualan | AB-04 |
| FD6 | qty_detail_penjualan, harga_satuan_detail_penjualan -> subtotal_detail_penjualan | Turunan (perkalian) |

Catatan: `kode_barang -> harga_satuan_detail_penjualan` **tidak** ditulis sebagai dependensi, karena AB-04 menyatakan harga di nota dapat berbeda dari harga barang saat ini.

---

## 3. Menuju 2NF dan 3NF

### 3.1 2NF

FD1 dan FD4 hanya bergantung pada sebagian kunci komposit (`no_nota_penjualan` saja atau `kode_barang` saja). Relasi dipecah menjadi tiga:

```
PENJUALAN        (PK: no_nota_penjualan; tgl_penjualan, kode_petugas, nama_petugas,
                  no_anggota, nama_anggota, jumlah_penjualan, diskon_penjualan,
                  total_penjualan)
BARANG           (PK: kode_barang; nama_barang, kategori_barang, harga_jual_barang,
                  stok_barang, stok_min_barang)
DETAIL_PENJUALAN (PK: no_nota_penjualan + kode_barang; qty_detail_penjualan,
                  harga_satuan_detail_penjualan, subtotal_detail_penjualan)
```

### 3.2 3NF

Di relasi PENJUALAN terdapat dua rantai ketergantungan transitif:

- no_nota_penjualan -> kode_petugas -> nama_petugas
- no_nota_penjualan -> no_anggota -> nama_anggota

Petugas dan anggota dipisahkan menjadi relasi sendiri.

### 3.3 Keputusan nilai turunan

| Nilai turunan | Keputusan | Alasan |
|---|---|---|
| subtotal_detail_penjualan | Tidak disimpan | Hasil qty x harga satuan, bisa dihitung kapan saja |
| jumlah_penjualan | Tidak disimpan | Jumlah seluruh subtotal pada satu nota |
| diskon_penjualan | Tidak disimpan | Ditentukan status anggota (AB-02), bisa dihitung |
| total_penjualan | Tidak disimpan | jumlah dikurangi diskon; menyimpannya membuka peluang total berbeda dari rinciannya |

### 3.4 Hasil 3NF

```
PENJUALAN        (PK: no_nota_penjualan; tgl_penjualan, FK kode_petugas,
                  FK no_anggota, bayar_penjualan)
DETAIL_PENJUALAN (PK: no_nota_penjualan + kode_barang [keduanya FK];
                  qty_detail_penjualan, harga_satuan_detail_penjualan)
BARANG           (PK: kode_barang; nama_barang, kategori_barang,
                  harga_jual_barang, stok_barang, stok_min_barang)
PETUGAS          (PK: kode_petugas; nama_petugas, peran_petugas)
ANGGOTA          (PK: no_anggota; nim_anggota, nama_anggota, prodi_anggota,
                  no_hp_anggota, status_anggota, tgl_daftar_anggota)
```

---

## 4. Pencocokan dengan Skema Kanonik (Tabel 4.2)

Perbedaan utama hasil 3NF di atas dengan skema kanonik: skema kanonik memakai **kunci pengganti** `id_*` sebagai kunci primer, sedangkan kode alami (`kode_petugas`, `no_anggota`, `nim_anggota`, `kode_barang`, `no_nota_penjualan`) menjadi kunci unik. Struktur atributnya sama.

| Tabel | Kunci primer | Kunci unik | Kunci tamu |
|---|---|---|---|
| petugas | id_petugas | kode_petugas | - |
| anggota | id_anggota | no_anggota, nim_anggota | - |
| barang | id_barang | kode_barang | - |
| pemasok | id_pemasok | - | - |
| penjualan | id_penjualan | no_nota_penjualan | id_petugas, id_anggota (boleh NULL) |
| detail_penjualan | (id_penjualan, id_barang) | - | id_penjualan, id_barang |
| pembelian | id_pembelian | - | id_pemasok |
| detail_pembelian | (id_pembelian, id_barang) | - | id_pembelian, id_barang |

Tabel `pemasok`, `pembelian`, dan `detail_pembelian` berasal dari sisi pengadaan spreadsheet lama dengan pola yang sama: pemasok sebagai induk, pembelian sebagai kepala faktur, detail_pembelian sebagai entitas asosiatif dengan `harga_beli_detail_pembelian` sebagai harga saat transaksi.

---

## 5. Pemeriksaan BCNF

Pertanyaan pemeriksa: adakah penentu (ruas kiri dependensi fungsional) yang bukan kunci kandidat?

| Tabel | Penentu yang ditemukan | Kunci kandidat | Hasil |
|---|---|---|---|
| petugas | id_petugas, kode_petugas | id_petugas, kode_petugas | BCNF |
| anggota | id_anggota, no_anggota, nim_anggota | id_anggota, no_anggota, nim_anggota | BCNF |
| barang | id_barang, kode_barang | id_barang, kode_barang | BCNF |
| pemasok | id_pemasok | id_pemasok | BCNF (nama_pemasok sengaja tidak dianggap penentu karena ejaannya dapat berubah dan dua pemasok bisa bernama mirip) |
| penjualan | id_penjualan, no_nota_penjualan | id_penjualan, no_nota_penjualan | BCNF |
| detail_penjualan | (id_penjualan, id_barang) | (id_penjualan, id_barang) | BCNF |
| pembelian | id_pembelian | id_pembelian | BCNF (no_faktur_pembelian tidak unik, sehingga bukan penentu) |
| detail_pembelian | (id_pembelian, id_barang) | (id_pembelian, id_barang) | BCNF |

Kesimpulan: seluruh tabel skema kanonik Kopma memenuhi 3NF dan BCNF. Kunci pengganti `id_*` tidak dipakai sebagai alasan lolos 3NF; pemeriksaan tetap dilakukan terhadap kunci alami (misalnya `nim_anggota` pada tabel anggota).