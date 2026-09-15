-- ============================================================
-- RESTRICCION UNIQUE DE HORARIOS DE CITA
-- Evita agendar dos visitas a la misma propiedad en la misma
-- fecha y hora (id_propiedad, fecha_visita, hora_visita).
--
-- Compatible con MySQL (Clever Cloud) y MariaDB.
-- Es idempotente: verifica en information_schema y solo crea el
-- indice si aun no existe.
-- ============================================================

-- Opcion rapida (ejecuta solo esta linea si el indice no existe):
-- ALTER TABLE solicitud_visita
--     ADD UNIQUE INDEX uq_cita_horario (id_propiedad, fecha_visita, hora_visita);

SET @existe := (
    SELECT COUNT(*) FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'solicitud_visita'
      AND INDEX_NAME = 'uq_cita_horario'
);

SET @sql := IF(@existe = 0,
    'ALTER TABLE solicitud_visita ADD UNIQUE INDEX uq_cita_horario (id_propiedad, fecha_visita, hora_visita)',
    'SELECT ''La restriccion uq_cita_horario ya existe'' AS info');

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
