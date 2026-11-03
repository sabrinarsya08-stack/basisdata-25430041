-- p06_data_kopma_25430041.sql
-- Modul 6 D.1-D.2: data sampel Kopma. Jalankan SETELAH p05_ddl_kopma_25430041.sql (basis data kosong).
-- Urutan: induk dulu, anak kemudian. Kunci tamu diambil lewat kode alami, bukan menebak id.
USE kopma_041;

-- ===== D.1 Data induk =====
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas) VALUES
  ('K01','Dimas','kasir'), ('K02','Sari','kasir'), ('K03','Rina','kasir'),
  ('G01','Joko','gudang'), ('P01','Ketua Kopma','ketua');

INSERT INTO barang (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang) VALUES
  ('ATK-001','Pulpen Gel 0.5','ATK',4000,120,20),
  ('ATK-002','Buku Tulis 58','ATK',6500,80,20),
  ('MNM-001','Air Mineral 600','minuman',4000,48,24),
  ('MKN-001','Roti Cokelat','makanan',5000,6,10);

-- Anggota: 2 aktif, 2 nonaktif (daftar sebelum 2025; dipakai Latihan E1)
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota) VALUES
  ('A-0457','2543000101','Anindya Putri','Teknik Informatika','081234560001','aktif','2025-08-18'),
  ('A-0458','2543000102','Bagas Pratama','Sistem Informasi','081234560002','aktif','2025-08-20'),
  ('A-0120','2243000055','Citra Maharani','Manajemen','081234560003','nonaktif','2024-02-10'),
  ('A-0121','2243000056','Dwi Santoso','Akuntansi',NULL,'nonaktif','2024-02-12');

INSERT INTO pemasok (nama_pemasok, telepon_pemasok, alamat_pemasok) VALUES
  ('CV Sumber Alat Tulis','0274-555101','Jl. Kaliurang Km 5, Sleman'),
  ('UD Berkah Snack','0274-555202','Jl. Godean Km 3, Sleman');

-- ===== D.2 Nota penjualan =====
-- Nota 1 (contoh Modul 2): anggota aktif A-0457 dilayani kasir K03 (Rina)
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
SELECT 'PJ-2609-0142', '2026-09-24 10:15:00', p.id_petugas, a.id_anggota, 30000
FROM petugas p, anggota a WHERE p.kode_petugas = 'K03' AND a.no_anggota = 'A-0457';

INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT pj.id_penjualan, b.id_barang, x.qty, b.harga_jual_barang   -- AB-04: harga disalin dari barang
FROM penjualan pj
JOIN (SELECT 'ATK-001' kode, 3 qty UNION ALL SELECT 'ATK-002', 2 UNION ALL SELECT 'MNM-001', 1) x
JOIN barang b ON b.kode_barang = x.kode
WHERE pj.no_nota_penjualan = 'PJ-2609-0142';

-- Nota 2: nota uji, nanti dihapus di langkah D.3 (bukti ON DELETE CASCADE)
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
SELECT 'PJ-2609-0143', '2026-09-24 11:30:00', p.id_petugas, a.id_anggota, 10000
FROM petugas p, anggota a WHERE p.kode_petugas = 'K01' AND a.no_anggota = 'A-0458';

INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT pj.id_penjualan, b.id_barang, 2, b.harga_jual_barang
FROM penjualan pj, barang b
WHERE pj.no_nota_penjualan = 'PJ-2609-0143' AND b.kode_barang = 'MKN-001';

-- Nota 3: pembeli umum (id_anggota NULL, AB-02) oleh K01
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
SELECT 'PJ-2609-0144', '2026-09-25 09:05:00', p.id_petugas, NULL, 10000
FROM petugas p WHERE p.kode_petugas = 'K01';

INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT pj.id_penjualan, b.id_barang, 2, b.harga_jual_barang
FROM penjualan pj, barang b
WHERE pj.no_nota_penjualan = 'PJ-2609-0144' AND b.kode_barang = 'MNM-001';

-- Nota 4: anggota nonaktif A-0120 pernah belanja (dipakai Latihan E1: tidak boleh ikut diarsipkan/dihapus)
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
SELECT 'PJ-2501-0007', '2025-01-15 14:20:00', p.id_petugas, a.id_anggota, 5000
FROM petugas p, anggota a WHERE p.kode_petugas = 'K02' AND a.no_anggota = 'A-0120';

INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT pj.id_penjualan, b.id_barang, 1, b.harga_jual_barang
FROM penjualan pj, barang b
WHERE pj.no_nota_penjualan = 'PJ-2501-0007' AND b.kode_barang = 'MKN-001';

-- ===== Kurangi stok sesuai qty (D.2 langkah 4). WHERE memakai kolom kunci UNIQUE (kode_barang) =====
SET SESSION sql_safe_updates = 1;
UPDATE barang SET stok_barang = stok_barang - 3 WHERE kode_barang = 'ATK-001';  -- nota 1
UPDATE barang SET stok_barang = stok_barang - 2 WHERE kode_barang = 'ATK-002';  -- nota 1
UPDATE barang SET stok_barang = stok_barang - 1 WHERE kode_barang = 'MNM-001';  -- nota 1
UPDATE barang SET stok_barang = stok_barang - 2 WHERE kode_barang = 'MKN-001';  -- nota 2 (stok 6 -> 4)
UPDATE barang SET stok_barang = stok_barang - 2 WHERE kode_barang = 'MNM-001';  -- nota 3

-- Bukti jumlah baris (untuk tangkapan layar)
SELECT 'petugas' tabel, COUNT(*) baris FROM petugas
UNION ALL SELECT 'anggota', COUNT(*) FROM anggota
UNION ALL SELECT 'barang', COUNT(*) FROM barang
UNION ALL SELECT 'pemasok', COUNT(*) FROM pemasok
UNION ALL SELECT 'penjualan', COUNT(*) FROM penjualan
UNION ALL SELECT 'detail_penjualan', COUNT(*) FROM detail_penjualan;