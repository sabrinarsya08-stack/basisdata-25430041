-- p06_langkah_kopma_25430041.sql
-- Modul 6 D.3, D.4 dan Latihan E. Jalankan SETELAH p06_data_kopma_25430041.sql.
-- Perintah bertanda "DITOLAK" memang harus galat; jalankan satu per satu di phpMyAdmin/CLI dan ss hasilnya.
USE kopma_041;

-- ===== D.3 langkah 5: mode aman =====
SET SESSION sql_safe_updates = 1;
UPDATE barang SET harga_jual_barang = harga_jual_barang * 1.1;          -- DITOLAK: ERROR 1175
UPDATE barang SET harga_jual_barang = harga_jual_barang * 1.1
WHERE kategori_barang = 'ATK' AND id_barang > 0;                        -- diterima (kolom kunci)
-- kembalikan harga ATK agar data tetap sama dengan skrip
UPDATE barang SET harga_jual_barang = CASE kode_barang WHEN 'ATK-001' THEN 4000 WHEN 'ATK-002' THEN 6500 END
WHERE kode_barang IN ('ATK-001','ATK-002');

-- ===== D.3 langkah 6: CASCADE vs RESTRICT =====
SELECT COUNT(*) AS detail_nota_0143 FROM detail_penjualan
 WHERE id_penjualan = (SELECT id_penjualan FROM penjualan WHERE no_nota_penjualan = 'PJ-2609-0143');  -- 1
DELETE FROM penjualan WHERE no_nota_penjualan = 'PJ-2609-0143';  -- uq key; detail ikut terhapus
SELECT COUNT(*) AS sisa_detail_yatim FROM detail_penjualan d
 LEFT JOIN penjualan p ON p.id_penjualan = d.id_penjualan WHERE p.id_penjualan IS NULL;                -- 0
-- stok roti dikembalikan karena nota dibatalkan
UPDATE barang SET stok_barang = stok_barang + 2 WHERE kode_barang = 'MKN-001';
DELETE FROM petugas WHERE kode_petugas = 'K03';   -- DITOLAK: ERROR 1451 (Rina pernah melayani nota 0142)

-- ===== D.4 skenario uji (UJ-01 s.d. UJ-09) =====
-- UJ-01 diterima: nota anggota aktif
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
SELECT 'PJ-2609-0150', NOW(), p.id_petugas, a.id_anggota, 8000
FROM petugas p, anggota a WHERE p.kode_petugas = 'K01' AND a.no_anggota = 'A-0458';
-- UJ-02 diterima: nota tanpa anggota
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
SELECT 'PJ-2609-0151', NOW(), p.id_petugas, NULL, 4000 FROM petugas p WHERE p.kode_petugas = 'K01';
-- UJ-03 DITOLAK ERROR 4025: stok -5
UPDATE barang SET stok_barang = -5 WHERE kode_barang = 'ATK-001';
-- UJ-04 DITOLAK ERROR 1062: nomor nota kembar
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
SELECT 'PJ-2609-0142', NOW(), p.id_petugas, NULL, 1000 FROM petugas p WHERE p.kode_petugas = 'K01';
-- UJ-05 DITOLAK ERROR 4025: qty 0
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT pj.id_penjualan, b.id_barang, 0, b.harga_jual_barang
FROM penjualan pj, barang b WHERE pj.no_nota_penjualan = 'PJ-2609-0150' AND b.kode_barang = 'ATK-002';
-- UJ-06 DITOLAK ERROR 1062: NIM kembar
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, tgl_daftar_anggota)
VALUES ('A-0999','2543000101','Penyusup','Teknik Informatika','2026-10-01');
-- UJ-07 DITOLAK ERROR 1452: petugas tidak dikenal
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0152', NOW(), 99, NULL, 1000);
-- UJ-08 DITOLAK ERROR 1175: UPDATE tanpa WHERE di mode aman
UPDATE barang SET stok_min_barang = 10;
-- UJ-09 (PERKIRAAN GAGAL): qty melebihi stok tetap DITERIMA. Stok roti hanya 6, qty 500.
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT pj.id_penjualan, b.id_barang, 500, b.harga_jual_barang
FROM penjualan pj, barang b WHERE pj.no_nota_penjualan = 'PJ-2609-0150' AND b.kode_barang = 'MKN-001';
-- bersihkan akibat UJ-01, UJ-02, UJ-09 agar data kembali seperti skrip
DELETE FROM penjualan WHERE no_nota_penjualan IN ('PJ-2609-0150','PJ-2609-0151');

-- ===== Latihan E1: arsipkan anggota nonaktif yang daftar sebelum 2025 =====
DROP TABLE IF EXISTS anggota_arsip;
CREATE TABLE anggota_arsip LIKE anggota;
INSERT INTO anggota_arsip
SELECT * FROM anggota a
WHERE a.status_anggota = 'nonaktif' AND a.tgl_daftar_anggota < '2025-01-01'
  AND NOT EXISTS (SELECT 1 FROM penjualan p WHERE p.id_anggota = a.id_anggota);
DELETE FROM anggota
WHERE status_anggota = 'nonaktif' AND tgl_daftar_anggota < '2025-01-01' AND id_anggota > 0
  AND id_anggota IN (SELECT id_anggota FROM anggota_arsip);
SELECT no_anggota, status_anggota FROM anggota;        -- A-0120 tetap ada (punya nota), A-0121 pindah
SELECT no_anggota FROM anggota_arsip;

-- ===== Latihan E2: harga makanan +5%, dibulatkan ke ratusan =====
UPDATE barang SET harga_jual_barang = ROUND(harga_jual_barang * 1.05, -2)
WHERE kategori_barang = 'makanan' AND id_barang > 0;
SELECT kode_barang, harga_jual_barang FROM barang WHERE kategori_barang = 'makanan';  -- 5000 -> 5300