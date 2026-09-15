-- ============================================================
-- SCRIPT DDL - SPRINT 3 (ITEM 1: SOLICITUD DE CITAS Y AGENDAMIENTO)
-- Base de datos: inmobiliaria
-- Ejecutar DESPUES de sprint1.sql y sprint2.sql.
-- ============================================================

USE inmobiliaria;

-- TABLA: SOLICITUD_VISITA
-- Registra las solicitudes de cita hechas por un CLIENTE sobre una PROPIEDAD.
-- estado: PENDIENTE | CONFIRMADA | CANCELADA | REALIZADA
CREATE TABLE IF NOT EXISTS solicitud_visita (
    id_solicitud INT AUTO_INCREMENT PRIMARY KEY,
    id_propiedad INT NOT NULL,
    id_cliente INT NOT NULL,
    fecha_visita DATE NOT NULL,
    hora_visita TIME NOT NULL,
    comentario VARCHAR(500),
    estado VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_propiedad) REFERENCES propiedad(id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_cliente) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Indices de apoyo para las consultas por cliente y por inmobiliaria
CREATE INDEX IF NOT EXISTS idx_solicitud_cliente ON solicitud_visita (id_cliente);
CREATE INDEX IF NOT EXISTS idx_solicitud_propiedad ON solicitud_visita (id_propiedad);

-- Restriccion UNIQUE: evita agendar dos visitas a la misma propiedad en el
-- mismo horario (id_propiedad, fecha_visita, hora_visita).
ALTER TABLE solicitud_visita
    ADD UNIQUE INDEX IF NOT EXISTS uq_cita_horario (id_propiedad, fecha_visita, hora_visita);
