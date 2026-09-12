-- ============================================================
-- SCRIPT DDL - SPRINT 2 (CRUD DE PROPIEDADES)
-- Base de datos: inmobiliaria
-- ============================================================

USE inmobiliaria;

-- 1. TABLA: TIPO_PROPIEDAD (catalogo)
CREATE TABLE IF NOT EXISTS tipo_propiedad (
    id_tipo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

-- 2. TABLA: CIUDAD (catalogo)
CREATE TABLE IF NOT EXISTS ciudad (
    id_ciudad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL UNIQUE
);

-- 3. TABLA: PROPIEDAD
CREATE TABLE IF NOT EXISTS propiedad (
    id_propiedad INT AUTO_INCREMENT PRIMARY KEY,
    matricula_inmobiliaria VARCHAR(50) NOT NULL UNIQUE, -- Restriccion UNIQUE obligatoria
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(14,2) NOT NULL,
    habitaciones INT NOT NULL DEFAULT 0,
    banos INT NOT NULL DEFAULT 0,
    area_m2 DECIMAL(10,2) NOT NULL,
    direccion VARCHAR(180),
    estado_logico BOOLEAN DEFAULT TRUE, -- Baja logica (TRUE=activa, FALSE=eliminada)
    id_inmobiliaria INT NOT NULL,       -- Inmobiliaria (usuario) duena de la publicacion
    id_tipo INT NOT NULL,
    id_ciudad INT NOT NULL,
    fecha_publicacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_inmobiliaria) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_tipo) REFERENCES tipo_propiedad(id_tipo) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_ciudad) REFERENCES ciudad(id_ciudad) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ============================================================
-- INSERCIONES DE CATALOGO
-- ============================================================

INSERT INTO tipo_propiedad (id_tipo, nombre) VALUES
(1, 'Casa'),
(2, 'Apartamento'),
(3, 'Local Comercial'),
(4, 'Oficina'),
(5, 'Terreno')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre);

INSERT INTO ciudad (id_ciudad, nombre) VALUES
(1, 'Bucaramanga'),
(2, 'Floridablanca'),
(3, 'Giron'),
(4, 'Piedecuesta')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre);
