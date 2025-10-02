-- Seleccionar base
USE farmagestion;

-- ¿Qué tablas y vistas hay?
SHOW FULL TABLES;

-- Conteo rápido por tabla (salud de datos)
SELECT 'proveedores' tabla, COUNT(*) total FROM proveedores UNION ALL
SELECT 'ubicaciones', COUNT(*) FROM ubicaciones UNION ALL
SELECT 'items', COUNT(*) FROM items UNION ALL
SELECT 'lotes', COUNT(*) FROM lotes UNION ALL
SELECT 'existencias', COUNT(*) FROM existencias UNION ALL
SELECT 'movimientos_v2', COUNT(*) FROM movimientos_v2 UNION ALL
SELECT 'auditoria', COUNT(*) FROM auditoria;

-- Índices clave (muestra algunos)
SHOW INDEX FROM lotes;              -- ux_lote_item, ix_lotes_venc
SHOW INDEX FROM items;              -- ux_items_codigo
SHOW INDEX FROM ubicaciones;        -- ux_ubicaciones_nombre
SHOW INDEX FROM movimientos_v2;     -- ix_mv2_lote_fecha, ix_mv2_destino_fecha
SHOW INDEX FROM existencias;        -- ux_lote_ubicacion, ix_existencias_ubicacion

-- Verifica constraint de bcrypt en usuarios (CHECK)
-- Listar proveedores
SELECT id_proveedor, nombre, nit
FROM proveedores
ORDER BY nombre;

-- Buscar proveedor por NIT
SELECT *
FROM proveedores
WHERE nit = '900100001-1';
-- Todas las ubicaciones (incluye tipo/activo si migración corrió)
SELECT id_ubicacion, nombre, 
       COALESCE(tipo,'ALMACEN') AS tipo, 
       COALESCE(activo,1) AS activo
FROM ubicaciones
ORDER BY nombre;

-- Solo servicios activos
SELECT id_ubicacion, nombre
FROM ubicaciones
WHERE COALESCE(tipo,'ALMACEN') = 'SERVICIO' AND COALESCE(activo,1) = 1
ORDER BY nombre;
-- Búsqueda por código (único) o por texto

ALTER TABLE items
  ADD FULLTEXT ft_items_desc (descripcion);

SELECT id_item, codigo, descripcion, tipo_item, unidad_medida, stock_minimo
FROM items
WHERE codigo = 'ITM-000001';

SELECT id_item, codigo, descripcion
FROM items
WHERE MATCH(descripcion) AGAINST('ibuprofeno' IN NATURAL LANGUAGE MODE) -- si habilitas FULLTEXT
   OR descripcion LIKE '%ibuprofeno%';

-- Items con su ubicación "propietaria" definida en la tabla items
SELECT i.id_item, i.codigo, i.descripcion, u.nombre AS ubicacion_asignada
FROM items i
JOIN ubicaciones u ON u.id_ubicacion = i.id_ubicacion;
-- Lotes por ítem
SELECT l.id_lote, l.codigo_lote, l.fecha_vencimiento, l.costo_unitario
FROM lotes l
WHERE l.id_item = 1
ORDER BY l.fecha_vencimiento;

-- Lotes de un ítem ordenados FEFO (primero en vencer)
SELECT l.id_lote, l.codigo_lote, l.fecha_vencimiento
FROM lotes l
WHERE l.id_item = 1
ORDER BY l.fecha_vencimiento ASC;
-- Detalle por lote-ubicación (vista)
SELECT * 
FROM v_existencias_detalle
ORDER BY codigo_item, ubicacion;

-- Stock total por ítem (vista)
SELECT * 
FROM v_stock_por_item
ORDER BY descripcion;

-- Dónde hay un lote específico y cuánto
SELECT e.id_lote, u.nombre AS ubicacion, e.saldo
FROM existencias e
JOIN ubicaciones u ON u.id_ubicacion = e.id_ubicacion
WHERE e.id_lote = 1;

