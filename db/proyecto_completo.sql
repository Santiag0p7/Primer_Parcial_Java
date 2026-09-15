-- ============================================================
-- PROYECTO COMPLETO - JSGE IN-MOBILIARIA
-- Script SQL consolidado (Sprint 1 + Sprint 2 + Sprint 3)
-- Base de datos: inmobiliaria (MySQL / MariaDB)
--
-- Ejecuta TODA la estructura DDL + datos de prueba DML desde cero.
-- Es idempotente: elimina las tablas existentes antes de recrearlas.
--
-- Credenciales de prueba (contrasena en texto plano):
--   admin@inmobiliaria.com       / admin123     -> ADMINISTRADOR
--   inmo@inmobiliaria.com        / inmo123      -> INMOBILIARIA
--   cliente@inmobiliaria.com     / cliente123   -> CLIENTE
-- ============================================================

CREATE DATABASE IF NOT EXISTS inmobiliaria
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_spanish_ci;

USE inmobiliaria;

-- ============================================================
-- 0. LIMPIEZA (orden inverso a las dependencias de FK)
-- ============================================================
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS documento_solicitud;
DROP TABLE IF EXISTS solicitud;
DROP TABLE IF EXISTS favorito;
DROP TABLE IF EXISTS solicitud_visita;
DROP TABLE IF EXISTS propiedad_caracteristica;
DROP TABLE IF EXISTS imagen_propiedad;
DROP TABLE IF EXISTS caracteristica;
DROP TABLE IF EXISTS propiedad;
DROP TABLE IF EXISTS ciudad;
DROP TABLE IF EXISTS tipo_propiedad;
DROP TABLE IF EXISTS usuario_rol;
DROP TABLE IF EXISTS perfil;
DROP TABLE IF EXISTS usuario;
DROP TABLE IF EXISTS rol;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- 1. SEGURIDAD Y USUARIOS (Sprint 1)
-- ============================================================

