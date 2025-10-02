CREATE DATABASE IF NOT EXISTS farmagestion 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;
USE farmagestion;
SET sql_safe_updates = 0;
SET FOREIGN_KEY_CHECKS = 1;
-- DROP DATABASE farmagestion;
-- PROVEEDORES
DROP TABLE IF EXISTS proveedores;
CREATE TABLE proveedores (
  id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(150) NOT NULL,
  nit VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;
-- UBICACIONES
DROP TABLE IF EXISTS ubicaciones;
CREATE TABLE ubicaciones (
  id_ubicacion INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL
) ENGINE=InnoDB;
-- ITEMS
DROP TABLE IF EXISTS items;
CREATE TABLE items (
  id_item INT AUTO_INCREMENT PRIMARY KEY,
  id_ubicacion INT NOT NULL,
  descripcion VARCHAR(255) NOT NULL,
  tipo_item ENUM('MEDICAMENTO','DISPOSITIVO') NOT NULL,
  stock INT DEFAULT 0,
  FOREIGN KEY (id_ubicacion) REFERENCES ubicaciones(id_ubicacion)
) ENGINE=InnoDB;
-- LOTES
DROP TABLE IF EXISTS lotes;
CREATE TABLE lotes (
  id_lote INT AUTO_INCREMENT PRIMARY KEY,
  id_proveedor INT NOT NULL,
  codigo_lote VARCHAR(50) NOT NULL,
  fecha_vencimiento DATE NOT NULL,
  costo_unitario DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor)
) ENGINE=InnoDB;
-- LOTES_ITEMS (relación puente original)
DROP TABLE IF EXISTS lotes_items;
CREATE TABLE lotes_items (
  id_lote_item INT AUTO_INCREMENT PRIMARY KEY,
  id_item INT NOT NULL,
  id_lote INT NOT NULL,
  FOREIGN KEY (id_item) REFERENCES items(id_item),
  FOREIGN KEY (id_lote) REFERENCES lotes(id_lote)
) ENGINE=InnoDB;
-- USUARIOS
DROP TABLE IF EXISTS usuarios;
CREATE TABLE usuarios (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  nombre_completo VARCHAR(150) NOT NULL,
  correo VARCHAR(150) NOT NULL UNIQUE,
  rol ENUM('AUXILIAR','REGENTE','AUDITOR','ADMIN') NOT NULL,
  contrasena VARCHAR(255) NOT NULL
) ENGINE=InnoDB;
-- MOVIMIENTOS (tabla original, con origen/destino texto)
DROP TABLE IF EXISTS movimientos;
CREATE TABLE movimientos (
  id_movimiento INT AUTO_INCREMENT PRIMARY KEY,
  id_lote INT NOT NULL,
  id_usuario INT NOT NULL,
  tipo_movimiento ENUM('INGRESO','SALIDA','TRANSFERENCIA','AJUSTE') NOT NULL,
  cantidad INT NOT NULL,
  origen VARCHAR(100),
  destino VARCHAR(100),
  fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
  motivo VARCHAR(255),
  FOREIGN KEY (id_lote) REFERENCES lotes(id_lote),
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
) ENGINE=InnoDB;
-- ===============================
-- DML de ejemplo
-- ===============================
INSERT INTO proveedores (id_proveedor, nombre, nit) VALUES
(1, 'Proveedor 01', '900100001-1'),
(2, 'Proveedor 02', '900100002-2'),
(3, 'Proveedor 03', '900100003-3'),
(4, 'Proveedor 04', '900100004-4'),
(5, 'Proveedor 05', '900100005-5'),
(6, 'Proveedor 06', '900100006-6'),
(7, 'Proveedor 07', '900100007-7'),
(8, 'Proveedor 08', '900100008-8'),
(9, 'Proveedor 09', '900100009-9'),
(10, 'Proveedor 10', '900100010-0'),
(11, 'Proveedor 11', '900100011-1'),
(12, 'Proveedor 12', '900100012-2'),
(13, 'Proveedor 13', '900100013-3'),
(14, 'Proveedor 14', '900100014-4'),
(15, 'Proveedor 15', '900100015-5'),
(16, 'Proveedor 16', '900100016-6'),
(17, 'Proveedor 17', '900100017-7'),
(18, 'Proveedor 18', '900100018-8'),
(19, 'Proveedor 19', '900100019-9'),
(20, 'Proveedor 20', '900100020-0');
INSERT INTO ubicaciones (id_ubicacion, nombre) VALUES
(1, 'Almacén Central'),
(2, 'Farmacia 1'),
(3, 'Farmacia 2'),
(4, 'Urgencias'),
(5, 'UCI'),
(6, 'Quirófano'),
(7, 'Pediatría'),
(8, 'Hospitalización A'),
(9, 'Hospitalización B'),
(10, 'Laboratorio'),
(11, 'Imagenología'),
(12, 'Oncología'),
(13, 'Ginecología'),
(14, 'Cardiología'),
(15, 'Nefrología'),
(16, 'Trauma'),
(17, 'Ortopedia'),
(18, 'Dermatología'),
(19, 'Emergencias'),
(20, 'Vacunación');
INSERT INTO items (id_item, id_ubicacion, descripcion, tipo_item, stock) VALUES
(1, 1, 'Paracetamol 500 mg', 'MEDICAMENTO', 300),
(2, 2, 'Ibuprofeno 400 mg', 'MEDICAMENTO', 250),
(3, 3, 'Amoxicilina 500 mg', 'MEDICAMENTO', 180),
(4, 4, 'Omeprazol 20 mg', 'MEDICAMENTO', 220),
(5, 5, 'Aspirina 100 mg', 'MEDICAMENTO', 190),
(6, 6, 'Metformina 850 mg', 'MEDICAMENTO', 260),
(7, 7, 'Losartán 50 mg', 'MEDICAMENTO', 210),
(8, 8, 'Atorvastatina 20 mg', 'MEDICAMENTO', 170),
(9, 9, 'Salbutamol Inhalador', 'MEDICAMENTO', 120),
(10, 10, 'Ceftriaxona 1 g', 'MEDICAMENTO', 150),
(11, 11, 'Guantes Nitrilo Talla M', 'DISPOSITIVO', 800),
(12, 12, 'Jeringa 5 ml', 'DISPOSITIVO', 600),
(13, 13, 'Gasas Estériles 10x10', 'DISPOSITIVO', 900),
(14, 14, 'Catéter IV #18', 'DISPOSITIVO', 350),
(15, 15, 'Sonda Foley 16Fr', 'DISPOSITIVO', 140),
(16, 16, 'Bisturí #10', 'DISPOSITIVO', 500),
(17, 17, 'Venda Elástica 10 cm', 'DISPOSITIVO', 420),
(18, 18, 'Termómetro Digital', 'DISPOSITIVO', 75),
(19, 19, 'Tiras Reactivas Glucosa', 'DISPOSITIVO', 320),
(20, 20, 'Alcohol Antiséptico 70%', 'DISPOSITIVO', 450);
INSERT INTO lotes (id_lote, id_proveedor, codigo_lote, fecha_vencimiento, costo_unitario) VALUES
(1, 1, 'L-0001', '2026-01-15', 0.50),
(2, 2, 'L-0002', '2026-03-20', 0.85),
(3, 3, 'L-0003', '2026-06-30', 1.20),
(4, 4, 'L-0004', '2025-12-10', 0.95),
(5, 5, 'L-0005', '2026-09-05', 1.75),
(6, 6, 'L-0006', '2027-01-01', 2.40),
(7, 7, 'L-0007', '2026-11-11', 3.25),
(8, 8, 'L-0008', '2025-10-25', 1.10),
(9, 9, 'L-0009', '2026-05-14', 0.60),
(10, 10, 'L-0010', '2027-02-28', 4.80),
(11, 11, 'L-0011', '2026-08-18', 0.12),
(12, 12, 'L-0012', '2025-11-30', 0.18),
(13, 13, 'L-0013', '2026-04-01', 0.25),
(14, 14, 'L-0014', '2026-12-31', 2.10),
(15, 15, 'L-0015', '2026-07-07', 5.50),
(16, 16, 'L-0016', '2026-10-10', 0.90),
(17, 17, 'L-0017', '2026-02-02', 0.70),
(18, 18, 'L-0018', '2026-03-03', 1.35),
(19, 19, 'L-0019', '2026-06-06', 0.40),
(20, 20, 'L-0020', '2025-12-31', 0.55);
INSERT INTO lotes_items (id_lote_item, id_item, id_lote) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 6),
(7, 7, 7),
(8, 8, 8),
(9, 9, 9),
(10, 10, 10),
(11, 11, 11),
(12, 12, 12),
(13, 13, 13),
(14, 14, 14),
(15, 15, 15),
(16, 16, 16),
(17, 17, 17),
(18, 18, 18),
(19, 19, 19),
(20, 20, 20);
INSERT INTO usuarios (id_usuario, nombre_completo, correo, rol, contrasena) VALUES
(1, 'Ana Pérez', 'ana.perez@hospital.local', 'AUXILIAR', '$2b$10$demoHash00000000000000000000000000000000000000000000000001'),
(2, 'Bruno Díaz', 'bruno.diaz@hospital.local', 'REGENTE', '$2b$10$demoHash00000000000000000000000000000000000000000000000002'),
(3, 'Carla Gómez', 'carla.gomez@hospital.local', 'AUDITOR', '$2b$10$demoHash00000000000000000000000000000000000000000000000003'),
(4, 'David Ruiz', 'david.ruiz@hospital.local', 'ADMIN', '$2b$10$demoHash00000000000000000000000000000000000000000000000004'),
(5, 'Elena Torres', 'elena.torres@hospital.local', 'AUXILIAR', '$2b$10$demoHash00000000000000000000000000000000000000000000000005'),
(6, 'Fernando Silva', 'fernando.silva@hospital.local', 'REGENTE', '$2b$10$demoHash00000000000000000000000000000000000000000000000006'),
(7, 'Gloria Martínez', 'gloria.martinez@hospital.local', 'AUDITOR', '$2b$10$demoHash00000000000000000000000000000000000000000000000007'),
(8, 'Héctor López', 'hector.lopez@hospital.local', 'ADMIN', '$2b$10$demoHash00000000000000000000000000000000000000000000000008'),
(9, 'Irene Castillo', 'irene.castillo@hospital.local', 'AUXILIAR', '$2b$10$demoHash00000000000000000000000000000000000000000000000009'),
(10, 'Jorge Rojas', 'jorge.rojas@hospital.local', 'REGENTE', '$2b$10$demoHash00000000000000000000000000000000000000000000000010'),
(11, 'Karen Velasco', 'karen.velasco@hospital.local', 'AUDITOR', '$2b$10$demoHash00000000000000000000000000000000000000000000000011'),
(12, 'Luis Mendoza', 'luis.mendoza@hospital.local', 'ADMIN', '$2b$10$demoHash00000000000000000000000000000000000000000000000012'),
(13, 'María Rodríguez', 'maria.rodriguez@hospital.local', 'AUXILIAR', '$2b$10$demoHash00000000000000000000000000000000000000000000000013'),
(14, 'Nicolás Herrera', 'nicolas.herrera@hospital.local', 'REGENTE', '$2b$10$demoHash00000000000000000000000000000000000000000000000014'),
(15, 'Olga Prieto', 'olga.prieto@hospital.local', 'AUDITOR', '$2b$10$demoHash00000000000000000000000000000000000000000000000015'),
(16, 'Pablo Benítez', 'pablo.benitez@hospital.local', 'ADMIN', '$2b$10$demoHash00000000000000000000000000000000000000000000000016'),
(17, 'Quena Salazar', 'quena.salazar@hospital.local', 'AUXILIAR', '$2b$10$demoHash00000000000000000000000000000000000000000000000017'),
(18, 'Raúl Cárdenas', 'raul.cardenas@hospital.local', 'REGENTE', '$2b$10$demoHash00000000000000000000000000000000000000000000000018'),
(19, 'Sara Valdés', 'sara.valdes@hospital.local', 'AUDITOR', '$2b$10$demoHash00000000000000000000000000000000000000000000000019'),
(20, 'Tomás Gutiérrez', 'tomas.gutierrez@hospital.local', 'ADMIN', '$2b$10$demoHash00000000000000000000000000000000000000000000000020');
INSERT INTO movimientos (id_movimiento, id_lote, id_usuario, tipo_movimiento, cantidad, origen, destino, fecha, motivo) VALUES
-- INGRESOS al Almacén Central
(1, 1, 1, 'INGRESO', 100, NULL, 'Almacén Central', '2025-08-20 09:00:00', 'Recepción de proveedor'),
(2, 2, 2, 'INGRESO', 200, NULL, 'Almacén Central', '2025-08-21 10:30:00', 'Recepción de proveedor'),
(3, 3, 1, 'INGRESO', 150, NULL, 'Almacén Central', '2025-08-22 11:15:00', 'Recepción de proveedor'),
(4, 4, 5, 'INGRESO', 180, NULL, 'Almacén Central', '2025-08-23 08:40:00', 'Recepción de proveedor'),
(5, 5, 6, 'INGRESO', 120, NULL, 'Almacén Central', '2025-08-24 14:05:00', 'Recepción de proveedor'),
(6, 6, 9, 'INGRESO', 300, NULL, 'Almacén Central', '2025-08-25 16:45:00', 'Recepción de proveedor'),
(7, 7, 10, 'INGRESO', 220, NULL, 'Almacén Central', '2025-08-26 09:20:00', 'Recepción de proveedor'),
(8, 8, 13, 'INGRESO', 140, NULL, 'Almacén Central', '2025-08-27 13:10:00', 'Recepción de proveedor'),
-- SALIDAS desde Almacén Central a servicios
(9, 1, 2, 'SALIDA', 20, 'Almacén Central', 'Urgencias', '2025-08-28 10:00:00', 'Dispensación a servicio'),
(10, 2, 5, 'SALIDA', 30, 'Almacén Central', 'UCI', '2025-08-28 10:30:00', 'Dispensación a servicio'),
(11, 3, 6, 'SALIDA', 15, 'Almacén Central', 'Pediatría', '2025-08-28 11:00:00', 'Dispensación a servicio'),
(12, 4, 9, 'SALIDA', 25, 'Almacén Central', 'Quirófano', '2025-08-28 11:30:00', 'Dispensación a servicio'),
(13, 5, 10, 'SALIDA', 10, 'Almacén Central', 'Hospitalización A','2025-08-28 12:00:00', 'Dispensación a servicio'),
(14, 6, 13, 'SALIDA', 40, 'Almacén Central', 'Laboratorio', '2025-08-28 12:30:00', 'Dispensación a servicio'),
-- TRANSFERENCIAS entre ubicaciones
(15, 7, 14, 'TRANSFERENCIA', 30, 'Almacén Central', 'UCI', '2025-08-29 09:00:00', 'Reabastecimiento'),
(16, 8, 1, 'TRANSFERENCIA', 20, 'Almacén Central', 'Quirófano', '2025-08-29 09:30:00', 'Reabastecimiento'),
(17, 9, 2, 'TRANSFERENCIA', 15, 'Almacén Central', 'Pediatría', '2025-08-29 10:00:00', 'Reabastecimiento'),
(18, 10, 5, 'TRANSFERENCIA', 12, 'Almacén Central', 'Oncología', '2025-08-29 10:30:00', 'Reabastecimiento'),
-- AJUSTES sobre ubicaciones
(19, 2, 6, 'AJUSTE', 5, 'Almacén Central', NULL, '2025-08-30 08:15:00', 'Corrección conteo físico'),
(20, 5, 9, 'AJUSTE', 3, 'Laboratorio', NULL, '2025-08-30 08:45:00', 'Daño de empaque');
-- =============================================================
-- 2) Migración condicional: normaliza catálogo y prepara trazabilidad por lote/ubicación
-- =============================================================
DROP PROCEDURE IF EXISTS sp_upgrade_schema;
DELIMITER $$
CREATE PROCEDURE sp_upgrade_schema()
BEGIN
  DECLARE v_exists INT DEFAULT 0;
  DECLARE v_has_lotes_items INT DEFAULT 0;
  DECLARE v_null_lotes INT DEFAULT 0;
  -- UBICACIONES: tipo
  SELECT COUNT(*) INTO v_exists
  FROM information_schema.columns
  WHERE table_schema = DATABASE()
    AND table_name='ubicaciones'
    AND column_name='tipo';
  IF v_exists = 0 THEN
    SET @sql = 'ALTER TABLE ubicaciones ADD COLUMN tipo ENUM(''ALMACEN'',''SERVICIO'') NOT NULL DEFAULT ''ALMACEN''';
    PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
  END IF;
  -- UBICACIONES: activo
  SELECT COUNT(*) INTO v_exists
  FROM information_schema.columns
  WHERE table_schema = DATABASE()
    AND table_name='ubicaciones'
    AND column_name='activo';
  IF v_exists = 0 THEN
    SET @sql = 'ALTER TABLE ubicaciones ADD COLUMN activo TINYINT(1) NOT NULL DEFAULT 1';
    PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
  END IF;
  -- UBICACIONES: UNIQUE(nombre)
  SELECT COUNT(*) INTO v_exists
  FROM information_schema.statistics
  WHERE table_schema = DATABASE()
    AND table_name='ubicaciones'
    AND index_name='ux_ubicaciones_nombre';
  IF v_exists = 0 THEN
    SET @sql = 'ALTER TABLE ubicaciones ADD UNIQUE KEY ux_ubicaciones_nombre (nombre)';
    PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
  END IF;
  -- ITEMS: codigo
  SELECT COUNT(*) INTO v_exists
  FROM information_schema.columns
  WHERE table_schema = DATABASE() AND table_name='items' AND column_name='codigo';
  IF v_exists = 0 THEN
    SET @sql = 'ALTER TABLE items ADD COLUMN codigo VARCHAR(50) NULL';
    PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
  ELSE
  -- Si existe pero fue creada con NOT NULL DEFAULT 'PENDIENTE', la normalizamos
  -- (este ALTER es seguro si ya está en NULL o sin default)
    SET @sql = 'ALTER TABLE items MODIFY codigo VARCHAR(50) NULL';
    PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
