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
-- Es IDEMPOTENTE: primero elimina los datos de exposicion previos
-- (solo los que coinciden con los patrones usados) y luego los recrea.
-- Ejecutar DESPUES del esquema (proyecto_completo.sql o sprint1+sprint2+3).
-- ============================================================

-- USE btlvt8r2avgfr0mrpr5l;   -- descomenta/ajusta si tu consola lo requiere

-- ============================================================
-- 0. LIMPIEZA DE DATOS DE EXPOSICION PREVIOS
-- ============================================================
DELETE FROM propiedad WHERE matricula_inmobiliaria LIKE 'MAT-EXPO-%';
DELETE FROM usuario   WHERE correo LIKE 'cliente%@jsge.com';

-- ============================================================
-- 1. USUARIOS CLIENTE (contrasena: cliente123)
-- ============================================================
INSERT INTO usuario (id_usuario, correo, password_hash, estado) VALUES
(101, 'cliente01@jsge.com', '$2a$10$0pjPppOfaxs5JTE61lb2iOq5u17T7NiqHViWtmpYjzhXLanIVjWPe', TRUE),
(102, 'cliente02@jsge.com', '$2a$10$0pjPppOfaxs5JTE61lb2iOq5u17T7NiqHViWtmpYjzhXLanIVjWPe', TRUE),
(103, 'cliente03@jsge.com', '$2a$10$0pjPppOfaxs5JTE61lb2iOq5u17T7NiqHViWtmpYjzhXLanIVjWPe', TRUE),
(104, 'cliente04@jsge.com', '$2a$10$0pjPppOfaxs5JTE61lb2iOq5u17T7NiqHViWtmpYjzhXLanIVjWPe', TRUE),
(105, 'cliente05@jsge.com', '$2a$10$0pjPppOfaxs5JTE61lb2iOq5u17T7NiqHViWtmpYjzhXLanIVjWPe', TRUE),
(106, 'cliente06@jsge.com', '$2a$10$0pjPppOfaxs5JTE61lb2iOq5u17T7NiqHViWtmpYjzhXLanIVjWPe', TRUE),
(107, 'cliente07@jsge.com', '$2a$10$0pjPppOfaxs5JTE61lb2iOq5u17T7NiqHViWtmpYjzhXLanIVjWPe', TRUE),
(108, 'cliente08@jsge.com', '$2a$10$0pjPppOfaxs5JTE61lb2iOq5u17T7NiqHViWtmpYjzhXLanIVjWPe', TRUE),
(109, 'cliente09@jsge.com', '$2a$10$0pjPppOfaxs5JTE61lb2iOq5u17T7NiqHViWtmpYjzhXLanIVjWPe', TRUE),
(110, 'cliente10@jsge.com', '$2a$10$0pjPppOfaxs5JTE61lb2iOq5u17T7NiqHViWtmpYjzhXLanIVjWPe', TRUE);

INSERT INTO perfil (id_usuario, nombres, apellidos, documento, telefono, direccion) VALUES
(101, 'Carlos',    'Perez',     '4000000001', '3101110001', 'Calle 45 # 12-01'),
(102, 'Maria',     'Gomez',     '4000000002', '3101110002', 'Carrera 12 # 34-02'),
(103, 'Andres',    'Rodriguez', '4000000003', '3101110003', 'Calle 20 # 8-15'),
(104, 'Laura',     'Martinez',  '4000000004', '3101110004', 'Carrera 30 # 45-10'),
(105, 'Diego',     'Hernandez', '4000000005', '3101110005', 'Calle 10 # 22-33'),
(106, 'Sofia',     'Lopez',     '4000000006', '3101110006', 'Avenida 40 # 12-05'),
(107, 'Julian',    'Ramirez',   '4000000007', '3101110007', 'Carrera 6 # 8-22'),
(108, 'Valentina', 'Torres',    '4000000008', '3101110008', 'Calle 30 # 15-40'),
(109, 'Camilo',    'Vargas',    '4000000009', '3101110009', 'Carrera 27 # 70-05'),
(110, 'Daniela',   'Castro',    '4000000010', '3101110010', 'Calle 55 # 20-30');

