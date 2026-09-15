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

-- ============================================================
-- ITEM 2: GALERIA DE IMAGENES (1:N) Y CARACTERISTICAS (N:M)
-- ============================================================

-- 4. TABLA: IMAGEN_PROPIEDAD (Relacion 1:N con propiedad)
CREATE TABLE IF NOT EXISTS imagen_propiedad (
    id_imagen INT AUTO_INCREMENT PRIMARY KEY,
    id_propiedad INT NOT NULL,
    url_imagen VARCHAR(500) NOT NULL,
    es_principal BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_propiedad) REFERENCES propiedad(id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 5. TABLA: CARACTERISTICA (catalogo general reutilizable)
CREATE TABLE IF NOT EXISTS caracteristica (
    id_caracteristica INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL UNIQUE
);

-- 6. TABLA INTERMEDIA N:M: PROPIEDAD_CARACTERISTICA
CREATE TABLE IF NOT EXISTS propiedad_caracteristica (
    id_propiedad INT NOT NULL,
    id_caracteristica INT NOT NULL,
    PRIMARY KEY (id_propiedad, id_caracteristica),
    FOREIGN KEY (id_propiedad) REFERENCES propiedad(id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_caracteristica) REFERENCES caracteristica(id_caracteristica) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- INSERCIONES DEL CATALOGO DE CARACTERISTICAS
-- ============================================================

INSERT INTO caracteristica (id_caracteristica, nombre) VALUES
(1, 'Piscina'),
(2, 'Parqueadero'),
(3, 'Ascensor'),
(4, 'Gimnasio'),
(5, 'Vigilancia 24/7'),
(6, 'Zona Verde'),
(7, 'Balcon'),
(8, 'Amoblado'),
(9, 'Aire Acondicionado'),
(10, 'Terraza')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre);

-- ============================================================
-- ITEM 4: GESTION DEL PERFIL DE USUARIO (Relacion 1:1)
-- Agrega la marca de tiempo de ultima actualizacion del perfil.
-- (Si la columna ya existe, MariaDB ignora la sentencia)
-- ============================================================

ALTER TABLE perfil
    ADD COLUMN IF NOT EXISTS fecha_actualizacion DATETIME
        DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
