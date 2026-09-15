-- ============================================================
-- MODULO DE SOLICITUDES DE COMPRA / ARRIENDO Y DOCUMENTOS
-- Base de datos: inmobiliaria
-- Ejecutar DESPUES del esquema inicial (proyecto_completo.sql).
-- Es idempotente (CREATE TABLE IF NOT EXISTS).
-- ============================================================

USE inmobiliaria;

-- Tramite de compra o arriendo radicado por un cliente sobre una propiedad
CREATE TABLE IF NOT EXISTS solicitud (
    id_solicitud INT AUTO_INCREMENT PRIMARY KEY,
    id_propiedad INT NOT NULL,
    id_cliente INT NOT NULL,
    tipo VARCHAR(20) NOT NULL DEFAULT 'COMPRA',      -- COMPRA | ARRIENDO
    monto_oferta DECIMAL(14,2) NULL,
    mensaje VARCHAR(500),
    estado VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE', -- PENDIENTE | EN_REVISION | APROBADA | RECHAZADA | CANCELADA
    observacion VARCHAR(500),
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_solicitud_compra_propiedad FOREIGN KEY (id_propiedad)
        REFERENCES propiedad(id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_solicitud_compra_cliente FOREIGN KEY (id_cliente)
        REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Documentos radicados por el cliente (relacion 1:N con solicitud)
CREATE TABLE IF NOT EXISTS documento_solicitud (
    id_documento INT AUTO_INCREMENT PRIMARY KEY,
    id_solicitud INT NOT NULL,
    tipo VARCHAR(50),
    nombre VARCHAR(150) NOT NULL,
    url_documento VARCHAR(500) NOT NULL,
    fecha_carga DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_documento_solicitud FOREIGN KEY (id_solicitud)
        REFERENCES solicitud(id_solicitud) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