END IF;
  -- ITEMS: unidad_medida
  SELECT COUNT(*) INTO v_exists
  FROM information_schema.columns
  WHERE table_schema = DATABASE() AND table_name='items' AND column_name='unidad_medida';
  IF v_exists = 0 THEN
    SET @sql = 'ALTER TABLE items ADD COLUMN unidad_medida VARCHAR(20) NOT NULL DEFAULT ''UND''';
    PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
END IF;
  -- ITEMS: stock_minimo
  SELECT COUNT(*) INTO v_exists
  FROM information_schema.columns
  WHERE table_schema = DATABASE() AND table_name='items' AND column_name='stock_minimo';
  IF v_exists = 0 THEN
    SET @sql = 'ALTER TABLE items ADD COLUMN stock_minimo INT NOT NULL DEFAULT 0';
    PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
END IF;
  UPDATE items
  SET codigo = CONCAT('ITM-', LPAD(id_item, 6, '0'))
  WHERE codigo IS NULL OR codigo = '' OR codigo = 'PENDIENTE';
  -- ITEMS: UNIQUE(codigo)
  SELECT COUNT(*) INTO v_exists
  FROM information_schema.statistics
  WHERE table_schema = DATABASE() AND table_name='items' AND index_name='ux_items_codigo';
  IF v_exists = 0 THEN
    SET @sql = 'ALTER TABLE items ADD UNIQUE KEY ux_items_codigo (codigo)';
    PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
