# Normalisasi Proyek Perpustakaan - Milestone Proyek 4

**Nama:** Sabrina Raisya Putri  **NIM:** 25430041  **Kelas:** B

> Catatan sinkronisasi: kode aturan bisnis (AB-P01 dan seterusnya) di dokumen ini harus sama dengan tabel aturan bisnis di `p02_kebutuhan_data_25430041.md`. Bila nomor atau bunyinya berbeda di berkas Pertemuan 2, samakan di sini.

Parameter personal dari Pertemuan 2: P = (41 mod 9) + 1 = 5 + 1 = **6**. Maka batas maksimal buku per peminjaman = P + 2 = **8**, denda keterlambatan = **Rp6.000 per hari**, dan perkiraan transaksi harian = 40 + 5 x 6 = **70**.

---

## 1. Dokumen Sumber (titik awal UNF)

Sumber: kartu peminjaman perpustakaan yang selama ini dicatat di buku besar. Satu kartu memuat satu peminjaman oleh satu anggota dan dapat berisi beberapa buku.

## 2. Aturan Bisnis yang Mendasari

| Kode | Aturan bisnis |
|---|---|
| AB-P01 | Setiap peminjaman memiliki nomor unik, memuat minimal 1 dan maksimal 8 buku. |
| AB-P02 | Satu peminjaman dicatat oleh tepat satu petugas untuk tepat satu anggota; hanya anggota berstatus aktif yang boleh meminjam. |
| AB-P03 | Setiap buku punya kode unik; judul, pengarang, dan kategori melekat pada buku. |
| AB-P04 | Denda keterlambatan dihitung per buku per hari sesuai tarif yang berlaku saat peminjaman; tarif dapat berubah sehingga catatan lama tidak boleh ikut berubah. |
| AB-P05 | Nomor anggota dan NIM anggota masing-masing unik. |
| AB-P06 | Lama pinjam ditetapkan perpustakaan dan dapat berubah sewaktu-waktu; tanggal jatuh tempo suatu peminjaman tidak berubah setelah dicatat. |

---

## 3. Tahapan Normalisasi

### 3.1 UNF

```
PEMINJAMAN_UNF (no_peminjaman, tgl_peminjaman, tgl_jatuh_tempo, kode_petugas,
                nama_petugas, no_anggota, nim_anggota, nama_anggota,
                prodi_anggota, status_anggota,
                { kode_buku, judul_buku, pengarang_buku, kategori_buku,
                  tgl_kembali_detail, tarif_denda_detail, hari_telat_detail,
                  denda_detail },
                total_denda)
```

### 3.2 1NF

Grup berulang buku dihilangkan: satu baris untuk setiap buku di setiap peminjaman. Kunci primer komposit `(no_peminjaman, kode_buku)`.

```
PEMINJAMAN_1NF (PK: no_peminjaman + kode_buku;
                tgl_peminjaman, tgl_jatuh_tempo, kode_petugas, nama_petugas,
                no_anggota, nim_anggota, nama_anggota, prodi_anggota,
                status_anggota, judul_buku, pengarang_buku, kategori_buku,
                tgl_kembali_detail, tarif_denda_detail, hari_telat_detail,
                denda_detail, total_denda)
```

### 3.3 Dependensi fungsional (dari aturan bisnis)

| No | Dependensi fungsional | Dasar |
|---|---|---|
| FD1 | no_peminjaman -> tgl_peminjaman, tgl_jatuh_tempo, kode_petugas, no_anggota | AB-P01, AB-P02, AB-P06 |
| FD2 | kode_petugas -> nama_petugas | AB-P02 |
| FD3 | no_anggota -> nim_anggota, nama_anggota, prodi_anggota, status_anggota | AB-P02, AB-P05 |
| FD3b | nim_anggota -> no_anggota | AB-P05 |
| FD4 | kode_buku -> judul_buku, pengarang_buku, kategori_buku | AB-P03 |
| FD5 | (no_peminjaman, kode_buku) -> tgl_kembali_detail, tarif_denda_detail | AB-P04 |
| FD6 | (tgl_kembali_detail, tgl_jatuh_tempo, tarif_denda_detail) -> hari_telat_detail, denda_detail | Turunan (perhitungan) |
| FD7 | seluruh denda_detail dalam satu no_peminjaman -> total_denda | Turunan (penjumlahan) |

Catatan: `kode_buku -> tarif_denda_detail` tidak ditulis, karena tarif mengikuti saat peminjaman (AB-P04), bukan melekat pada buku.

### 3.4 2NF

FD1 hanya bergantung pada `no_peminjaman` dan FD4 hanya pada `kode_buku`, keduanya sebagian dari kunci komposit. Dipecah menjadi tiga relasi:

```
PEMINJAMAN        (PK: no_peminjaman; tgl_peminjaman, tgl_jatuh_tempo,
                   kode_petugas, nama_petugas, no_anggota, nim_anggota,
                   nama_anggota, prodi_anggota, status_anggota, total_denda)
BUKU              (PK: kode_buku; judul_buku, pengarang_buku, kategori_buku)
DETAIL_PEMINJAMAN (PK: no_peminjaman + kode_buku; tgl_kembali_detail,
                   tarif_denda_detail, hari_telat_detail, denda_detail)
```

