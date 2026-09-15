-- ============================================================
-- EXPO - SOLO DATOS (NO borra las tablas) - JSGE In-Mobiliaria
--
-- Elimina TODAS las filas (sin borrar tablas) y recarga:
--   * Catalogos, roles y usuarios base (admin, inmo, cliente).
--   * 10 clientes de exposicion (cliente01..cliente10@jsge.com / cliente123).
--   * 19 propiedades (4 demo + 15 expo) con imagenes, caracteristicas y citas.
--
-- Los IDs se reinician y quedan consecutivos (propiedades 1..19,
-- usuarios 1..13). NO elimina las tablas ni su estructura.
-- ============================================================

-- USE btlvt8r2avgfr0mrpr5l;   -- descomenta/ajusta si tu consola lo requiere

-- Tabla de favoritos (por si no existiera; no borra nada existente)
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

-- Tablas de solicitudes de compra/arriendo y documentos (por si no existieran)
CREATE TABLE IF NOT EXISTS solicitud (
    id_solicitud INT AUTO_INCREMENT PRIMARY KEY,
    id_propiedad INT NOT NULL,
    id_cliente INT NOT NULL,
    tipo VARCHAR(20) NOT NULL DEFAULT 'COMPRA',
    monto_oferta DECIMAL(14,2) NULL,
    mensaje VARCHAR(500),
    estado VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    observacion VARCHAR(500),
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_solicitud_compra_propiedad FOREIGN KEY (id_propiedad)
        REFERENCES propiedad(id_propiedad) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_solicitud_compra_cliente FOREIGN KEY (id_cliente)
        REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

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

-- Borra SOLO los datos (mantiene la estructura de las tablas)
SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM documento_solicitud;
DELETE FROM solicitud;
DELETE FROM favorito;
DELETE FROM solicitud_visita;
DELETE FROM propiedad_caracteristica;
DELETE FROM imagen_propiedad;
DELETE FROM caracteristica;
DELETE FROM propiedad;
DELETE FROM ciudad;
DELETE FROM tipo_propiedad;
DELETE FROM usuario_rol;
DELETE FROM perfil;
DELETE FROM usuario;
DELETE FROM rol;
SET FOREIGN_KEY_CHECKS = 1;

-- Reinicia los IDs (autoincremental)
ALTER TABLE usuario AUTO_INCREMENT = 1;
ALTER TABLE perfil AUTO_INCREMENT = 1;
ALTER TABLE propiedad AUTO_INCREMENT = 1;
ALTER TABLE imagen_propiedad AUTO_INCREMENT = 1;
ALTER TABLE solicitud_visita AUTO_INCREMENT = 1;
ALTER TABLE rol AUTO_INCREMENT = 1;
ALTER TABLE tipo_propiedad AUTO_INCREMENT = 1;
ALTER TABLE ciudad AUTO_INCREMENT = 1;
ALTER TABLE caracteristica AUTO_INCREMENT = 1;
ALTER TABLE solicitud AUTO_INCREMENT = 1;
ALTER TABLE documento_solicitud AUTO_INCREMENT = 1;

-- ============================================================
-- DATOS
-- ============================================================

-- 5. DATOS DE PRUEBA (DML)
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
-- 6. VERIFICACION (opcional)
-- ============================================================
-- SELECT COUNT(*) AS propiedades_activas FROM propiedad WHERE estado_logico = TRUE;
-- SELECT COUNT(*) AS solicitudes_pendientes FROM solicitud_visita WHERE estado = 'PENDIENTE';
-- SELECT COUNT(*) AS usuarios FROM usuario;
-- SELECT c.nombre, COUNT(p.id_propiedad) AS total FROM ciudad c
--   LEFT JOIN propiedad p ON c.id_ciudad = p.id_ciudad AND p.estado_logico = TRUE
--   GROUP BY c.id_ciudad, c.nombre ORDER BY total DESC;

-- ============================================================
-- DATOS DE EXPOSICION
-- ============================================================

-- ============================================================
-- DATOS DE EXPOSICION - JSGE In-Mobiliaria
-- Base de datos: inmobiliaria (Clever Cloud)
--
-- Inserta:
--   * 10 usuarios CLIENTE (cliente01@jsge.com .. cliente10@jsge.com)
--     con contrasena "cliente123" (hash BCrypt).
--   * 15 propiedades (MAT-EXPO-001 .. MAT-EXPO-015) de la inmobiliaria demo.
--   * Imagenes por URL (relacion 1:N).
--   * Caracteristicas (relacion N:M).
--   * Citas de ejemplo en distintos estados.
--
-- Los IDs se generan AUTOMATICAMENTE (consecutivos): no se fijan valores.
-- Es IDEMPOTENTE: elimina los datos de expo previos, reinicia el
-- autoincremental y los vuelve a crear.
-- Ejecutar DESPUES del esquema (proyecto_completo.sql o sprint1+sprint2+3).
-- ============================================================

-- USE btlvt8r2avgfr0mrpr5l;   -- descomenta/ajusta si tu consola lo requiere

-- ============================================================
-- 0. LIMPIEZA DE DATOS DE EXPOSICION PREVIOS
-- ============================================================
DELETE FROM propiedad WHERE matricula_inmobiliaria LIKE 'MAT-EXPO-%';
DELETE FROM usuario   WHERE correo LIKE 'cliente%@jsge.com';

-- Reinicia el autoincremental para que los nuevos IDs sean consecutivos.
-- (Si se asigna un valor menor o igual al maximo, MySQL usa max+1.)
ALTER TABLE propiedad AUTO_INCREMENT = 1;
ALTER TABLE usuario   AUTO_INCREMENT = 1;
ALTER TABLE perfil    AUTO_INCREMENT = 1;
ALTER TABLE imagen_propiedad AUTO_INCREMENT = 1;
ALTER TABLE solicitud_visita AUTO_INCREMENT = 1;

-- ============================================================
-- 1. USUARIOS CLIENTE (contrasena: cliente123)
-- ============================================================
INSERT INTO usuario (correo, password_hash, estado) VALUES
('cliente01@jsge.com', '$2a$10$0pjPppOfaxs5JTE61lb2iOq5u17T7NiqHViWtmpYjzhXLanIVjWPe', TRUE),
('cliente02@jsge.com', '$2a$10$0pjPppOfaxs5JTE61lb2iOq5u17T7NiqHViWtmpYjzhXLanIVjWPe', TRUE),
('cliente03@jsge.com', '$2a$10$0pjPppOfaxs5JTE61lb2iOq5u17T7NiqHViWtmpYjzhXLanIVjWPe', TRUE),
('cliente04@jsge.com', '$2a$10$0pjPppOfaxs5JTE61lb2iOq5u17T7NiqHViWtmpYjzhXLanIVjWPe', TRUE),
('cliente05@jsge.com', '$2a$10$0pjPppOfaxs5JTE61lb2iOq5u17T7NiqHViWtmpYjzhXLanIVjWPe', TRUE),
('cliente06@jsge.com', '$2a$10$0pjPppOfaxs5JTE61lb2iOq5u17T7NiqHViWtmpYjzhXLanIVjWPe', TRUE),
('cliente07@jsge.com', '$2a$10$0pjPppOfaxs5JTE61lb2iOq5u17T7NiqHViWtmpYjzhXLanIVjWPe', TRUE),
('cliente08@jsge.com', '$2a$10$0pjPppOfaxs5JTE61lb2iOq5u17T7NiqHViWtmpYjzhXLanIVjWPe', TRUE),
('cliente09@jsge.com', '$2a$10$0pjPppOfaxs5JTE61lb2iOq5u17T7NiqHViWtmpYjzhXLanIVjWPe', TRUE),
('cliente10@jsge.com', '$2a$10$0pjPppOfaxs5JTE61lb2iOq5u17T7NiqHViWtmpYjzhXLanIVjWPe', TRUE);

INSERT INTO perfil (id_usuario, nombres, apellidos, documento, telefono, direccion)
SELECT u.id_usuario, x.nombres, x.apellidos, x.documento, x.telefono, x.direccion
FROM usuario u
JOIN (
    SELECT 'cliente01@jsge.com' AS correo, 'Carlos'    AS nombres, 'Perez'     AS apellidos, '4000000001' AS documento, '3101110001' AS telefono, 'Calle 45 # 12-01'   AS direccion
    UNION ALL SELECT 'cliente02@jsge.com', 'Maria',     'Gomez',     '4000000002', '3101110002', 'Carrera 12 # 34-02'
    UNION ALL SELECT 'cliente03@jsge.com', 'Andres',    'Rodriguez', '4000000003', '3101110003', 'Calle 20 # 8-15'
    UNION ALL SELECT 'cliente04@jsge.com', 'Laura',     'Martinez',  '4000000004', '3101110004', 'Carrera 30 # 45-10'
    UNION ALL SELECT 'cliente05@jsge.com', 'Diego',     'Hernandez', '4000000005', '3101110005', 'Calle 10 # 22-33'
    UNION ALL SELECT 'cliente06@jsge.com', 'Sofia',     'Lopez',     '4000000006', '3101110006', 'Avenida 40 # 12-05'
    UNION ALL SELECT 'cliente07@jsge.com', 'Julian',    'Ramirez',   '4000000007', '3101110007', 'Carrera 6 # 8-22'
    UNION ALL SELECT 'cliente08@jsge.com', 'Valentina', 'Torres',    '4000000008', '3101110008', 'Calle 30 # 15-40'
    UNION ALL SELECT 'cliente09@jsge.com', 'Camilo',    'Vargas',    '4000000009', '3101110009', 'Carrera 27 # 70-05'
    UNION ALL SELECT 'cliente10@jsge.com', 'Daniela',   'Castro',    '4000000010', '3101110010', 'Calle 55 # 20-30'
) x ON u.correo = x.correo;

INSERT INTO usuario_rol (id_usuario, id_rol)
SELECT id_usuario, 3 FROM usuario WHERE correo LIKE 'cliente%@jsge.com';

-- ============================================================
-- 2. PROPIEDADES (inmobiliaria demo = usuario 2)
-- ============================================================
INSERT INTO propiedad
    (matricula_inmobiliaria, titulo, descripcion, precio, habitaciones,
     banos, area_m2, direccion, estado_logico, id_inmobiliaria, id_tipo, id_ciudad) VALUES
('MAT-EXPO-001', 'Casa moderna en Bucaramanga',
 'Hermosa casa de dos plantas con acabados modernos, amplia sala comedor, cocina integral y patio interior. Ubicada en sector residencial tranquilo.',
 420000000.00, 4, 3, 210.50, 'Calle 45 # 12-01', TRUE, 2, 1, 1),
('MAT-EXPO-002', 'Apartamento con balcon en Floridablanca',
 'Apartamento luminoso con balcon, tres habitaciones, dos banos y parqueadero cubierto. Conjunto con zonas comunes y vigilancia.',
 285000000.00, 3, 2, 115.00, 'Carrera 8 # 22-14', TRUE, 2, 2, 2),
('MAT-EXPO-003', 'Casa campestre en Giron',
 'Casa campestre rodeada de naturaleza, con amplio jardin, zona de BBQ y espacio para dos vehiculos. Ideal para descanso familiar.',
 530000000.00, 5, 4, 320.00, 'Vereda El Poblado', TRUE, 2, 1, 3),
('MAT-EXPO-004', 'Apartamento amoblado en Bucaramanga',
 'Apartamento completamente amoblado, listo para habitar. Incluye electrodomesticos, dos habitaciones y excelente iluminacion natural.',
 310000000.00, 2, 2, 90.00, 'Carrera 33 # 48-10', TRUE, 2, 2, 1),
('MAT-EXPO-005', 'Local comercial en Floridablanca',
 'Local comercial sobre via principal, con vitrina, bano privado y espacio versatil para cualquier tipo de negocio. Alta afluencia peatonal.',
 640000000.00, 0, 2, 130.00, 'Avenida 40 # 12-05', TRUE, 2, 3, 2),
('MAT-EXPO-006', 'Oficina empresarial en Bucaramanga',
 'Oficina moderna en edificio empresarial con ascensor, recepcion, sala de juntas y parqueadero. Excelente ubicacion para empresa.',
 350000000.00, 0, 2, 85.00, 'Calle 55 # 20-30', TRUE, 2, 4, 1),
('MAT-EXPO-007', 'Apartamento con gimnasio en Piedecuesta',
 'Apartamento en conjunto cerrado con gimnasio, piscina y salon comunal. Tres habitaciones y balcon con vista abierta.',
 265000000.00, 3, 2, 105.50, 'Carrera 6 # 8-22', TRUE, 2, 2, 4),
('MAT-EXPO-008', 'Casa familiar en Floridablanca',
 'Casa ideal para familia numerosa, con cuatro habitaciones, estudio, garaje doble y patio. Cerca a colegios y centros comerciales.',
 395000000.00, 4, 3, 180.00, 'Calle 30 # 15-40', TRUE, 2, 1, 2),
('MAT-EXPO-009', 'Lote urbanizable en Giron',
 'Lote plano de 500 m2 listo para construir, con servicios publicos disponibles y facil acceso por via pavimentada.',
 180000000.00, 0, 0, 500.00, 'Vereda Chimita', TRUE, 2, 5, 3),
('MAT-EXPO-010', 'Casa con piscina en Bucaramanga',
 'Espectacular casa con piscina privada, zona social amplia, cinco habitaciones y acabados de lujo. Perfecta para disfrutar en familia.',
 620000000.00, 5, 4, 300.00, 'Calle 60 # 25-18', TRUE, 2, 1, 1),
('MAT-EXPO-011', 'Apartamento vista panoramica en Bucaramanga',
 'Apartamento en piso alto con vista panoramica de la ciudad, tres habitaciones, balcon y parqueadero. Edificio con ascensor.',
 330000000.00, 3, 2, 120.00, 'Carrera 27 # 70-05', TRUE, 2, 2, 1),
('MAT-EXPO-012', 'Oficina moderna en Floridablanca',
 'Oficina lista para operar, con divisiones en vidrio, aire acondicionado, recepcion y dos parqueaderos. Zona empresarial consolidada.',
 410000000.00, 0, 3, 100.00, 'Anillo Vial # 100-20', TRUE, 2, 4, 2),
('MAT-EXPO-013', 'Casa de descanso en Piedecuesta',
 'Casa de descanso con amplias zonas verdes, terraza, cuatro habitaciones y espacio para cultivo. Ambiente campestre y tranquilo.',
 470000000.00, 4, 3, 250.00, 'Vereda Sevilla', TRUE, 2, 1, 4),
('MAT-EXPO-014', 'Local esquinero en Bucaramanga',
 'Local esquinero con excelente visibilidad, ideal para restaurante o drogueria. Cuenta con bano, bodega y parqueadero propio.',
 700000000.00, 0, 2, 150.00, 'Calle 45 # 9-11', TRUE, 2, 3, 1),
('MAT-EXPO-015', 'Apartamento economico en Giron',
 'Apartamento de dos habitaciones, ideal para primera vivienda o inversion. Conjunto con zona verde y parqueadero comunal.',
 210000000.00, 2, 1, 75.00, 'Carrera 11 # 4-33', TRUE, 2, 2, 3);

-- ============================================================
-- 3. GALERIA DE IMAGENES (URLs publicas de Unsplash)
-- ============================================================
INSERT INTO imagen_propiedad (id_propiedad, url_imagen, es_principal)
SELECT p.id_propiedad, x.url, x.principal
FROM propiedad p
JOIN (
    SELECT 'MAT-EXPO-001' AS mat, 'https://images.unsplash.com/photo-1568605114967-8130f3a36994?auto=format&fit=crop&w=1200&q=60' AS url, TRUE AS principal
    UNION ALL SELECT 'MAT-EXPO-001', 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1200&q=60', FALSE
    UNION ALL SELECT 'MAT-EXPO-002', 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=1200&q=60', TRUE
    UNION ALL SELECT 'MAT-EXPO-002', 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=1200&q=60', FALSE
    UNION ALL SELECT 'MAT-EXPO-003', 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=1200&q=60', TRUE
    UNION ALL SELECT 'MAT-EXPO-004', 'https://images.unsplash.com/photo-1493809842364-78817add7ffb?auto=format&fit=crop&w=1200&q=60', TRUE
    UNION ALL SELECT 'MAT-EXPO-005', 'https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=1200&q=60', TRUE
    UNION ALL SELECT 'MAT-EXPO-005', 'https://images.unsplash.com/photo-1497366754035-f200968a6e72?auto=format&fit=crop&w=1200&q=60', FALSE
    UNION ALL SELECT 'MAT-EXPO-006', 'https://images.unsplash.com/photo-1497366811353-6870744d04b2?auto=format&fit=crop&w=1200&q=60', TRUE
    UNION ALL SELECT 'MAT-EXPO-007', 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=1200&q=60', TRUE
    UNION ALL SELECT 'MAT-EXPO-008', 'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?auto=format&fit=crop&w=1200&q=60', TRUE
    UNION ALL SELECT 'MAT-EXPO-009', 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=1200&q=60', TRUE
    UNION ALL SELECT 'MAT-EXPO-010', 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?auto=format&fit=crop&w=1200&q=60', TRUE
    UNION ALL SELECT 'MAT-EXPO-010', 'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?auto=format&fit=crop&w=1200&q=60', FALSE
    UNION ALL SELECT 'MAT-EXPO-011', 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?auto=format&fit=crop&w=1200&q=60', TRUE
    UNION ALL SELECT 'MAT-EXPO-012', 'https://images.unsplash.com/photo-1600566753086-00f18fb6b3ea?auto=format&fit=crop&w=1200&q=60', TRUE
    UNION ALL SELECT 'MAT-EXPO-013', 'https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde?auto=format&fit=crop&w=1200&q=60', TRUE
    UNION ALL SELECT 'MAT-EXPO-014', 'https://images.unsplash.com/photo-1600573472592-401b489a3cdc?auto=format&fit=crop&w=1200&q=60', TRUE
    UNION ALL SELECT 'MAT-EXPO-015', 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=60', TRUE
) x ON p.matricula_inmobiliaria = x.mat;

-- ============================================================
-- 4. CARACTERISTICAS (N:M)
--   1 Piscina | 2 Parqueadero | 3 Ascensor | 4 Gimnasio | 5 Vigilancia 24/7
--   6 Zona Verde | 7 Balcon | 8 Amoblado | 9 Aire Acondicionado | 10 Terraza
-- ============================================================
INSERT INTO propiedad_caracteristica (id_propiedad, id_caracteristica)
SELECT p.id_propiedad, x.id_car
FROM propiedad p
JOIN (
    SELECT 'MAT-EXPO-001' AS mat, 1 AS id_car
    UNION ALL SELECT 'MAT-EXPO-001', 2 UNION ALL SELECT 'MAT-EXPO-001', 6
    UNION ALL SELECT 'MAT-EXPO-002', 2 UNION ALL SELECT 'MAT-EXPO-002', 3 UNION ALL SELECT 'MAT-EXPO-002', 5
    UNION ALL SELECT 'MAT-EXPO-003', 2 UNION ALL SELECT 'MAT-EXPO-003', 6 UNION ALL SELECT 'MAT-EXPO-003', 10
    UNION ALL SELECT 'MAT-EXPO-004', 2 UNION ALL SELECT 'MAT-EXPO-004', 8
    UNION ALL SELECT 'MAT-EXPO-005', 2 UNION ALL SELECT 'MAT-EXPO-005', 5
    UNION ALL SELECT 'MAT-EXPO-006', 2 UNION ALL SELECT 'MAT-EXPO-006', 3 UNION ALL SELECT 'MAT-EXPO-006', 5 UNION ALL SELECT 'MAT-EXPO-006', 9
    UNION ALL SELECT 'MAT-EXPO-007', 2 UNION ALL SELECT 'MAT-EXPO-007', 4 UNION ALL SELECT 'MAT-EXPO-007', 5 UNION ALL SELECT 'MAT-EXPO-007', 7
    UNION ALL SELECT 'MAT-EXPO-008', 2 UNION ALL SELECT 'MAT-EXPO-008', 6
    UNION ALL SELECT 'MAT-EXPO-009', 6
    UNION ALL SELECT 'MAT-EXPO-010', 1 UNION ALL SELECT 'MAT-EXPO-010', 2 UNION ALL SELECT 'MAT-EXPO-010', 6 UNION ALL SELECT 'MAT-EXPO-010', 10
    UNION ALL SELECT 'MAT-EXPO-011', 2 UNION ALL SELECT 'MAT-EXPO-011', 3 UNION ALL SELECT 'MAT-EXPO-011', 7
    UNION ALL SELECT 'MAT-EXPO-012', 2 UNION ALL SELECT 'MAT-EXPO-012', 3 UNION ALL SELECT 'MAT-EXPO-012', 5 UNION ALL SELECT 'MAT-EXPO-012', 9
    UNION ALL SELECT 'MAT-EXPO-013', 2 UNION ALL SELECT 'MAT-EXPO-013', 6 UNION ALL SELECT 'MAT-EXPO-013', 10
    UNION ALL SELECT 'MAT-EXPO-014', 2 UNION ALL SELECT 'MAT-EXPO-014', 5
    UNION ALL SELECT 'MAT-EXPO-015', 2 UNION ALL SELECT 'MAT-EXPO-015', 6
) x ON p.matricula_inmobiliaria = x.mat;

-- ============================================================
-- 5. CITAS / SOLICITUDES DE VISITA (ejemplos)
-- ============================================================
INSERT INTO solicitud_visita (id_propiedad, id_cliente, fecha_visita, hora_visita, comentario, estado)
SELECT p.id_propiedad, u.id_usuario,
       DATE_ADD(CURDATE(), INTERVAL x.dias DAY), x.hora, x.comentario, x.estado
FROM (
    SELECT 'MAT-EXPO-001' AS mat, 'cliente01@jsge.com' AS correo, 3 AS dias, '10:00:00' AS hora, 'Quiero conocer la casa en la manana.'       AS comentario, 'PENDIENTE'  AS estado
    UNION ALL SELECT 'MAT-EXPO-003', 'cliente02@jsge.com', 2, '14:00:00', 'Me interesa la casa campestre.',           'CONFIRMADA'
    UNION ALL SELECT 'MAT-EXPO-005', 'cliente03@jsge.com', 4, '09:30:00', 'Deseo ver el local comercial.',            'PENDIENTE'
    UNION ALL SELECT 'MAT-EXPO-007', 'cliente04@jsge.com', 1, '16:00:00', 'Voy a revisar el apartamento.',            'CONFIRMADA'
    UNION ALL SELECT 'MAT-EXPO-002', 'cliente05@jsge.com', 5, '11:00:00', 'Visita realizada, quede interesado.',      'REALIZADA'
    UNION ALL SELECT 'MAT-EXPO-010', 'cliente06@jsge.com', 3, '15:00:00', 'Quiero ver la casa con piscina.',          'PENDIENTE'
    UNION ALL SELECT 'MAT-EXPO-012', 'cliente07@jsge.com', 6, '10:30:00', 'Cambie de opinion, cancelo la visita.',    'CANCELADA'
    UNION ALL SELECT 'MAT-EXPO-008', 'cliente08@jsge.com', 2, '13:00:00', 'Me interesa la casa familiar.',            'PENDIENTE'
    UNION ALL SELECT 'MAT-EXPO-004', 'cliente09@jsge.com', 7, '09:00:00', 'Quiero ver el apartamento amoblado.',      'PENDIENTE'
    UNION ALL SELECT 'MAT-EXPO-011', 'cliente10@jsge.com', 4, '17:00:00', 'Deseo la visita del apartamento con vista.','CONFIRMADA'
) x
JOIN propiedad p ON p.matricula_inmobiliaria = x.mat
JOIN usuario   u ON u.correo = x.correo;

-- ============================================================
-- 6b. SOLICITUDES DE COMPRA / ARRIENDO Y DOCUMENTOS (ejemplos)
-- ============================================================
INSERT INTO solicitud (id_solicitud, id_propiedad, id_cliente, tipo, monto_oferta, mensaje, estado, observacion) VALUES
(1, 5, 4, 'COMPRA',   400000000.00, 'Estoy interesado en la casa.',    'PENDIENTE',   NULL),
(2, 6, 5, 'ARRIENDO',   1500000.00, 'Quiero arrendar el apartamento.', 'EN_REVISION', 'Revisando documentos.'),
(3, 7, 6, 'COMPRA',   250000000.00, 'Oferta por la casa campestre.',   'APROBADA',    'Documentacion completa.');

INSERT INTO documento_solicitud (id_documento, id_solicitud, tipo, nombre, url_documento) VALUES
(1, 1, 'CEDULA',    'Cedula de ciudadania',  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),
(2, 2, 'INGRESOS',  'Certificado laboral',   'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),
(3, 2, 'EXTRACTOS', 'Extractos bancarios',  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'),
(4, 3, 'ESCRITURA', 'Escritura del inmueble','https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf');

-- ============================================================
-- 6. VERIFICACION
-- ============================================================
-- SELECT id_propiedad, matricula_inmobiliaria FROM propiedad ORDER BY id_propiedad;
-- SELECT id_usuario, correo FROM usuario ORDER BY id_usuario;