END IF;
  -- LOTES: id_item + migración desde lotes_items + FK + UNIQUE + índice vencimiento
  SELECT COUNT(*) INTO v_exists
  FROM information_schema.columns
  WHERE table_schema = DATABASE()
    AND table_name='lotes'
    AND column_name='id_item';
  IF v_exists = 0 THEN
    SET @sql = 'ALTER TABLE lotes ADD COLUMN id_item INT NULL';
    PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
    SELECT COUNT(*) INTO v_has_lotes_items
    FROM information_schema.tables
    WHERE table_schema = DATABASE()
      AND table_name='lotes_items';
    IF v_has_lotes_items > 0 THEN
      SET @sql = 'UPDATE lotes l JOIN lotes_items li ON li.id_lote = l.id_lote SET l.id_item = li.id_item WHERE l.id_item IS NULL';
      PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
    END IF;
    SELECT COUNT(*) INTO v_null_lotes FROM lotes WHERE id_item IS NULL;
    IF v_null_lotes > 0 THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Completar lotes.id_item (usar lotes_items) antes de continuar.';
    END IF;
    SET @sql = 'ALTER TABLE lotes ADD CONSTRAINT fk_lotes_item FOREIGN KEY (id_item) REFERENCES items(id_item)';
    PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
    SET @sql = 'ALTER TABLE lotes MODIFY id_item INT NOT NULL';
    PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
  END IF;
  -- LOTES: UNIQUE (id_item, codigo_lote)
  SELECT COUNT(*) INTO v_exists
  FROM information_schema.statistics
  WHERE table_schema = DATABASE()
    AND table_name='lotes'
    AND index_name='ux_lote_item';
  IF v_exists = 0 THEN
    SET @sql = 'ALTER TABLE lotes ADD UNIQUE KEY ux_lote_item (id_item, codigo_lote)';
    PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
  END IF;
  -- LOTES: índice por vencimiento
  SELECT COUNT(*) INTO v_exists
  FROM information_schema.statistics
  WHERE table_schema = DATABASE()
    AND table_name='lotes'
    AND index_name='ix_lotes_venc';
  IF v_exists = 0 THEN
    SET @sql = 'ALTER TABLE lotes ADD INDEX ix_lotes_venc (fecha_vencimiento)';
    PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
  END IF;
