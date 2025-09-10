CREATE DATABASE FarmaGestion; 
USE FarmaGestion;

-- DROP DATABASE FarmaGestion;

CREATE TABLE ubicaciones (
id_ubicacion INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
descripcion VARCHAR (100)
);

CREATE TABLE proveedores (
id_proveedor INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nombre VARCHAR (100) NOT NULL,
NIT INT NOT NULL
);

CREATE TABLE usuarios (
id_usuario INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nombre_completo VARCHAR (100) NOT NULL,
correo VARCHAR (100),
rol VARCHAR (30),
contraseña VARCHAR (255)
);


CREATE TABLE items (
id_item INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
tipo ENUM('medicamento','dispositivo') NOT NULL,
descripcion VARCHAR (100) NOT NULL,
stock_minimo INT NOT NULL,
stock_actual INT NOT NULL,
id_ubicacion INT NOT NULL, 
FOREIGN KEY (id_ubicacion) REFERENCES ubicaciones(id_ubicacion)
);


CREATE TABLE lotes (
id_lote INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
codigo_lote INT NOT NULL,
fecha_vencimiento DATE NOT NULL,
costo_unitario FLOAT NOT NULL,
id_proveedor INT NOT NULL, FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor)
);


CREATE TABLE movimientos (
id_movimientos INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
tipo_movimiento ENUM ('Entrada', 'salida', 'corrección') NOT NULL,
cantidad INT NOT NULL,
origen VARCHAR (100) NOT NULL,
destino VARCHAR (100) NOT NULL,
FECHA DATE NOT NULL,
motivo VARCHAR (100) NOT NULL,
id_item INT NOT NULL, FOREIGN KEY (id_item) REFERENCES items(id_item),
id_usuario INT NOT NULL, FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);


CREATE TABLE lotes_items (
id_lote_item INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
id_item INT NOT NULL, FOREIGN KEY (id_item) REFERENCES items(id_item),
id_lote INT NOT NULL, FOREIGN KEY (id_lote) REFERENCES lotes(id_lote)
);


INSERT INTO ubicaciones (descripcion) VALUES 
('Estante 1'),
('Estante 2'),
('Estante 3'),
('Estante 4'),
('Estante 5'),
('Estante 6'),
('Estante 7'),
('Estante 8'),
('Estante 9'),
('Estante 10');



INSERT INTO proveedores (nombre, NIT) VALUES 
('Proveedor 1', 10000001),
('Proveedor 2', 10000002),
('Proveedor 3', 10000003),
('Proveedor 4', 10000004),
('Proveedor 5', 10000005),
('Proveedor 6', 10000006),
('Proveedor 7', 10000007),
('Proveedor 8', 10000008),
('Proveedor 9', 10000009),
('Proveedor 10', 10000010);



INSERT INTO usuarios (nombre_completo, correo, rol, contraseña) VALUES 
('Usuario 1', 'usuario1@correo.com', 'admin', 'pass1'),
('Usuario 2', 'usuario2@correo.com', 'admin', 'pass2'),
('Usuario 3', 'usuario3@correo.com', 'admin', 'pass3'),
('Usuario 4', 'usuario4@correo.com', 'admin', 'pass4'),
('Usuario 5', 'usuario5@correo.com', 'admin', 'pass5'),
('Usuario 6', 'usuario6@correo.com', 'admin', 'pass6'),
('Usuario 7', 'usuario7@correo.com', 'admin', 'pass7'),
('Usuario 8', 'usuario8@correo.com', 'admin', 'pass8'),
('Usuario 9', 'usuario9@correo.com', 'admin', 'pass9'),
('Usuario 10', 'usuario10@correo.com', 'admin', 'pass10');



INSERT INTO items (tipo, descripcion, stock_minimo, stock_actual, id_ubicacion) VALUES 
('dispositivo', 'Item 1', 5, 505, 4),
('medicamento', 'Item 2', 6, 675, 7),
('dispositivo', 'Item 3', 18, 549, 3),
('medicamento', 'Item 4', 8, 967, 6),
('dispositivo', 'Item 5', 7, 675, 3),
('medicamento', 'Item 6', 15, 198, 4),
('dispositivo', 'Item 7', 9, 987, 1),
('medicamento', 'Item 8', 5, 109, 10),
('dispositivo', 'Item 9', 6, 98, 10),
('medicamento', 'Item 10', 12, 679, 10);



