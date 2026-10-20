-- p01_lingkungan_25430041.sql
CREATE DATABASE IF NOT EXISTS perpus_41
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'dev_41'@'localhost' IDENTIFIED BY '<password_kerja>';
GRANT ALL PRIVILEGES ON perpus_41.* TO 'dev_41'@'localhost';