-- Disponibilidad total de un ítem sumando sus lotes
SELECT l.id_item, i.codigo, i.descripcion, SUM(e.saldo) AS stock_total
FROM existencias e
JOIN lotes l ON l.id_lote = e.id_lote
JOIN items i ON i.id_item = l.id_item
WHERE l.id_item = 1
GROUP BY l.id_item, i.codigo, i.descripcion;

-- Parámetros: id_item, id_proveedor, codigo_lote, fecha_venc, costo_u, id_ubic_destino, cantidad, id_usuario, motivo
CALL sp_registrar_ingreso(
  1,          -- id_item
  1,          -- id_proveedor
  'L-0001',   -- codigo_lote
  '2026-01-15',
  0.50,       -- costo_unitario
  1,          -- id_ubicacion_destino (Almacén Central)
  100,        -- cantidad a ingresar
  1,          -- id_usuario (ejemplo)
  'Carga inicial para habilitar salidas'
);

-- Parámetros: id_lote, id_ubic_origen, id_ubic_destino, cantidad, id_usuario, motivo
CALL sp_registrar_salida(
  1,   -- id_lote
  1,   -- origen: Almacén Central
  4,   -- destino: Urgencias (trazabilidad)
  5,   -- cantidad
  2,   -- id_usuario
  'Dispensación a servicio'
);

CALL sp_transferir_stock(
  1,  -- id_lote
  1,  -- origen
  5,  -- destino (UCI)
  10, -- cantidad
  2,  -- id_usuario
  'Reabastecimiento'
);

-- AUMENTO
CALL sp_ajustar_stock(
  1,         -- id_lote
  1,         -- id_ubicacion
  2,         -- cantidad
  'AUMENTO', -- sentido
  3,         -- id_usuario
  'Corrección inventario +2'
);

-- DISMINUCION
CALL sp_ajustar_stock(1, 1, 1, 'DISMINUCION', 3, 'Merma controlada');

-- Invierte el efecto del movimiento indicado, registrando la reversa con motivo
CALL sp_anular_movimiento(15, 4, 'Solicitud del servicio');

-- Últimos movimientos (crudos)
SELECT * 
FROM movimientos_v2
ORDER BY fecha DESC, id_movimiento DESC
LIMIT 50;

-- Kardex (vista base)
SELECT * 
FROM v_kardex
WHERE id_lote = 1
ORDER BY fecha, id_movimiento;

-- Kardex con saldo acumulado
SELECT * 
FROM v_kardex_con_saldo
WHERE id_lote = 1
ORDER BY fecha, id_movimiento;

-- Vencimientos dentro del umbral (parametrizable en parametros_sistema.dias_alerta_venc)
SELECT * 
FROM v_alertas_vencimiento
ORDER BY dias_para_vencer ASC, fecha_vencimiento ASC;

-- Lotes vencidos
SELECT * 
FROM v_lotes_vencidos
ORDER BY fecha_vencimiento ASC;


SELECT *
FROM v_alertas_stock_bajo
ORDER BY ubicacion, descripcion;

-- Acumulado por servicio e ítem (solo movimientos 'SALIDA')
SELECT *
FROM v_consumos_por_servicio
ORDER BY servicio, item;

-- Ejemplo: consumos de un servicio en un rango de fechas
SELECT 
  servicio, codigo, item, SUM(consumo_total) AS consumo_total,
  MIN(desde) AS desde, MAX(hasta) AS hasta
FROM v_consumos_por_servicio
WHERE servicio = 'UCI' 
  AND hasta >= '2025-08-01' AND desde <= '2025-08-31'
GROUP BY servicio, codigo, item;

-- Valorización por lote-ubicación
SELECT 
  i.codigo, i.descripcion, u.nombre AS ubicacion,
  e.id_lote, l.codigo_lote, l.costo_unitario, e.saldo,
  (e.saldo * l.costo_unitario) AS valor