INSERT INTO lotes (codigo_lote, fecha_vencimiento, costo_unitario, id_proveedor) VALUES 
(1001, '2025-12-12', 6.57, 10),
(1002, '2026-05-16', 39.54, 10),
(1003, '2025-12-11', 34.77, 7),
(1004, '2026-06-14', 43.56, 9),
(1005, '2026-06-27', 14.89, 5),
(1006, '2026-07-01', 45.23, 3),
(1007, '2026-07-05', 12.34, 2),
(1008, '2026-07-10', 25.67, 1),
(1009, '2026-07-15', 18.90, 4),
(1010, '2026-07-20', 22.45, 6);



INSERT INTO movimientos (tipo_movimiento, cantidad, origen, destino, FECHA, motivo, id_lote, id_usuario) VALUES 
('Entrada', 23, 'Almacén', 'Farmacia', '2025-06-01', 'Motivo 1', 1, 1),
('salida', 12, 'Almacén', 'Farmacia', '2025-07-15', 'Motivo 2', 2, 2),
('corrección', 5, 'Almacén', 'Farmacia', '2025-08-03', 'Motivo 3', 3, 3),
('Entrada', 30, 'Almacén', 'Farmacia', '2025-06-20', 'Motivo 4', 4, 4),
('salida', 18, 'Almacén', 'Farmacia', '2025-07-10', 'Motivo 5', 5, 5),
('corrección', 7, 'Almacén', 'Farmacia', '2025-08-01', 'Motivo 6', 6, 6),
('Entrada', 40, 'Almacén', 'Farmacia', '2025-06-25', 'Motivo 7', 7, 7),
('salida', 22, 'Almacén', 'Farmacia', '2025-07-05', 'Motivo 8', 8, 8),
('corrección', 10, 'Almacén', 'Farmacia', '2025-08-05', 'Motivo 9', 9, 9),
('Entrada', 35, 'Almacén', 'Farmacia', '2025-06-30', 'Motivo 10', 10, 10);




INSERT INTO lotes_items (id_item, id_lote) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);


-- 1. Ver todos los ítems con su ubicación y stock mínimo

SELECT i.descripcion AS item, i.tipo, u.descripcion AS ubicacion, i.stock_minimo
FROM items i
JOIN ubicaciones u ON i.id_ubicacion = u.id_ubicacion;


-- 2. Ver ítems con stock por debajo del mínimo

-- Si agregas un campo `stock_actual`, podrías usar:
SELECT descripcion, stock_minimo, stock_actual
FROM items
WHERE stock_actual < stock_minimo;


-- 3. Lotes próximos a vencer (en los próximos 30 días)

SELECT codigo_lote, fecha_vencimiento
FROM lotes
WHERE fecha_vencimiento <= CURDATE() + INTERVAL 30 DAY;


-- 4. Lotes ya vencidos

SELECT codigo_lote, fecha_vencimiento
FROM lotes
WHERE fecha_vencimiento < CURDATE();

-- 5. Ver qué ítems están en cada lote

SELECT l.codigo_lote, i.descripcion AS item
FROM lotes_items li
JOIN lotes l ON li.id_lote = l.id_lote
JOIN items i ON li.id_item = i.id_item;


-- 6. Ver lotes por proveedor

SELECT p.nombre AS proveedor, l.codigo_lote, l.fecha_vencimiento
FROM lotes l
JOIN proveedores p ON l.id_proveedor = p.id_proveedor;


-- 7. Ver todos los movimientos con usuario responsable


SELECT m.tipo_movimiento, m.cantidad, m.FECHA, u.nombre_completo
FROM movimientos m
JOIN usuarios u ON m.id_usuario = u.id_usuario;



-- 8. Ver movimientos por tipo (entrada, salida, corrección)


SELECT *
FROM movimientos
WHERE tipo_movimiento = 'Entrada'; -- Cambia por 'salida' o 'corrección'


-- 9. Ver movimientos por fecha específica

SELECT *
FROM movimientos
WHERE FECHA = '2025-07-10'; -- Cambia por la fecha deseada

-- 10. Total de movimientos por tipo

SELECT tipo_movimiento, COUNT(*) AS total
FROM movimientos
GROUP BY tipo_movimiento;


-- 11. Total de ítems por tipo

SELECT tipo, COUNT(*) AS total
FROM items
GROUP BY tipo;

-- 12. Costo total por lote

SELECT codigo_lote, costo_unitario * SUM(m.cantidad) AS costo_total
FROM movimientos m
JOIN lotes l ON m.id_lote = l.id_lote
GROUP BY l.codigo_lote, l.costo_unitario;


-- 13. Ver todos los usuarios y sus roles

SELECT nombre_completo, correo, rol
FROM usuarios;

-- 14. Ver movimientos realizados por un usuario específico

SELECT m.*
FROM movimientos m
JOIN usuarios u ON m.id_usuario = u.id_usuario
WHERE u.nombre_completo = 'Usuario 5'; -- Cambia por el nombre deseado