### 3.5 3NF

Di PEMINJAMAN terdapat dua rantai transitif:

- no_peminjaman -> kode_petugas -> nama_petugas
- no_peminjaman -> no_anggota -> nim_anggota, nama_anggota, prodi_anggota, status_anggota

Petugas dan anggota dipisahkan:

```
PETUGAS (PK: kode_petugas; nama_petugas)
ANGGOTA (PK: no_anggota; nim_anggota, nama_anggota, prodi_anggota, status_anggota)
```

### 3.6 Ringkasan tahapan

| Tahap | Relasi hasil | Masalah yang dihilangkan |
|---|---|---|
| UNF | PEMINJAMAN_UNF | - (ada grup berulang buku) |
| 1NF | PEMINJAMAN_1NF | Grup berulang buku |
| 2NF | PEMINJAMAN, BUKU, DETAIL_PEMINJAMAN | Ketergantungan sebagian pada kunci komposit (FD1, FD4) |
| 3NF | PEMINJAMAN, DETAIL_PEMINJAMAN, BUKU, PETUGAS, ANGGOTA | Ketergantungan transitif lewat kode_petugas dan no_anggota |

---

## 4. Keputusan Nilai Turunan

| Nilai | Keputusan | Alasan |
|---|---|---|
| hari_telat_detail | Dihitung, tidak disimpan | Selisih tgl_kembali_detail dan tgl_jatuh_tempo; bila disimpan bisa berbeda dari tanggalnya sendiri |
| denda_detail | Dihitung, tidak disimpan | hari_telat x tarif_denda_detail; kedua masukannya sudah tersimpan |
| total_denda | Dihitung, tidak disimpan | Jumlah denda seluruh buku pada satu peminjaman |
| tarif_denda_detail | **Disimpan** di detail | Bukan nilai turunan: ini tarif saat peminjaman (AB-P04). Bila hanya dibaca dari pengaturan terbaru, denda peminjaman lama berubah mengikuti tarif baru |
| tgl_jatuh_tempo | **Disimpan** di peminjaman | Janji yang dibuat saat transaksi (AB-P06). Lama pinjam dapat berubah, sehingga jatuh tempo lama tidak boleh ikut bergeser |

---

## 5. Pemeriksaan BCNF

| Tabel | Penentu | Kunci kandidat | Hasil |
|---|---|---|---|
| petugas | kode_petugas | kode_petugas | BCNF |
| anggota | no_anggota, nim_anggota | no_anggota, nim_anggota | BCNF |
| buku | kode_buku | kode_buku | BCNF (judul_buku tidak menentukan atribut lain karena dua buku dapat berjudul sama) |
| peminjaman | no_peminjaman | no_peminjaman | BCNF |
| detail_peminjaman | (no_peminjaman, kode_buku) | (no_peminjaman, kode_buku) | BCNF |

Tidak ada penentu yang bukan kunci kandidat, sehingga seluruh relasi memenuhi 3NF dan BCNF.

---

## 6. Skema Relasional Akhir (dengan kunci pengganti)

Mengikuti pola skema kanonik Kopma: kunci pengganti `id_*` menjadi kunci primer, kode alami menjadi kunci unik. Kunci pengganti tidak dianggap menyelesaikan normalisasi; pemeriksaan di bagian 5 memakai kunci alami.

| Tabel | Kunci primer | Kunci unik | Kunci tamu | Kolom lain |
|---|---|---|---|---|
| petugas | id_petugas | kode_petugas | - | nama_petugas |
| anggota | id_anggota | no_anggota, nim_anggota | - | nama_anggota, prodi_anggota, status_anggota |
| buku | id_buku | kode_buku | - | judul_buku, pengarang_buku, kategori_buku |
| peminjaman | id_peminjaman | no_peminjaman | id_petugas, id_anggota (wajib, tidak boleh NULL) | tgl_peminjaman, tgl_jatuh_tempo |
| detail_peminjaman | (id_peminjaman, id_buku) | - | id_peminjaman, id_buku | tgl_kembali_detail (NULL bila belum kembali), tarif_denda_detail |

Hubungan: petugas 1 - N peminjaman; anggota 1 - N peminjaman; peminjaman 1 - N detail_peminjaman; buku 1 - N detail_peminjaman (relasi banyak-ke-banyak peminjaman dan buku dipecah oleh entitas asosiatif detail_peminjaman).

---

## 7. Perubahan pada ERD Proyek

| Perubahan | Alasan |
|---|---|
| Atribut turunan hari_telat, denda, dan total_denda dihapus dari ERD | Diputuskan dihitung, bukan disimpan (bagian 4) |
| Atribut tarif_denda_detail ditambahkan pada entitas asosiatif detail_peminjaman | Menyimpan tarif saat transaksi (AB-P04) |
| Kunci pengganti id_* ditambahkan pada setiap entitas | Mengikuti skema kanonik; kode alami menjadi kunci unik |

Skema 3NF di atas menjadi dasar skrip DDL Pertemuan 5; setiap kunci dan aturan di dokumen ini harus muncul sebagai constraint.