-- Tabla: ROL
CREATE TABLE rol (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- Tabla: USUARIO
CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    correo VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    estado BOOLEAN DEFAULT TRUE,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Tabla intermedia N:M: USUARIO_ROL
CREATE TABLE usuario_rol (
    id_usuario INT NOT NULL,
    id_rol INT NOT NULL,
    fecha_asignacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario, id_rol),
    CONSTRAINT fk_usuario_rol_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_usuario_rol_rol FOREIGN KEY (id_rol)
        REFERENCES rol(id_rol) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Tabla 1:1: PERFIL
CREATE TABLE perfil (
    id_perfil INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    documento VARCHAR(20) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    direccion VARCHAR(150),
    foto_url VARCHAR(255),
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_perfil_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- 2. CATALOGOS Y PROPIEDADES (Sprint 2)
-- ============================================================

-- Tabla: TIPO_PROPIEDAD
CREATE TABLE tipo_propiedad (
    id_tipo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- Tabla: CIUDAD (con departamento para administracion - Sprint 3)
CREATE TABLE ciudad (
    id_ciudad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL UNIQUE,
    departamento VARCHAR(80)
) ENGINE=InnoDB;

-- Tabla: PROPIEDAD
CREATE TABLE propiedad (
    id_propiedad INT AUTO_INCREMENT PRIMARY KEY,
    matricula_inmobiliaria VARCHAR(50) NOT NULL UNIQUE,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(14,2) NOT NULL,
    habitaciones INT NOT NULL DEFAULT 0,
    banos INT NOT NULL DEFAULT 0,
    area_m2 DECIMAL(10,2) NOT NULL,
    direccion VARCHAR(180),
    estado_logico BOOLEAN DEFAULT TRUE,
    id_inmobiliaria INT NOT NULL,
    id_tipo INT NOT NULL,
    id_ciudad INT NOT NULL,
    fecha_publicacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_propiedad_inmobiliaria FOREIGN KEY (id_inmobiliaria)
        REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_propiedad_tipo FOREIGN KEY (id_tipo)
        REFERENCES tipo_propiedad(id_tipo) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_propiedad_ciudad FOREIGN KEY (id_ciudad)
        REFERENCES ciudad(id_ciudad) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Tabla: IMAGEN_PROPIEDAD (relacion 1:N con propiedad)
CREATE TABLE imagen_propiedad (
    id_imagen INT AUTO_INCREMENT PRIMARY KEY,
    id_propiedad INT NOT NULL,
    url_imagen VARCHAR(500) NOT NULL,
    es_principal BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_imagen_propiedad FOREIGN KEY (id_propiedad)
        REFERENCES propiedad(id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Tabla: CARACTERISTICA (catalogo general reutilizable)
CREATE TABLE caracteristica (
    id_caracteristica INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- Tabla intermedia N:M: PROPIEDAD_CARACTERISTICA
CREATE TABLE propiedad_caracteristica (
    id_propiedad INT NOT NULL,
    id_caracteristica INT NOT NULL,
    PRIMARY KEY (id_propiedad, id_caracteristica),
    CONSTRAINT fk_pc_propiedad FOREIGN KEY (id_propiedad)
        REFERENCES propiedad(id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_pc_caracteristica FOREIGN KEY (id_caracteristica)
        REFERENCES caracteristica(id_caracteristica) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- 3. SOLICITUDES DE VISITA / CITAS (Sprint 3 - Item 1)
-- ============================================================

CREATE TABLE solicitud_visita (
    id_solicitud INT AUTO_INCREMENT PRIMARY KEY,
    id_propiedad INT NOT NULL,
    id_cliente INT NOT NULL,
    fecha_visita DATE NOT NULL,
    hora_visita TIME NOT NULL,
    comentario VARCHAR(500),
    estado VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_solicitud_cliente (id_cliente),
    INDEX idx_solicitud_propiedad (id_propiedad),
    CONSTRAINT fk_solicitud_propiedad FOREIGN KEY (id_propiedad)
        REFERENCES propiedad(id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_solicitud_cliente FOREIGN KEY (id_cliente)
        REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- 4. FAVORITOS (lista de deseos del cliente) - N:M
-- ============================================================

CREATE TABLE favorito (
    id_usuario INT NOT NULL,
    id_propiedad INT NOT NULL,
    fecha_agregado DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario, id_propiedad),
    CONSTRAINT fk_favorito_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_favorito_propiedad FOREIGN KEY (id_propiedad)
        REFERENCES propiedad(id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- 5. SOLICITUDES DE COMPRA / ARRIENDO Y DOCUMENTOS (Sprint 3)
-- ============================================================

-- Tabla: SOLICITUD (tramite de compra o arriendo radicado por el cliente)
CREATE TABLE solicitud (
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
    CONSTRAINT fk_solicitud_propiedad FOREIGN KEY (id_propiedad)
        REFERENCES propiedad(id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_solicitud_cliente FOREIGN KEY (id_cliente)
        REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Tabla: DOCUMENTO_SOLICITUD (documentos radicados, relacion 1:N con solicitud)
CREATE TABLE documento_solicitud (
    id_documento INT AUTO_INCREMENT PRIMARY KEY,
    id_solicitud INT NOT NULL,
    tipo VARCHAR(50),
    nombre VARCHAR(150) NOT NULL,
    url_documento VARCHAR(500) NOT NULL,
    fecha_carga DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_documento_solicitud FOREIGN KEY (id_solicitud)
        REFERENCES solicitud(id_solicitud) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- 6. DATOS DE PRUEBA (DML)
-- ============================================================

-- Roles
INSERT INTO rol (id_rol, nombre) VALUES
(1, 'ADMINISTRADOR'),
(2, 'INMOBILIARIA'),
(3, 'CLIENTE');

-- Usuarios (hash BCrypt)
INSERT INTO usuario (id_usuario, correo, password_hash, estado) VALUES
(1, 'admin@inmobiliaria.com',
    '$2a$10$QOMno2q8bI1hxnQ.UeByROJwZHHZ9phiNT0Qwt1mRnH.sFIcpvPpe', TRUE),
(2, 'inmo@inmobiliaria.com',
    '$2a$10$SyuRTUKTog5u27zM0U.DcOHEpZPNfNK0oOMnc2SXXoMyfAEcHaJOa', TRUE),
(3, 'cliente@inmobiliaria.com',
    '$2a$10$0pjPppOfaxs5JTE61lb2iOq5u17T7NiqHViWtmpYjzhXLanIVjWPe', TRUE);

-- Perfiles
INSERT INTO perfil (id_usuario, nombres, apellidos, documento, telefono, direccion) VALUES
(1, 'Admin', 'Sistema', '1000000000', '3001234567', 'Calle 10 # 20-30'),
(2, 'Inmobiliaria', 'Demo', '2000000000', '3007654321', 'Carrera 5 # 10-15'),
(3, 'Cliente', 'Demo', '3000000000', '3009876543', 'Avenida 20 # 30-40');

-- Asignacion de roles
INSERT INTO usuario_rol (id_usuario, id_rol) VALUES
(1, 1),
(2, 2),
(3, 3);

-- Tipos de propiedad
INSERT INTO tipo_propiedad (id_tipo, nombre) VALUES
(1, 'Casa'),
(2, 'Apartamento'),
(3, 'Local Comercial'),
(4, 'Oficina'),
(5, 'Terreno');

-- Ciudades
INSERT INTO ciudad (id_ciudad, nombre, departamento) VALUES
(1, 'Bucaramanga', 'Santander'),
(2, 'Floridablanca', 'Santander'),
(3, 'Giron', 'Santander'),
(4, 'Piedecuesta', 'Santander');

-- Caracteristicas
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
(10, 'Terraza');

-- Propiedades de prueba (propiedad de la inmobiliaria demo: usuario 2)
INSERT INTO propiedad
    (id_propiedad, matricula_inmobiliaria, titulo, descripcion, precio, habitaciones, banos,
     area_m2, direccion, estado_logico, id_inmobiliaria, id_tipo, id_ciudad) VALUES
(1, 'MAT-DEMO-001', 'Casa campestre en Bucaramanga',
    'Casa amplia con zona verde y piscina.', 450000000.00, 4, 3, 220.50,
    'Calle 10 # 20-30', TRUE, 2, 1, 1),
(2, 'MAT-DEMO-002', 'Apartamento en Floridablanca',
    'Apartamento moderno con balcon y gimnasio.', 280000000.00, 3, 2, 110.00,
    'Carrera 5 # 10-15', TRUE, 2, 2, 2),
(3, 'MAT-DEMO-003', 'Casa en Bucaramanga',
    'Propiedad de demostracion sin imagenes.', 390000000.00, 3, 2, 160.00,
    'Calle 33 # 12-40', TRUE, 2, 1, 1),
(4, 'MAT-DEMO-004', 'Local comercial en Giron',
    'Local comercial de demostracion sin imagenes.', 520000000.00, 0, 1, 95.00,
    'Carrera 7 # 4-11', TRUE, 2, 3, 3);

-- Imagenes (solo las propiedades 1 y 2 tienen galeria)
INSERT INTO imagen_propiedad (id_propiedad, url_imagen, es_principal) VALUES
(1, 'https://images.unsplash.com/photo-1568605114967-8130f3a36994', TRUE),
(2, 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267', TRUE);

-- Asignacion N:M de caracteristicas
INSERT INTO propiedad_caracteristica (id_propiedad, id_caracteristica) VALUES
(1, 1), -- Piscina
(1, 2), -- Parqueadero
(1, 6), -- Zona Verde
(2, 3), -- Ascensor
(2, 4), -- Gimnasio
(2, 5), -- Vigilancia 24/7
(2, 7); -- Balcon

-- Solicitudes de visita (citas)
INSERT INTO solicitud_visita (id_propiedad, id_cliente, fecha_visita, hora_visita, comentario, estado) VALUES
(1, 3, DATE_ADD(CURDATE(), INTERVAL 3 DAY), '10:00:00',
    'Me gustaria conocer la casa en la manana.', 'PENDIENTE'),
(2, 3, DATE_ADD(CURDATE(), INTERVAL 5 DAY), '15:30:00',
    'Disponible para visitar el apartamento.', 'CONFIRMADA');

-- ============================================================
-- 7. VERIFICACION (opcional)
-- ============================================================
-- SELECT COUNT(*) AS propiedades_activas FROM propiedad WHERE estado_logico = TRUE;
-- SELECT COUNT(*) AS solicitudes_pendientes FROM solicitud_visita WHERE estado = 'PENDIENTE';
-- SELECT COUNT(*) AS usuarios FROM usuario;
-- SELECT c.nombre, COUNT(p.id_propiedad) AS total FROM ciudad c
--   LEFT JOIN propiedad p ON c.id_ciudad = p.id_ciudad AND p.estado_logico = TRUE
--   GROUP BY c.id_ciudad, c.nombre ORDER BY total DESC;
