-- ============================================================
-- DATOS DE DEMO PARA EL MODULO DE REPORTES (OPCIONAL)
-- Base de datos: inmobiliaria
--
-- Inserta 4 propiedades de ejemplo para la inmobiliaria demo (usuario 2)
-- e imagenes solo para dos de ellas, de forma que:
--   * El INNER JOIN de 4 tablas devuelva 4 filas.
--   * El LEFT JOIN "propiedades sin imagenes" devuelva 2 filas.
--   * El GROUP BY + HAVING "ciudades con 2+ propiedades" devuelva Bucaramanga.
--
-- Es idempotente: puede ejecutarse varias veces sin duplicar datos.
-- Ejecutar DESPUES de sprint1.sql y sprint2.sql.
-- ============================================================

USE inmobiliaria;

INSERT INTO propiedad
    (matricula_inmobiliaria, titulo, descripcion, precio, habitaciones, banos, area_m2,
     direccion, estado_logico, id_inmobiliaria, id_tipo, id_ciudad)
VALUES
    ('MAT-DEMO-001', 'Casa campestre en Bucaramanga', 'Propiedad de demostracion para reportes.',
     450000000.00, 4, 3, 220.50, 'Calle 10 # 20-30', TRUE, 2, 1, 1),
    ('MAT-DEMO-002', 'Apartamento en Floridablanca', 'Propiedad de demostracion para reportes.',
     280000000.00, 3, 2, 110.00, 'Carrera 5 # 10-15', TRUE, 2, 2, 2),
    ('MAT-DEMO-003', 'Casa en Bucaramanga', 'Propiedad de demostracion sin imagenes.',
     390000000.00, 3, 2, 160.00, 'Calle 33 # 12-40', TRUE, 2, 1, 1),
    ('MAT-DEMO-004', 'Local comercial en Giron', 'Propiedad de demostracion sin imagenes.',
     520000000.00, 0, 1, 95.00, 'Carrera 7 # 4-11', TRUE, 2, 3, 3)
ON DUPLICATE KEY UPDATE
    titulo = VALUES(titulo),
    descripcion = VALUES(descripcion);

-- Solo MAT-DEMO-001 y MAT-DEMO-002 tendran imagenes (las otras dos alimentan el LEFT JOIN)
INSERT INTO imagen_propiedad (id_propiedad, url_imagen, es_principal)
SELECT p.id_propiedad, 'https://images.unsplash.com/photo-1568605114967-8130f3a36994', TRUE
FROM propiedad p
WHERE p.matricula_inmobiliaria = 'MAT-DEMO-001'
  AND NOT EXISTS (SELECT 1 FROM imagen_propiedad i WHERE i.id_propiedad = p.id_propiedad);

INSERT INTO imagen_propiedad (id_propiedad, url_imagen, es_principal)
SELECT p.id_propiedad, 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267', TRUE
FROM propiedad p
WHERE p.matricula_inmobiliaria = 'MAT-DEMO-002'
  AND NOT EXISTS (SELECT 1 FROM imagen_propiedad i WHERE i.id_propiedad = p.id_propiedad);