END$$
DELIMITER ;
-- Ejecuta la migración
CALL sp_upgrade_schema();
DROP PROCEDURE IF EXISTS sp_upgrade_schema;
-- =============================================================
-- 3) Tablas de soporte + función de auditoría + movimientos_v2
-- =============================================================
CREATE TABLE IF NOT EXISTS existencias (
  id_existencia BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_lote INT NOT NULL,
  id_ubicacion INT NOT NULL,
  saldo INT NOT NULL DEFAULT 0,
  UNIQUE KEY ux_lote_ubicacion (id_lote, id_ubicacion),
  CONSTRAINT fk_ex_lote FOREIGN KEY (id_lote) REFERENCES lotes(id_lote),
  CONSTRAINT fk_ex_ubi FOREIGN KEY (id_ubicacion) REFERENCES ubicaciones(id_ubicacion)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS parametros_sistema (
  clave VARCHAR(50) PRIMARY KEY,
  valor VARCHAR(100) NOT NULL,
  descripcion VARCHAR(255)
) ENGINE=InnoDB;
INSERT INTO parametros_sistema (clave, valor, descripcion)
VALUES ('dias_alerta_venc', '30', 'Días para alerta de vencimiento'),
       ('umbral_stock_bajo_default', '0', 'Umbral por defecto')
ON DUPLICATE KEY UPDATE valor = VALUES(valor), descripcion = VALUES(descripcion);
CREATE TABLE IF NOT EXISTS auditoria (
  id_evento BIGINT AUTO_INCREMENT PRIMARY KEY,
  tabla_afectada VARCHAR(100) NOT NULL,
  pk_afectada VARCHAR(100) NOT NULL,
  accion ENUM('INSERT','UPDATE','DELETE') NOT NULL,
  valores_antes JSON NULL,
  valores_despues JSON NULL,
  id_usuario INT NULL,
  fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  hash_anterior CHAR(64) NULL,
  hash_evento CHAR(64) NOT NULL,
  INDEX ix_aud_tabla_fecha (tabla_afectada, fecha),
  CONSTRAINT fk_aud_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
) ENGINE=InnoDB;
DROP FUNCTION IF EXISTS fn_ultimo_hash;
DELIMITER $$
CREATE FUNCTION fn_ultimo_hash()
RETURNS CHAR(64)
DETERMINISTIC
BEGIN
  DECLARE h CHAR(64);
  SELECT hash_evento INTO h FROM auditoria ORDER BY id_evento DESC LIMIT 1;
  RETURN COALESCE(h, REPEAT('0',64));
END$$
DELIMITER ;
CREATE TABLE IF NOT EXISTS movimientos_v2 (
  id_movimiento BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_lote INT NOT NULL,
  id_usuario INT NOT NULL,
  tipo ENUM('INGRESO','SALIDA','TRANSFERENCIA','AJUSTE') NOT NULL,
  cantidad INT NOT NULL,
  id_ubicacion_origen INT NULL,
  id_ubicacion_destino INT NULL,
  motivo VARCHAR(255) NULL,
  fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_mv2_lote FOREIGN KEY (id_lote) REFERENCES lotes(id_lote),
  CONSTRAINT fk_mv2_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
  CONSTRAINT fk_mv2_ori FOREIGN KEY (id_ubicacion_origen) REFERENCES ubicaciones(id_ubicacion),
  CONSTRAINT fk_mv2_des FOREIGN KEY (id_ubicacion_destino) REFERENCES ubicaciones(id_ubicacion)
) ENGINE=InnoDB;
-- Índice condicional (evita CREATE INDEX IF NOT EXISTS para compatibilidad)
SET @idx_exists := (
  SELECT COUNT(*) FROM information_schema.statistics
  WHERE table_schema = DATABASE() AND table_name='movimientos_v2' AND index_name='ix_mv2_lote_fecha'
);
SET @sql := IF(@idx_exists = 0,
               'CREATE INDEX ix_mv2_lote_fecha ON movimientos_v2 (id_lote, fecha)',
               'DO 0');
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;
-- =============================================================
-- 4) Triggers: auditoría e inventario inmutable
-- =============================================================
DELIMITER $$
DROP TRIGGER IF EXISTS trg_items_ai; $$
CREATE TRIGGER trg_items_ai
AFTER INSERT ON items FOR EACH ROW
BEGIN
  INSERT INTO auditoria(tabla_afectada, pk_afectada, accion, valores_antes, valores_despues, id_usuario, hash_anterior, hash_evento)
  SELECT 'items', NEW.id_item, 'INSERT', NULL,
         JSON_OBJECT('id_item', NEW.id_item, 'codigo', NEW.codigo, 'descripcion', NEW.descripcion,
                     'unidad_medida', NEW.unidad_medida, 'tipo_item', NEW.tipo_item, 'stock_minimo', NEW.stock_minimo),
         NULL,
         fn_ultimo_hash(),
         SHA2(CONCAT('items', NEW.id_item, 'INSERT',
                     JSON_OBJECT('id_item', NEW.id_item, 'codigo', NEW.codigo, 'descripcion', NEW.descripcion,
                                 'unidad_medida', NEW.unidad_medida, 'tipo_item', NEW.tipo_item, 'stock_minimo', NEW.stock_minimo),
                     fn_ultimo_hash()), 256);
END$$
DROP TRIGGER IF EXISTS trg_items_au; $$
CREATE TRIGGER trg_items_au
AFTER UPDATE ON items FOR EACH ROW
BEGIN
  INSERT INTO auditoria(tabla_afectada, pk_afectada, accion, valores_antes, valores_despues, id_usuario, hash_anterior, hash_evento)
  SELECT 'items', NEW.id_item, 'UPDATE',
         JSON_OBJECT('id_item', OLD.id_item, 'codigo', OLD.codigo, 'descripcion', OLD.descripcion,
                     'unidad_medida', OLD.unidad_medida, 'tipo_item', OLD.tipo_item, 'stock_minimo', OLD.stock_minimo),
         JSON_OBJECT('id_item', NEW.id_item, 'codigo', NEW.codigo, 'descripcion', NEW.descripcion,
                     'unidad_medida', NEW.unidad_medida, 'tipo_item', NEW.tipo_item, 'stock_minimo', NEW.stock_minimo),
         NULL,
         fn_ultimo_hash(),
         SHA2(CONCAT('items', NEW.id_item, 'UPDATE',
                     JSON_OBJECT('antes', JSON_OBJECT('codigo', OLD.codigo,'descripcion', OLD.descripcion),
                                 'despues', JSON_OBJECT('codigo', NEW.codigo,'descripcion', NEW.descripcion)),
                     fn_ultimo_hash()), 256);
END$$

DROP TRIGGER IF EXISTS trg_items_ad; $$
CREATE TRIGGER trg_items_ad
AFTER DELETE ON items FOR EACH ROW
BEGIN
  INSERT INTO auditoria(tabla_afectada, pk_afectada, accion, valores_antes, valores_despues, id_usuario, hash_anterior, hash_evento)
  SELECT 'items', OLD.id_item, 'DELETE',
         JSON_OBJECT('id_item', OLD.id_item, 'codigo', OLD.codigo, 'descripcion', OLD.descripcion,
                     'unidad_medida', OLD.unidad_medida, 'tipo_item', OLD.tipo_item, 'stock_minimo', OLD.stock_minimo),
         NULL, NULL,
         fn_ultimo_hash(),
         SHA2(CONCAT('items', OLD.id_item, 'DELETE',
                     JSON_OBJECT('id_item', OLD.id_item, 'codigo', OLD.codigo),
                     fn_ultimo_hash()), 256);
END$$

DROP TRIGGER IF EXISTS trg_lotes_ai; $$
CREATE TRIGGER trg_lotes_ai
AFTER INSERT ON lotes FOR EACH ROW
BEGIN
  INSERT INTO auditoria(tabla_afectada, pk_afectada, accion, valores_antes, valores_despues, id_usuario, hash_anterior, hash_evento)
  SELECT 'lotes', NEW.id_lote, 'INSERT', NULL,
         JSON_OBJECT('id_lote', NEW.id_lote, 'id_item', NEW.id_item, 'codigo_lote', NEW.codigo_lote,
                     'vencimiento', NEW.fecha_vencimiento, 'costo_u', NEW.costo_unitario),
         NULL, fn_ultimo_hash(),
         SHA2(CONCAT('lotes', NEW.id_lote, 'INSERT',
                     JSON_OBJECT('id_item', NEW.id_item, 'codigo_lote', NEW.codigo_lote),
                     fn_ultimo_hash()), 256);
END$$

DROP TRIGGER IF EXISTS trg_ubicaciones_ai; $$
CREATE TRIGGER trg_ubicaciones_ai
AFTER INSERT ON ubicaciones FOR EACH ROW
BEGIN
  INSERT INTO auditoria(tabla_afectada, pk_afectada, accion, valores_antes, valores_despues, id_usuario, hash_anterior, hash_evento)
  SELECT 'ubicaciones', NEW.id_ubicacion, 'INSERT', NULL,
         JSON_OBJECT('id_ubicacion', NEW.id_ubicacion, 'nombre', NEW.nombre, 'tipo', NEW.tipo, 'activo', NEW.activo),
         NULL, fn_ultimo_hash(),
         SHA2(CONCAT('ubicaciones', NEW.id_ubicacion, 'INSERT',
                     JSON_OBJECT('nombre', NEW.nombre),
                     fn_ultimo_hash()), 256);
