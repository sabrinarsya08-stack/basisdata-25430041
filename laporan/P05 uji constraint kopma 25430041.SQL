-- p05_uji_constraint_kopma_25430041.sql
-- Jalankan SETELAH p05_ddl_kopma_25430041.sql. Setiap perintah bertanda "DITOLAK" harus galat.
USE kopma_041;

-- Data induk secukupnya
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas) VALUES
  ('K01','Dimas','kasir'), ('G01','Joko','gudang');
INSERT INTO barang (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang) VALUES
  ('ATK-001','Pulpen Gel 0.5','ATK',4000,120),
  ('MNM-001','Air Mineral 600','minuman',4000,48);

-- D.3 DITOLAK: ERROR 1452 (petugas 99 tidak ada) -> fk_penjualan_petugas
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0199', NOW(), 99, NULL, 5000);

-- DITOLAK: ERROR 4025 (stok negatif) -> ck_barang_stok, AB-03
UPDATE barang SET stok_barang = -1 WHERE id_barang = 1;

-- DITOLAK: ERROR 1062 (kode kembar) -> uq_barang_kode
INSERT INTO barang (kode_barang, nama_barang, kategori_barang, harga_jual_barang)
VALUES ('ATK-001','Duplikat','ATK',1000);

-- D.4 ALTER TABLE (dicoba lalu dibatalkan)
ALTER TABLE barang ADD COLUMN tgl_kedaluwarsa DATE NULL AFTER stok_min_barang;
ALTER TABLE barang DROP COLUMN tgl_kedaluwarsa;

-- Latihan E1: stok_min tidak boleh negatif
ALTER TABLE barang ADD CONSTRAINT ck_barang_stokmin CHECK (stok_min_barang >= 0);
-- DITOLAK: ERROR 4025
UPDATE barang SET stok_min_barang = -5 WHERE id_barang = 1;

-- Latihan E2: ON DELETE SET NULL pada anggota
ALTER TABLE penjualan DROP FOREIGN KEY fk_penjualan_anggota;
ALTER TABLE penjualan ADD CONSTRAINT fk_penjualan_anggota
  FOREIGN KEY (id_anggota) REFERENCES anggota (id_anggota) ON DELETE SET NULL;

-- Bukti struktur
SHOW CREATE TABLE penjualan;