-- ============================================================
-- MODULO DE FAVORITOS (lista de deseos del cliente)
-- Base de datos: inmobiliaria
-- Ejecutar DESPUES de sprint1.sql y sprint2.sql (o del consolidado).
-- Es idempotente: puede ejecutarse varias veces sin duplicar la tabla.
-- ============================================================

USE inmobiliaria;

CREATE TABLE IF NOT EXISTS favorito (
    id_usuario INT NOT NULL,
    id_propiedad INT NOT NULL,
    fecha_agregado DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario, id_propiedad),
    CONSTRAINT fk_favorito_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_favorito_propiedad FOREIGN KEY (id_propiedad)
        REFERENCES propiedad(id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