END$$

-- Inmutabilidad y control de existencias en movimientos_v2
DROP TRIGGER IF EXISTS trg_mv2_bu; $$
CREATE TRIGGER trg_mv2_bu
BEFORE UPDATE ON movimientos_v2 FOR EACH ROW
BEGIN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Los movimientos no se pueden actualizar. Use sp_anular_movimiento()';
END$$

DROP TRIGGER IF EXISTS trg_mv2_bd; $$
CREATE TRIGGER trg_mv2_bd
BEFORE DELETE ON movimientos_v2 FOR EACH ROW
BEGIN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Los movimientos no se pueden eliminar. Use sp_anular_movimiento()';
END$$

DROP TRIGGER IF EXISTS trg_mv2_ai; $$
CREATE TRIGGER trg_mv2_ai
AFTER INSERT ON movimientos_v2 FOR EACH ROW
BEGIN
  DECLARE v_saldo INT;

  -- Auditoría del movimiento
  INSERT INTO auditoria(tabla_afectada, pk_afectada, accion, valores_antes, valores_despues, id_usuario, hash_anterior, hash_evento)
  SELECT 'movimientos_v2', NEW.id_movimiento, 'INSERT', NULL,
         JSON_OBJECT('id_mov', NEW.id_movimiento, 'id_lote', NEW.id_lote, 'tipo', NEW.tipo,
                     'cant', NEW.cantidad, 'ori', NEW.id_ubicacion_origen, 'des', NEW.id_ubicacion_destino,
                     'motivo', NEW.motivo, 'fecha', DATE_FORMAT(NEW.fecha, '%Y-%m-%d %H:%i:%s')),
         NEW.id_usuario, fn_ultimo_hash(),
         SHA2(CONCAT('movimientos_v2', NEW.id_movimiento, 'INSERT',
                     JSON_OBJECT('id_lote', NEW.id_lote, 'tipo', NEW.tipo, 'cant', NEW.cantidad),
                     fn_ultimo_hash()), 256);

  -- Reglas de negocio + existencias
  IF NEW.cantidad <= 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cantidad debe ser > 0';
  END IF;

  IF NEW.tipo = 'INGRESO' THEN
    IF NEW.id_ubicacion_destino IS NULL THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INGRESO requiere id_ubicacion_destino';
    END IF;
    INSERT INTO existencias(id_lote, id_ubicacion, saldo)
    VALUES (NEW.id_lote, NEW.id_ubicacion_destino, NEW.cantidad)
    ON DUPLICATE KEY UPDATE saldo = saldo + VALUES(saldo);
  END IF;

  IF NEW.tipo = 'SALIDA' THEN
    IF NEW.id_ubicacion_origen IS NULL THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'SALIDA requiere id_ubicacion_origen';
    END IF;
    SELECT saldo INTO v_saldo
    FROM existencias
    WHERE id_lote = NEW.id_lote AND id_ubicacion = NEW.id_ubicacion_origen
    FOR UPDATE;
    IF v_saldo IS NULL OR v_saldo < NEW.cantidad THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente para SALIDA';
    END IF;
    UPDATE existencias
      SET saldo = saldo - NEW.cantidad
    WHERE id_lote = NEW.id_lote AND id_ubicacion = NEW.id_ubicacion_origen;
  END IF;

  IF NEW.tipo = 'TRANSFERENCIA' THEN
    IF NEW.id_ubicacion_origen IS NULL OR NEW.id_ubicacion_destino IS NULL THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'TRANSFERENCIA requiere origen y destino';
    END IF;
    IF NEW.id_ubicacion_origen = NEW.id_ubicacion_destino THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Origen y destino no pueden ser iguales';
    END IF;
    SELECT saldo INTO v_saldo
    FROM existencias
    WHERE id_lote = NEW.id_lote AND id_ubicacion = NEW.id_ubicacion_origen
    FOR UPDATE;
    IF v_saldo IS NULL OR v_saldo < NEW.cantidad THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente en origen para TRANSFERENCIA';
    END IF;
    UPDATE existencias
      SET saldo = saldo - NEW.cantidad
    WHERE id_lote = NEW.id_lote AND id_ubicacion = NEW.id_ubicacion_origen;

    INSERT INTO existencias(id_lote, id_ubicacion, saldo)
    VALUES (NEW.id_lote, NEW.id_ubicacion_destino, NEW.cantidad)
    ON DUPLICATE KEY UPDATE saldo = saldo + VALUES(saldo);
  END IF;

  IF NEW.tipo = 'AJUSTE' THEN
    IF NEW.motivo IS NULL OR NEW.motivo = '' THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Motivo obligatorio para AJUSTE';
    END IF;
    IF NEW.id_ubicacion_origen IS NOT NULL AND NEW.id_ubicacion_destino IS NOT NULL THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'AJUSTE debe afectar solo una ubicación';
    END IF;
    IF NEW.id_ubicacion_destino IS NOT NULL THEN
      INSERT INTO existencias(id_lote, id_ubicacion, saldo)
      VALUES (NEW.id_lote, NEW.id_ubicacion_destino, NEW.cantidad)
      ON DUPLICATE KEY UPDATE saldo = saldo + VALUES(saldo);
    ELSEIF NEW.id_ubicacion_origen IS NOT NULL THEN
      SELECT saldo INTO v_saldo
      FROM existencias
      WHERE id_lote = NEW.id_lote AND id_ubicacion = NEW.id_ubicacion_origen
      FOR UPDATE;
      IF v_saldo IS NULL OR v_saldo < NEW.cantidad THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente para AJUSTE (disminución)';
      END IF;
      UPDATE existencias
        SET saldo = saldo - NEW.cantidad
      WHERE id_lote = NEW.id_lote AND id_ubicacion = NEW.id_ubicacion_origen;
    ELSE
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'AJUSTE requiere una ubicación (origen o destino)';
    END IF;
  END IF;
END$$
DELIMITER ;

-- =============================================================
-- 5) Procedimientos almacenados (API backend)
-- =============================================================
DROP PROCEDURE IF EXISTS sp_asegurar_lote;
DROP PROCEDURE IF EXISTS sp_registrar_ingreso;
DROP PROCEDURE IF EXISTS sp_registrar_salida;
DROP PROCEDURE IF EXISTS sp_transferir_stock;
DROP PROCEDURE IF EXISTS sp_ajustar_stock;
DROP PROCEDURE IF EXISTS sp_anular_movimiento;
DROP PROCEDURE IF EXISTS sp_recalcular_existencias;

DELIMITER $$
CREATE PROCEDURE sp_asegurar_lote(
  IN p_id_item INT,
  IN p_id_proveedor INT,
  IN p_codigo_lote VARCHAR(50),
  IN p_fecha_venc DATE,
  IN p_costo_unitario DECIMAL(10,2),
  OUT p_id_lote INT
)
BEGIN
  IF p_fecha_venc < CURRENT_DATE() THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Fecha de vencimiento inválida (pasada)';
  END IF;
  SELECT id_lote INTO p_id_lote
  FROM lotes
  WHERE id_item = p_id_item AND codigo_lote = p_codigo_lote
  LIMIT 1;
  IF p_id_lote IS NULL THEN
    INSERT INTO lotes(id_item, id_proveedor, codigo_lote, fecha_vencimiento, costo_unitario)
    VALUES (p_id_item, p_id_proveedor, p_codigo_lote, p_fecha_venc, p_costo_unitario);
    SET p_id_lote = LAST_INSERT_ID();
  END IF;