INSERT INTO usuario_rol (id_usuario, id_rol) VALUES
(101, 3), (102, 3), (103, 3), (104, 3), (105, 3),
(106, 3), (107, 3), (108, 3), (109, 3), (110, 3);

-- ============================================================
-- 2. PROPIEDADES (inmobiliaria demo = usuario 2)
-- ============================================================
INSERT INTO propiedad
    (id_propiedad, matricula_inmobiliaria, titulo, descripcion, precio, habitaciones,
     banos, area_m2, direccion, estado_logico, id_inmobiliaria, id_tipo, id_ciudad) VALUES
(101, 'MAT-EXPO-001', 'Casa moderna en Bucaramanga',
 'Hermosa casa de dos plantas con acabados modernos, amplia sala comedor, cocina integral y patio interior. Ubicada en sector residencial tranquilo.',
 420000000.00, 4, 3, 210.50, 'Calle 45 # 12-01', TRUE, 2, 1, 1),
(102, 'MAT-EXPO-002', 'Apartamento con balcon en Floridablanca',
 'Apartamento luminoso con balcon, tres habitaciones, dos banos y parqueadero cubierto. Conjunto con zonas comunes y vigilancia.',
 285000000.00, 3, 2, 115.00, 'Carrera 8 # 22-14', TRUE, 2, 2, 2),
(103, 'MAT-EXPO-003', 'Casa campestre en Giron',
 'Casa campestre rodeada de naturaleza, con amplio jardin, zona de BBQ y espacio para dos vehiculos. Ideal para descanso familiar.',
 530000000.00, 5, 4, 320.00, 'Vereda El Poblado', TRUE, 2, 1, 3),
(104, 'MAT-EXPO-004', 'Apartamento amoblado en Bucaramanga',
 'Apartamento completamente amoblado, listo para habitar. Incluye electrodomesticos, dos habitaciones y excelente iluminacion natural.',
 310000000.00, 2, 2, 90.00, 'Carrera 33 # 48-10', TRUE, 2, 2, 1),
(105, 'MAT-EXPO-005', 'Local comercial en Floridablanca',
 'Local comercial sobre via principal, con vitrina, bano privado y espacio versatil para cualquier tipo de negocio. Alta afluencia peatonal.',
 640000000.00, 0, 2, 130.00, 'Avenida 40 # 12-05', TRUE, 2, 3, 2),
(106, 'MAT-EXPO-006', 'Oficina empresarial en Bucaramanga',
 'Oficina moderna en edificio empresarial con ascensor, recepcion, sala de juntas y parqueadero. Excelente ubicacion para empresa.',
 350000000.00, 0, 2, 85.00, 'Calle 55 # 20-30', TRUE, 2, 4, 1),
(107, 'MAT-EXPO-007', 'Apartamento con gimnasio en Piedecuesta',
 'Apartamento en conjunto cerrado con gimnasio, piscina y salon comunal. Tres habitaciones y balcon con vista abierta.',
 265000000.00, 3, 2, 105.50, 'Carrera 6 # 8-22', TRUE, 2, 2, 4),
(108, 'MAT-EXPO-008', 'Casa familiar en Floridablanca',
 'Casa ideal para familia numerosa, con cuatro habitaciones, estudio, garaje doble y patio. Cerca a colegios y centros comerciales.',
 395000000.00, 4, 3, 180.00, 'Calle 30 # 15-40', TRUE, 2, 1, 2),
(109, 'MAT-EXPO-009', 'Lote urbanizable en Giron',
 'Lote plano de 500 m2 listo para construir, con servicios publicos disponibles y facil acceso por via pavimentada.',
 180000000.00, 0, 0, 500.00, 'Vereda Chimita', TRUE, 2, 5, 3),
