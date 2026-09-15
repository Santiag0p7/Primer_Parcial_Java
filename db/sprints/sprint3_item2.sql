-- ============================================================
-- SCRIPT DDL - SPRINT 3 (ITEM 2: ADMINISTRACION Y PARAMETROS)
-- Base de datos: inmobiliaria
-- Ejecutar DESPUES de sprint1.sql, sprint2.sql y sprint3.sql.
-- ============================================================

USE inmobiliaria;

-- La tabla 'ciudad' pasa a tener departamento para el CRUD de parametros.
ALTER TABLE ciudad
    ADD COLUMN IF NOT EXISTS departamento VARCHAR(80) AFTER nombre;

-- Valor por defecto para las ciudades ya cargadas (todas de Santander)
UPDATE ciudad SET departamento = 'Santander' WHERE departamento IS NULL;

-- Nota: 'tipo_propiedad' (id_tipo, nombre) y 'caracteristica'
-- (id_caracteristica, nombre) ya fueron creadas en sprint2.sql.