END$$

CREATE PROCEDURE sp_registrar_ingreso(
  IN p_id_item INT,
  IN p_id_proveedor INT,
  IN p_codigo_lote VARCHAR(50),
  IN p_fecha_venc DATE,
  IN p_costo_unitario DECIMAL(10,2),
  IN p_id_ubicacion_destino INT,
  IN p_cantidad INT,
  IN p_id_usuario INT,
  IN p_motivo VARCHAR(255)
)
BEGIN
  DECLARE v_id_lote INT;
  IF p_cantidad <= 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cantidad debe ser > 0'; END IF;
  START TRANSACTION;
    CALL sp_asegurar_lote(p_id_item, p_id_proveedor, p_codigo_lote, p_fecha_venc, p_costo_unitario, v_id_lote);
    INSERT INTO movimientos_v2(id_lote, id_usuario, tipo, cantidad, id_ubicacion_destino, motivo)
    VALUES (v_id_lote, p_id_usuario, 'INGRESO', p_cantidad, p_id_ubicacion_destino, COALESCE(p_motivo,'Recepción de proveedor'));
  COMMIT;
END$$



CREATE PROCEDURE sp_transferir_stock(
  IN p_id_lote INT,
  IN p_id_ubicacion_origen INT,
  IN p_id_ubicacion_destino INT,
  IN p_cantidad INT,
  IN p_id_usuario INT,
  IN p_motivo VARCHAR(255)
)
BEGIN
  IF p_cantidad <= 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cantidad debe ser > 0'; END IF;
  IF p_id_ubicacion_origen = p_id_ubicacion_destino THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Origen y Destino no pueden ser iguales';
  END IF;
  START TRANSACTION;
    INSERT INTO movimientos_v2(id_lote, id_usuario, tipo, cantidad, id_ubicacion_origen, id_ubicacion_destino, motivo)
    VALUES (p_id_lote, p_id_usuario, 'TRANSFERENCIA', p_cantidad, p_id_ubicacion_origen, p_id_ubicacion_destino, COALESCE(p_motivo,'Reabastecimiento'));
  COMMIT;
END$$

-- NOTA: p_sentido VARCHAR para máxima compatibilidad (evita ENUM en parámetros)
CREATE PROCEDURE sp_ajustar_stock(
  IN p_id_lote INT,
  IN p_id_ubicacion INT,
  IN p_cantidad INT,
  IN p_sentido VARCHAR(12),
  IN p_id_usuario INT,
  IN p_motivo VARCHAR(255)
)
BEGIN
  SET p_sentido = UPPER(TRIM(p_sentido));
  IF p_cantidad <= 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cantidad debe ser > 0'; END IF;
  IF p_motivo IS NULL OR p_motivo = '' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Motivo es obligatorio en AJUSTE'; END IF;
  IF p_sentido NOT IN ('AUMENTO','DISMINUCION') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'p_sentido debe ser AUMENTO o DISMINUCION'; END IF;
  START TRANSACTION;
    IF p_sentido = 'AUMENTO' THEN
      INSERT INTO movimientos_v2(id_lote, id_usuario, tipo, cantidad, id_ubicacion_destino, motivo)
      VALUES (p_id_lote, p_id_usuario, 'AJUSTE', p_cantidad, p_id_ubicacion, p_motivo);
    ELSE
      INSERT INTO movimientos_v2(id_lote, id_usuario, tipo, cantidad, id_ubicacion_origen, motivo)
      VALUES (p_id_lote, p_id_usuario, 'AJUSTE', p_cantidad, p_id_ubicacion, p_motivo);
    END IF;
  COMMIT;
END$$

CREATE PROCEDURE sp_anular_movimiento(
  IN p_id_movimiento BIGINT,
  IN p_id_usuario INT,
  IN p_motivo VARCHAR(255)
)
BEGIN
  DECLARE v_tipo VARCHAR(15);
  DECLARE v_id_lote INT;
  DECLARE v_ori INT;
  DECLARE v_des INT;
  DECLARE v_cant INT;

  IF p_motivo IS NULL OR p_motivo = '' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Motivo obligatorio para anulación'; END IF;

  SELECT tipo, id_lote, id_ubicacion_origen, id_ubicacion_destino, cantidad
    INTO v_tipo, v_id_lote, v_ori, v_des, v_cant
  FROM movimientos_v2 WHERE id_movimiento = p_id_movimiento;

  IF v_tipo IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Movimiento no existe'; END IF;

  START TRANSACTION;
    CASE v_tipo
      WHEN 'INGRESO' THEN
        INSERT INTO movimientos_v2(id_lote, id_usuario, tipo, cantidad, id_ubicacion_origen, motivo)
        VALUES (v_id_lote, p_id_usuario, 'AJUSTE', v_cant, v_des, CONCAT('Anulación mov ', p_id_movimiento, ': ', p_motivo));
      WHEN 'SALIDA' THEN
        INSERT INTO movimientos_v2(id_lote, id_usuario, tipo, cantidad, id_ubicacion_destino, motivo)
        VALUES (v_id_lote, p_id_usuario, 'AJUSTE', v_cant, v_ori, CONCAT('Anulación mov ', p_id_movimiento, ': ', p_motivo));
      WHEN 'TRANSFERENCIA' THEN
        INSERT INTO movimientos_v2(id_lote, id_usuario, tipo, cantidad, id_ubicacion_origen, id_ubicacion_destino, motivo)
        VALUES (v_id_lote, p_id_usuario, 'TRANSFERENCIA', v_cant, v_des, v_ori, CONCAT('Anulación mov ', p_id_movimiento, ': ', p_motivo));
      WHEN 'AJUSTE' THEN
        IF v_ori IS NOT NULL THEN
          INSERT INTO movimientos_v2(id_lote, id_usuario, tipo, cantidad, id_ubicacion_destino, motivo)
          VALUES (v_id_lote, p_id_usuario, 'AJUSTE', v_cant, v_ori, CONCAT('Reversa ajuste mov ', p_id_movimiento, ': ', p_motivo));
        ELSE
          INSERT INTO movimientos_v2(id_lote, id_usuario, tipo, cantidad, id_ubicacion_origen, motivo)
          VALUES (v_id_lote, p_id_usuario, 'AJUSTE', v_cant, v_des, CONCAT('Reversa ajuste mov ', p_id_movimiento, ': ', p_motivo));
        END IF;
    END CASE;
  COMMIT;
END$$

-- Rebuild de existencias desde movimientos_v2
CREATE PROCEDURE sp_recalcular_existencias()
BEGIN
  START TRANSACTION;
    TRUNCATE TABLE existencias;
    INSERT INTO existencias (id_lote, id_ubicacion, saldo)
    SELECT id_lote, id_ubicacion, SUM(delta) AS saldo
    FROM (
      SELECT
        mv.id_lote,
        CASE
          WHEN mv.tipo IN ('INGRESO','TRANSFERENCIA') AND mv.id_ubicacion_destino IS NOT NULL THEN mv.id_ubicacion_destino
          WHEN mv.tipo IN ('SALIDA','TRANSFERENCIA','AJUSTE') AND mv.id_ubicacion_origen IS NOT NULL THEN mv.id_ubicacion_origen
          ELSE NULL
        END AS id_ubicacion,
        CASE
          WHEN mv.tipo IN ('INGRESO','TRANSFERENCIA') AND mv.id_ubicacion_destino IS NOT NULL THEN mv.cantidad
          WHEN mv.tipo IN ('SALIDA','TRANSFERENCIA','AJUSTE') AND mv.id_ubicacion_origen IS NOT NULL THEN -mv.cantidad
          ELSE 0
        END AS delta
      FROM movimientos_v2 mv
    ) t
    WHERE id_ubicacion IS NOT NULL
    GROUP BY id_lote, id_ubicacion
    HAVING SUM(delta) <> 0;
  COMMIT;