FROM existencias e
JOIN lotes l ON l.id_lote = e.id_lote
JOIN items i ON i.id_item = l.id_item
JOIN ubicaciones u ON u.id_ubicacion = e.id_ubicacion
ORDER BY i.descripcion, u.nombre;

-- Valorización total por ítem
SELECT 
  l.id_item, i.codigo, i.descripcion,
  SUM(e.saldo * l.costo_unitario) AS valor_total
FROM existencias e
JOIN lotes l ON l.id_lote = e.id_lote
JOIN items i ON i.id_item = l.id_item
GROUP BY l.id_item, i.codigo, i.descripcion
ORDER BY valor_total DESC;


-- Últimos eventos de auditoría
SELECT id_evento, tabla_afectada, pk_afectada, accion, fecha, id_usuario
FROM auditoria
ORDER BY id_evento DESC
LIMIT 50;

-- Resumen por tabla
SELECT * FROM v_resumen_auditoria;

-- Validación de integridad de la cadena (hash encadenado)
CALL sp_verificar_auditoria_integridad();  -- devuelve filas si hay inconsistencia

-- Inspeccionar payloads JSON (antes/después)
SELECT 
  id_evento,
  JSON_EXTRACT(valores_antes, '$.descripcion') AS desc_antes,
  JSON_EXTRACT(valores_despues, '$.descripcion') AS desc_despues
FROM auditoria
WHERE tabla_afectada = 'items'
ORDER BY id_evento DESC
LIMIT 10;

-- 1) Cargar staging (ejemplo de 2 filas)
INSERT INTO stg_inventario_inicial
(codigo_item, nit_proveedor, codigo_lote, fecha_vencimiento, costo_unitario, nombre_ubicacion, cantidad)
VALUES
('ITM-000001','900100001-1','CSV-0001','2026-12-31',0.80,'Almacén Central',25),
('ITM-000002','900100002-2','CSV-0002','2026-10-10',1.10,'Urgencias',10);

-- 2) Procesar staging -> genera INGRESO por fila (con validaciones/auditoría)
CALL sp_importar_inventario_inicial(1);  -- id_usuario que ejecuta

-- 3) Verificar existencias después de la importación
SELECT * FROM v_existencias_detalle WHERE codigo_item IN ('ITM-000001','ITM-000002');

-- FEFO: sugerir lotes y cantidades para atender una solicitud de N unidades de un ítem en una ubicación
SELECT e.id_lote, l.codigo_lote, l.fecha_vencimiento, e.saldo
FROM existencias e
JOIN lotes l ON l.id_lote = e.id_lote
WHERE l.id_item = 1
  AND e.id_ubicacion = 1         -- p.ej. Almacén Central
  AND e.saldo > 0
ORDER BY l.fecha_vencimiento ASC, e.saldo DESC
LIMIT 100;

-- Trazabilidad: movimientos que afectaron un lote en un servicio
SELECT mv.*
FROM movimientos_v2 mv
WHERE mv.id_lote = 1 AND (mv.id_ubicacion_origen = 4 OR mv.id_ubicacion_destino = 4) -- Urgencias
ORDER BY mv.fecha;


-- Verifica que existan los índices creados condicionalmente
SELECT table_name, index_name, GROUP_CONCAT(column_name ORDER BY seq_in_index) AS cols
FROM information_schema.statistics
WHERE table_schema = DATABASE()
  AND table_name IN ('movimientos_v2','existencias','items','lotes','ubicaciones')
GROUP BY table_name, index_name
ORDER BY table_name, index_name;

-- Foreign Keys importantes
SELECT table_name, constraint_name, referenced_table_name
FROM information_schema.referential_constraints
WHERE constraint_schema = DATABASE()
  AND referenced_table_name IN ('items','lotes','ubicaciones','usuarios');

-- Mostrar triggers configurados
SHOW TRIGGERS WHERE `Table` IN ('items','lotes','ubicaciones','movimientos_v2','auditoria');