(110, 'MAT-EXPO-010', 'Casa con piscina en Bucaramanga',
 'Espectacular casa con piscina privada, zona social amplia, cinco habitaciones y acabados de lujo. Perfecta para disfrutar en familia.',
 620000000.00, 5, 4, 300.00, 'Calle 60 # 25-18', TRUE, 2, 1, 1),
(111, 'MAT-EXPO-011', 'Apartamento vista panoramica en Bucaramanga',
 'Apartamento en piso alto con vista panoramica de la ciudad, tres habitaciones, balcon y parqueadero. Edificio con ascensor.',
 330000000.00, 3, 2, 120.00, 'Carrera 27 # 70-05', TRUE, 2, 2, 1),
(112, 'MAT-EXPO-012', 'Oficina moderna en Floridablanca',
 'Oficina lista para operar, con divisiones en vidrio, aire acondicionado, recepcion y dos parqueaderos. Zona empresarial consolidada.',
 410000000.00, 0, 3, 100.00, 'Anillo Vial # 100-20', TRUE, 2, 4, 2),
(113, 'MAT-EXPO-013', 'Casa de descanso en Piedecuesta',
 'Casa de descanso con amplias zonas verdes, terraza, cuatro habitaciones y espacio para cultivo. Ambiente campestre y tranquilo.',
 470000000.00, 4, 3, 250.00, 'Vereda Sevilla', TRUE, 2, 1, 4),
(114, 'MAT-EXPO-014', 'Local esquinero en Bucaramanga',
 'Local esquinero con excelente visibilidad, ideal para restaurante o drogueria. Cuenta con bano, bodega y parqueadero propio.',
 700000000.00, 0, 2, 150.00, 'Calle 45 # 9-11', TRUE, 2, 3, 1),
(115, 'MAT-EXPO-015', 'Apartamento economico en Giron',
 'Apartamento de dos habitaciones, ideal para primera vivienda o inversion. Conjunto con zona verde y parqueadero comunal.',
 210000000.00, 2, 1, 75.00, 'Carrera 11 # 4-33', TRUE, 2, 2, 3);

