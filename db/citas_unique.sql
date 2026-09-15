-- ============================================================
-- RESTRICCION UNIQUE DE HORARIOS DE CITA
-- Evita agendar dos visitas a la misma propiedad en la misma
-- fecha y hora (id_propiedad, fecha_visita, hora_visita).
-- Ejecutar si la tabla solicitud_visita ya existia sin la restriccion.
-- Es idempotente (IF NOT EXISTS).
-- ============================================================

USE inmobiliaria;

ALTER TABLE solicitud_visita
    ADD UNIQUE INDEX IF NOT EXISTS uq_cita_horario (id_propiedad, fecha_visita, hora_visita);
