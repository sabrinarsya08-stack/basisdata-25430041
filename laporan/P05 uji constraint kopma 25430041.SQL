```sql
-- p05_uji_constraint_kopma_25430041.sql
-- Modul 5: Pengujian constraint
-- Jalankan setelah p05_ddl_kopma_25430041.sql.
-- Setiap perintah bertanda DITOLAK seharusnya menghasilkan error.

USE kopma_41;

-- D.1 Data induk secukupnya
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas)
VALUES
('K01', 'Dimas', 'kasir'),
('G01', 'Joko', 'gudang');

INSERT INTO barang
(kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang)
VALUES
('ATK-001', 'Pulpen Gel 0.5', 'ATK', 4000, 120),
('MNM-001', 'Air Mineral 600', 'minuman', 4000, 48);

-- D.3 DITOLAK: FOREIGN KEY
-- ID petugas 99 tidak tersedia.
INSERT INTO penjualan
(no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES
('PJ-2609-0199', NOW(), 99, NULL, 5000);

-- DITOLAK: CHECK stok tidak boleh negatif (AB-03).
UPDATE barang
SET stok_barang = -1
WHERE id_barang = 1;

-- DITOLAK: UNIQUE kode barang tidak boleh duplikat.
INSERT INTO barang
(kode_barang, nama_barang, kategori_barang, harga_jual_barang)
VALUES
('ATK-001', 'Duplikat', 'ATK', 1000);

-- D.4 ALTER TABLE: menambah lalu menghapus kolom.
ALTER TABLE barang
ADD COLUMN tgl_kedaluwarsa DATE NULL AFTER stok_min_barang;

ALTER TABLE barang
DROP COLUMN tgl_kedaluwarsa;

-- E.1 CHECK: stok minimum tidak boleh negatif.
ALTER TABLE barang
ADD CONSTRAINT ck_barang_stokmin
CHECK (stok_min_barang >= 0);

-- DITOLAK: stok minimum negatif.
UPDATE barang
SET stok_min_barang = -5
WHERE id_barang = 1;

-- E.2 FOREIGN KEY dengan ON DELETE SET NULL.
ALTER TABLE penjualan
DROP FOREIGN KEY fk_penjualan_anggota;

ALTER TABLE penjualan
ADD CONSTRAINT fk_penjualan_anggota
FOREIGN KEY (id_anggota)
REFERENCES anggota (id_anggota)
ON DELETE SET NULL;

-- Bukti struktur tabel setelah perubahan.
SHOW CREATE TABLE penjualan;
```