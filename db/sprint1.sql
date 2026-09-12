-- ============================================================
-- SCRIPT DDL - SPRINT 1 (CIMIENTOS Y AUTENTICACION)
-- ============================================================

CREATE DATABASE IF NOT EXISTS inmobiliaria
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_spanish_ci;

USE inmobiliaria;

-- 1. TABLA: ROL (Solo roles autenticados)
CREATE TABLE rol (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

-- 2. TABLA: USUARIO
CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    correo VARCHAR(100) NOT NULL UNIQUE, -- Restriccion UNIQUE obligatoria
    password_hash VARCHAR(255) NOT NULL, -- Guardara el hash cifrado
    estado BOOLEAN DEFAULT TRUE,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 3. TABLA INTERMEDIA N:M: USUARIO_ROL
CREATE TABLE usuario_rol (
    id_usuario INT NOT NULL,
    id_rol INT NOT NULL,
    fecha_asignacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario, id_rol),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_rol) REFERENCES rol(id_rol) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 4. TABLA 1:1: PERFIL
CREATE TABLE perfil (
    id_perfil INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE, -- Restriccion UNIQUE garantiza relacion 1:1
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    documento VARCHAR(20) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    direccion VARCHAR(150),
    foto_url VARCHAR(255),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- LIMPIEZA: elimina usuarios/perfiles viejos con hash invalido
-- (usuario_rol y perfil caen por ON DELETE CASCADE)
-- ============================================================
DELETE FROM usuario;

-- ============================================================
-- INSERCIONES INICIALES
-- ============================================================

-- Insertar solo los 3 roles del sistema
INSERT INTO rol (id_rol, nombre) VALUES
(1, 'ADMINISTRADOR'),
(2, 'INMOBILIARIA'),
(3, 'CLIENTE')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre);

-- ------------------------------------------------------------
-- Usuario 1: ADMINISTRADOR (admin@inmobiliaria.com / admin123)
-- ------------------------------------------------------------
INSERT INTO usuario (id_usuario, correo, password_hash, estado) VALUES
(1, 'admin@inmobiliaria.com', '$2a$10$QOMno2q8bI1hxnQ.UeByROJwZHHZ9phiNT0Qwt1mRnH.sFIcpvPpe', TRUE);

INSERT INTO usuario_rol (id_usuario, id_rol) VALUES (1, 1);

INSERT INTO perfil (id_usuario, nombres, apellidos, documento, telefono, direccion) VALUES
(1, 'Admin', 'Sistema', '1000000000', '3001234567', 'Calle 10 # 20-30');

-- ------------------------------------------------------------
-- Usuario 2: INMOBILIARIA (inmo@inmobiliaria.com / inmo123)
-- ------------------------------------------------------------
INSERT INTO usuario (id_usuario, correo, password_hash, estado) VALUES
(2, 'inmo@inmobiliaria.com', '$2a$10$SyuRTUKTog5u27zM0U.DcOHEpZPNfNK0oOMnc2SXXoMyfAEcHaJOa', TRUE);

INSERT INTO usuario_rol (id_usuario, id_rol) VALUES (2, 2);

INSERT INTO perfil (id_usuario, nombres, apellidos, documento, telefono, direccion) VALUES
(2, 'Inmobiliaria', 'Demo', '2000000000', '3007654321', 'Carrera 5 # 10-15');

-- ------------------------------------------------------------
-- Usuario 3: CLIENTE (cliente@inmobiliaria.com / cliente123)
-- ------------------------------------------------------------
INSERT INTO usuario (id_usuario, correo, password_hash, estado) VALUES
(3, 'cliente@inmobiliaria.com', '$2a$10$0pjPppOfaxs5JTE61lb2iOq5u17T7NiqHViWtmpYjzhXLanIVjWPe', TRUE);

INSERT INTO usuario_rol (id_usuario, id_rol) VALUES (3, 3);

INSERT INTO perfil (id_usuario, nombres, apellidos, documento, telefono, direccion) VALUES
(3, 'Cliente', 'Demo', '3000000000', '3009876543', 'Avenida 20 # 30-40');