END$$
DELIMITER ;

-- =============================================================
-- 6) Vistas (Kardex, existencias, alertas)
-- =============================================================
CREATE OR REPLACE VIEW v_existencias_detalle AS
SELECT
  e.id_lote,
  l.id_item,
  i.codigo AS codigo_item,
  i.descripcion AS item,
  i.unidad_medida,
  u.id_ubicacion,
  u.nombre AS ubicacion,
  e.saldo
FROM existencias e
JOIN lotes l     ON l.id_lote = e.id_lote
JOIN items i     ON i.id_item = l.id_item
JOIN ubicaciones u ON u.id_ubicacion = e.id_ubicacion;

CREATE OR REPLACE VIEW v_kardex AS
SELECT
  mv.id_movimiento,
  mv.fecha,
  mv.id_lote,
  l.id_item,
  mv.tipo,
  COALESCE(mv.id_ubicacion_origen, mv.id_ubicacion_destino) AS id_ubicacion,
  CASE
    WHEN mv.tipo IN ('INGRESO','TRANSFERENCIA') AND mv.id_ubicacion_destino IS NOT NULL THEN mv.cantidad
    WHEN mv.tipo IN ('SALIDA','TRANSFERENCIA','AJUSTE') AND mv.id_ubicacion_origen IS NOT NULL THEN -mv.cantidad
    ELSE 0
  END AS delta,
  mv.id_usuario,
  mv.motivo
FROM movimientos_v2 mv
JOIN lotes l ON l.id_lote = mv.id_lote;

-- Nota: requiere MySQL 8.0+ por funciones de ventana
CREATE OR REPLACE VIEW v_kardex_con_saldo AS
SELECT
  k.*,
  SUM(k.delta) OVER (PARTITION BY k.id_lote, k.id_ubicacion ORDER BY k.fecha, k.id_movimiento) AS saldo_acum
FROM v_kardex k;

CREATE OR REPLACE VIEW v_alertas_vencimiento AS
SELECT
  l.id_lote, l.id_item, i.codigo, i.descripcion, l.fecha_vencimiento,
  DATEDIFF(l.fecha_vencimiento, CURRENT_DATE()) AS dias_para_vencer
FROM lotes l
JOIN items i ON i.id_item = l.id_item
WHERE DATEDIFF(l.fecha_vencimiento, CURRENT_DATE()) BETWEEN 0 AND
      (SELECT CAST(valor AS SIGNED) FROM parametros_sistema WHERE clave='dias_alerta_venc');

CREATE OR REPLACE VIEW v_alertas_stock_bajo AS
SELECT
  e.id_lote, l.id_item, i.codigo, i.descripcion,
  e.id_ubicacion, u.nombre AS ubicacion, e.saldo, i.stock_minimo
FROM existencias e
JOIN lotes l ON l.id_lote = e.id_lote
JOIN items i ON i.id_item = l.id_item
JOIN ubicaciones u ON u.id_ubicacion = e.id_ubicacion
WHERE e.saldo < i.stock_minimo;

CREATE DATABASE IF NOT EXISTS farmagestion CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE farmagestion;
SET sql_safe_updates = 0;
SET FOREIGN_KEY_CHECKS = 1;

/* =============================================================
   1) RF-02: SALIDA con DESTINO (trazabilidad de servicio)
      - Reemplaza sp_registrar_salida para exigir p_id_ubicacion_destino
      - No cambia la lógica de existencias (la salida descuenta SOLO del origen)
   ============================================================= */
DROP PROCEDURE IF EXISTS sp_registrar_salida;
DELIMITER $$
CREATE PROCEDURE sp_registrar_salida(
  IN p_id_lote INT,
  IN p_id_ubicacion_origen INT,
  IN p_id_ubicacion_destino INT,     -- NUEVO: servicio destino (trazabilidad)
  IN p_cantidad INT,
  IN p_id_usuario INT,
  IN p_motivo VARCHAR(255)
)
BEGIN
  IF p_cantidad <= 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cantidad debe ser > 0';
  END IF;

  IF p_motivo IS NULL OR p_motivo = '' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Motivo es obligatorio en SALIDA';
  END IF;

  IF p_id_ubicacion_destino IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'SALIDA requiere id_ubicacion_destino (servicio)';
  END IF;

  -- Opcional: validar que la ubicación destino exista
  IF (SELECT COUNT(*) FROM ubicaciones WHERE id_ubicacion = p_id_ubicacion_destino) = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ubicación destino no existe';
  END IF;

  START TRANSACTION;
    INSERT INTO movimientos_v2
      (id_lote, id_usuario, tipo, cantidad, id_ubicacion_origen, id_ubicacion_destino, motivo)
    VALUES
      (p_id_lote, p_id_usuario, 'SALIDA', p_cantidad, p_id_ubicacion_origen, p_id_ubicacion_destino, p_motivo);
  COMMIT;
END$$
DELIMITER ;
/* =============================================================
   2) RF-10: Vista de Consumos por Servicio
      - Agrega vista para reportar consumos acumulados por servicio
   ============================================================= */
CREATE OR REPLACE VIEW v_consumos_por_servicio AS
SELECT
  mv.id_ubicacion_destino     AS id_servicio,
  u.nombre                    AS servicio,
  l.id_item,
  i.codigo,
  i.descripcion               AS item,
  SUM(mv.cantidad)            AS consumo_total,
  MIN(mv.fecha)               AS desde,
  MAX(mv.fecha)               AS hasta
FROM movimientos_v2 mv
JOIN lotes       l ON l.id_lote  = mv.id_lote
JOIN items       i ON i.id_item  = l.id_item
JOIN ubicaciones u ON u.id_ubicacion = mv.id_ubicacion_destino
WHERE mv.tipo = 'SALIDA' AND mv.id_ubicacion_destino IS NOT NULL
GROUP BY mv.id_ubicacion_destino, u.nombre, l.id_item, i.codigo, i.descripcion;
/* =============================================================
   3) RF-09: Importación CSV (staging + procedimiento)
      - Staging para cargar CSV vía backend
      - SP que valida y usa sp_registrar_ingreso (respeta reglas/ auditoría)
   ============================================================= */
DROP PROCEDURE IF EXISTS sp_importar_inventario_inicial;
DELIMITER $$
CREATE PROCEDURE sp_importar_inventario_inicial(IN p_id_usuario INT)
BEGIN
  DECLARE done TINYINT DEFAULT 0;
  -- Campos leídos del staging
  DECLARE v_codigo_item   VARCHAR(50);
  DECLARE v_nit           VARCHAR(50);
  DECLARE v_codigo_lote   VARCHAR(50);
  DECLARE v_venc          DATE;
  DECLARE v_costo         DECIMAL(10,2);
  DECLARE v_ubic          VARCHAR(100);
  DECLARE v_cant          INT;
  -- IDs resueltos (variables locales)
  DECLARE v_id_item INT;
  DECLARE v_id_prov INT;
  DECLARE v_id_ubi  INT;
  -- Mensaje para SIGNAL (evita CONCAT directo)
  DECLARE v_msg VARCHAR(255);
  -- Cursor sobre staging
  DECLARE cur CURSOR FOR
    SELECT codigo_item, nit_proveedor, codigo_lote, fecha_vencimiento, costo_unitario, nombre_ubicacion, cantidad
    FROM stg_inventario_inicial;
  -- Handler de fin de cursor (SOLO para FETCH)
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
  OPEN cur;
  read_loop: LOOP
    FETCH cur
      INTO v_codigo_item, v_nit, v_codigo_lote, v_venc, v_costo, v_ubic, v_cant;
    IF done = 1 THEN
      LEAVE read_loop;
    END IF;

    -- Validaciones
    IF v_venc < CURRENT_DATE() THEN
      SET v_msg = CONCAT('Fila inválida (lote vencido): ', v_codigo_lote);
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_msg;
    END IF;

    -- Resolver IDs sin disparar NOT FOUND del handler (subconsultas)
    SET v_id_item = (SELECT id_item      FROM items       WHERE codigo = v_codigo_item  LIMIT 1);
    IF v_id_item IS NULL THEN
      SET v_msg = CONCAT('Ítem no existe: ', v_codigo_item);
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_msg;
    END IF;

    SET v_id_prov = (SELECT id_proveedor FROM proveedores WHERE nit    = v_nit          LIMIT 1);
    IF v_id_prov IS NULL THEN
      SET v_msg = CONCAT('Proveedor no existe (NIT): ', v_nit);
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_msg;
    END IF;

    SET v_id_ubi  = (SELECT id_ubicacion FROM ubicaciones WHERE nombre = v_ubic         LIMIT 1);
    IF v_id_ubi IS NULL THEN
      SET v_msg = CONCAT('Ubicación no existe: ', v_ubic);
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_msg;
    END IF;

    -- Inserta usando la API de negocio (respeta reglas, auditoría y existencias)
    CALL sp_registrar_ingreso(
      v_id_item, v_id_prov, v_codigo_lote, v_venc, v_costo,
      v_id_ubi, v_cant, p_id_usuario, 'Carga inicial CSV'
    );
  END LOOP;

  CLOSE cur;