-- ============================================================
-- 3. GALERIA DE IMAGENES (URLs publicas de Unsplash)
-- ============================================================
INSERT INTO imagen_propiedad (id_propiedad, url_imagen, es_principal) VALUES
(101, 'https://images.unsplash.com/photo-1568605114967-8130f3a36994?auto=format&fit=crop&w=1200&q=60', TRUE),
(101, 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1200&q=60', FALSE),
(102, 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=1200&q=60', TRUE),
(102, 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=1200&q=60', FALSE),
(103, 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=1200&q=60', TRUE),
(104, 'https://images.unsplash.com/photo-1493809842364-78817add7ffb?auto=format&fit=crop&w=1200&q=60', TRUE),
(105, 'https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=1200&q=60', TRUE),
(105, 'https://images.unsplash.com/photo-1497366754035-f200968a6e72?auto=format&fit=crop&w=1200&q=60', FALSE),
(106, 'https://images.unsplash.com/photo-1497366811353-6870744d04b2?auto=format&fit=crop&w=1200&q=60', TRUE),
(107, 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=1200&q=60', TRUE),
(108, 'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?auto=format&fit=crop&w=1200&q=60', TRUE),
(109, 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=1200&q=60', TRUE),
(110, 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?auto=format&fit=crop&w=1200&q=60', TRUE),
(110, 'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?auto=format&fit=crop&w=1200&q=60', FALSE),
(111, 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?auto=format&fit=crop&w=1200&q=60', TRUE),
(112, 'https://images.unsplash.com/photo-1600566753086-00f18fb6b3ea?auto=format&fit=crop&w=1200&q=60', TRUE),
(113, 'https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde?auto=format&fit=crop&w=1200&q=60', TRUE),
(114, 'https://images.unsplash.com/photo-1600573472592-401b489a3cdc?auto=format&fit=crop&w=1200&q=60', TRUE),
(115, 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=60', TRUE);

-- ============================================================
-- 4. CARACTERISTICAS (N:M)
--   1 Piscina | 2 Parqueadero | 3 Ascensor | 4 Gimnasio | 5 Vigilancia 24/7
--   6 Zona Verde | 7 Balcon | 8 Amoblado | 9 Aire Acondicionado | 10 Terraza
-- ============================================================
INSERT INTO propiedad_caracteristica (id_propiedad, id_caracteristica) VALUES
(101, 1), (101, 2), (101, 6),
(102, 2), (102, 3), (102, 5),
(103, 2), (103, 6), (103, 10),
(104, 2), (104, 8),
(105, 2), (105, 5),
(106, 2), (106, 3), (106, 5), (106, 9),
(107, 2), (107, 4), (107, 5), (107, 7),
(108, 2), (108, 6),
(109, 6),
(110, 1), (110, 2), (110, 6), (110, 10),
(111, 2), (111, 3), (111, 7),
(112, 2), (112, 3), (112, 5), (112, 9),
(113, 2), (113, 6), (113, 10),
(114, 2), (114, 5),
(115, 2), (115, 6);

-- ============================================================
-- 5. CITAS / SOLICITUDES DE VISITA (ejemplos)
-- ============================================================
INSERT INTO solicitud_visita (id_propiedad, id_cliente, fecha_visita, hora_visita, comentario, estado) VALUES
(101, 101, DATE_ADD(CURDATE(), INTERVAL 3 DAY), '10:00:00', 'Quiero conocer la casa en la manana.',        'PENDIENTE'),
(103, 102, DATE_ADD(CURDATE(), INTERVAL 2 DAY), '14:00:00', 'Me interesa la casa campestre.',              'CONFIRMADA'),
(105, 103, DATE_ADD(CURDATE(), INTERVAL 4 DAY), '09:30:00', 'Deseo ver el local comercial.',               'PENDIENTE'),
(107, 104, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '16:00:00', 'Voy a revisar el apartamento.',               'CONFIRMADA'),
(102, 105, DATE_ADD(CURDATE(), INTERVAL 5 DAY), '11:00:00', 'Visita realizada, quede interesado.',         'REALIZADA'),
(110, 106, DATE_ADD(CURDATE(), INTERVAL 3 DAY), '15:00:00', 'Quiero ver la casa con piscina.',             'PENDIENTE'),
(112, 107, DATE_ADD(CURDATE(), INTERVAL 6 DAY), '10:30:00', 'Cambie de opinion, cancelo la visita.',       'CANCELADA'),
(108, 108, DATE_ADD(CURDATE(), INTERVAL 2 DAY), '13:00:00', 'Me interesa la casa familiar.',               'PENDIENTE'),
(104, 109, DATE_ADD(CURDATE(), INTERVAL 7 DAY), '09:00:00', 'Quiero ver el apartamento amoblado.',         'PENDIENTE'),
(111, 110, DATE_ADD(CURDATE(), INTERVAL 4 DAY), '17:00:00', 'Deseo la visita del apartamento con vista.',  'CONFIRMADA');

-- ============================================================
-- 6. VERIFICACION
-- ============================================================
-- SELECT COUNT(*) AS propiedades FROM propiedad WHERE matricula_inmobiliaria LIKE 'MAT-EXPO-%';
-- SELECT COUNT(*) AS clientes FROM usuario WHERE correo LIKE 'cliente%@jsge.com';
-- SELECT COUNT(*) AS imagenes FROM imagen_propiedad WHERE id_propiedad BETWEEN 101 AND 115;
-- SELECT COUNT(*) AS citas FROM solicitud_visita;