END$$

DELIMITER ;

/* =============================================================
   4) RNF-09: Auditoría inalterable + verificación de cadena
      - Triggers que bloquean UPDATE/DELETE en tabla auditoria
      - SP de verificación de integridad del encadenamiento de hash
   ============================================================= */
DROP TRIGGER IF EXISTS trg_auditoria_bu;
DROP TRIGGER IF EXISTS trg_auditoria_bd;
DELIMITER $$
CREATE TRIGGER trg_auditoria_bu BEFORE UPDATE ON auditoria
FOR EACH ROW
BEGIN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tabla de auditoría es inmutable (UPDATE prohibido)';
END$$
CREATE TRIGGER trg_auditoria_bd BEFORE DELETE ON auditoria
FOR EACH ROW
BEGIN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tabla de auditoría es inmutable (DELETE prohibido)';
END$$
DELIMITER ;

-- Verificación de integridad del hash encadenado
DROP PROCEDURE IF EXISTS sp_verificar_auditoria_integridad;
DELIMITER $$

CREATE PROCEDURE sp_verificar_auditoria_integridad()
BEGIN
  /*
    Recorre en orden y compara hash_anterior con hash_evento previo.
    Devuelve inconsistencias, si las hubiera.
  */
  WITH ordered AS (
    SELECT a.*, ROW_NUMBER() OVER (ORDER BY id_evento) AS rn
    FROM auditoria a
  ),
  prevs AS (
    SELECT
      o1.id_evento,
      o1.tabla_afectada,
      o1.pk_afectada,
      o1.fecha,
      o1.hash_anterior AS esperado,
      COALESCE(o2.hash_evento, REPEAT('0',64)) AS hash_real
    FROM ordered o1
    LEFT JOIN ordered o2 ON o2.rn = o1.rn - 1
  )
  SELECT *
  FROM prevs
  WHERE esperado <> hash_real;
END$$

DELIMITER ;

/* =============================================================
   5) RNF-01/06: Índices de rendimiento (creación condicional)
      - movimientos_v2(id_ubicacion_destino, fecha)
      - existencias(id_ubicacion)
   ============================================================= */
-- ix_mv2_destino_fecha
SET @idx_exists := (
  SELECT COUNT(*) FROM information_schema.statistics
  WHERE table_schema = DATABASE()
    AND table_name = 'movimientos_v2'
    AND index_name = 'ix_mv2_destino_fecha'
);
SET @sql := IF(@idx_exists = 0,
  'CREATE INDEX ix_mv2_destino_fecha ON movimientos_v2 (id_ubicacion_destino, fecha)',
  'DO 0'
);
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;

-- ix_existencias_ubicacion
SET @idx_exists := (
  SELECT COUNT(*) FROM information_schema.statistics
  WHERE table_schema = DATABASE()
    AND table_name = 'existencias'
    AND index_name = 'ix_existencias_ubicacion'
);
SET @sql := IF(@idx_exists = 0,
  'CREATE INDEX ix_existencias_ubicacion ON existencias (id_ubicacion)',
  'DO 0'
);
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;
/* =============================================================
   6) Vistas utilitarias
      - Lotes vencidos (informes operativos)
      - Stock por ítem (suma de existencias), útil para front
   ============================================================= */
CREATE OR REPLACE VIEW v_lotes_vencidos AS
SELECT l.id_lote, l.id_item, i.codigo, i.descripcion, l.fecha_vencimiento
FROM lotes l
JOIN items i ON i.id_item = l.id_item
WHERE DATEDIFF(l.fecha_vencimiento, CURRENT_DATE()) < 0;

CREATE OR REPLACE VIEW v_stock_por_item AS
SELECT
  l.id_item,
  i.codigo,
  i.descripcion,
  i.unidad_medida,
  COALESCE(SUM(e.saldo),0) AS stock_total
FROM items i
LEFT JOIN lotes l      ON l.id_item = i.id_item
LEFT JOIN existencias e ON e.id_lote = l.id_lote
GROUP BY l.id_item, i.codigo, i.descripcion, i.unidad_medida;
/* =============================================================
   7) RNF-03: CHECK de formato bcrypt en usuarios (condicional)
      - Valida que el hash comience por '$2' (bcrypt family)
   ============================================================= */
-- Verifica si ya existe la restricción
SET @chk_exists := (
  SELECT COUNT(*) FROM information_schema.table_constraints
  WHERE table_schema = DATABASE()
    AND table_name = 'usuarios'
    AND constraint_name = 'chk_pwd_bcrypt'
);
SET @sql := IF(@chk_exists = 0,
  'ALTER TABLE usuarios ADD CONSTRAINT chk_pwd_bcrypt CHECK (contrasena LIKE ''$2%'')',
  'DO 0'
);
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;
/* =============================================================
   8) (Opcional) Sanitización mínima de parámetros del sistema
      - Asegura existencia de clave de días de alerta
   ============================================================= */
INSERT INTO parametros_sistema (clave, valor, descripcion)
VALUES ('dias_alerta_venc', '30', 'Días para alerta de vencimiento')
ON DUPLICATE KEY UPDATE valor = VALUES(valor), descripcion = VALUES(descripcion);

DROP TABLE IF EXISTS stg_inventario_inicial;
CREATE TABLE stg_inventario_inicial (
    codigo_item         VARCHAR(50) NOT NULL,
    nit_proveedor       VARCHAR(50) NOT NULL,
    codigo_lote         VARCHAR(50) NOT NULL,
    fecha_vencimiento   DATE NOT NULL,
    costo_unitario      DECIMAL(10,2) NOT NULL,
    nombre_ubicacion    VARCHAR(100) NOT NULL,
    cantidad            INT NOT NULL CHECK (cantidad > 0)
) ENGINE=InnoDB;


SET @idx_exists := (
    SELECT COUNT(*) FROM information_schema.statistics
    WHERE table_schema = DATABASE()
    AND table_name = 'usuarios'
    AND index_name = 'ix_usuarios_correo'
);
SET @sql := IF(@idx_exists = 0,
    'CREATE INDEX ix_usuarios_correo ON usuarios (correo)',
    'DO 0'
);
PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;


CREATE OR REPLACE VIEW v_resumen_auditoria AS
SELECT
    tabla_afectada,
    COUNT(*) AS total_eventos,
    MAX(fecha) AS ultimo_evento,
    MAX(id_evento) AS id_ultimo
FROM auditoria
GROUP BY tabla_afectada;