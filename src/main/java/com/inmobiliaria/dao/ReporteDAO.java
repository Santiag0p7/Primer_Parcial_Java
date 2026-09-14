package com.inmobiliaria.dao;

import com.inmobiliaria.model.ConteoCiudad;
import com.inmobiliaria.model.Propiedad;
import com.inmobiliaria.model.PropiedadReporte;
import com.inmobiliaria.util.ConexionDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO exclusivo del modulo de reportes (Sprint 2).
 *
 * Concentra las consultas obligatorias de la rubrica:
 *   1) INNER JOIN entre tres o mas tablas  (propiedad + tipo + ciudad)
 *   2) INNER JOIN entre tres o mas tablas  (propiedad + tipo + ciudad + usuario/inmobiliaria)
 *   3) Relacion muchos a muchos            (ver CaracteristicaDAO.listarPorPropiedad)
 *   4) LEFT JOIN                           (propiedades que no tienen imagenes)
 *   5) Agregacion GROUP BY + HAVING        (ciudades con 2 o mas propiedades)
 *
 * Todas usan PreparedStatement y try-with-resources para el cierre de recursos.
 */
public class ReporteDAO {

    /**
     * Consulta INNER JOIN entre cuatro tablas: propiedad, tipo_propiedad,
     * ciudad y usuario (inmobiliaria). Alimenta el reporte
     * "Propiedades con su inmobiliaria".
     *
     * @return Lista de propiedades activas con su tipo, ciudad e inmobiliaria
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public List<PropiedadReporte> listarPropiedadesConInmobiliaria() throws SQLException {
        String sql = "SELECT p.id_propiedad, p.titulo, p.precio, "
                + "t.nombre AS nombre_tipo, c.nombre AS nombre_ciudad, "
                + "u.correo AS correo_inmobiliaria "
                + "FROM propiedad p "
                + "INNER JOIN tipo_propiedad t ON p.id_tipo = t.id_tipo "
                + "INNER JOIN ciudad c ON p.id_ciudad = c.id_ciudad "
                + "INNER JOIN usuario u ON p.id_inmobiliaria = u.id_usuario "
                + "WHERE p.estado_logico = TRUE "
                + "ORDER BY p.fecha_publicacion DESC";

        List<PropiedadReporte> lista = new ArrayList<>();

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                PropiedadReporte r = new PropiedadReporte();
                r.setIdPropiedad(rs.getInt("id_propiedad"));
                r.setTitulo(rs.getString("titulo"));
                r.setPrecio(rs.getBigDecimal("precio"));
                r.setNombreTipo(rs.getString("nombre_tipo"));
                r.setNombreCiudad(rs.getString("nombre_ciudad"));
                r.setCorreoInmobiliaria(rs.getString("correo_inmobiliaria"));
                lista.add(r);
            }
        }
        return lista;
    }

    /**
     * Consulta con LEFT JOIN: propiedades que aun no tienen imagenes en su
     * galeria. Alimenta el reporte "Propiedades sin imagenes".
     *
     * @return Lista de propiedades activas sin imagenes registradas
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public List<Propiedad> listarPropiedadesSinImagenes() throws SQLException {
        String sql = "SELECT p.id_propiedad, p.matricula_inmobiliaria, p.titulo, p.descripcion, "
                + "p.precio, p.habitaciones, p.banos, p.area_m2, p.direccion, p.estado_logico, "
                + "p.id_inmobiliaria, p.id_tipo, p.id_ciudad, p.fecha_publicacion, "
                + "t.nombre AS nombre_tipo, c.nombre AS nombre_ciudad "
                + "FROM propiedad p "
                + "INNER JOIN tipo_propiedad t ON p.id_tipo = t.id_tipo "
                + "INNER JOIN ciudad c ON p.id_ciudad = c.id_ciudad "
                + "LEFT JOIN imagen_propiedad i ON p.id_propiedad = i.id_propiedad "
                + "WHERE i.id_imagen IS NULL AND p.estado_logico = TRUE "
                + "ORDER BY p.fecha_publicacion DESC";

        List<Propiedad> lista = new ArrayList<>();

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(mapearPropiedad(rs));
            }
        }
        return lista;
    }

    /**
     * Consulta de agregacion GROUP BY + HAVING: cuenta las propiedades activas
     * por ciudad y conserva solo las ciudades con dos o mas propiedades.
     * Alimenta el reporte "Propiedades por ciudad".
     *
     * @return Lista de ciudades con su total de propiedades (>= 2)
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public List<ConteoCiudad> contarPropiedadesPorCiudad() throws SQLException {
        String sql = "SELECT c.nombre AS nombre_ciudad, COUNT(p.id_propiedad) AS total "
                + "FROM ciudad c "
                + "INNER JOIN propiedad p ON c.id_ciudad = p.id_ciudad "
                + "WHERE p.estado_logico = TRUE "
                + "GROUP BY c.id_ciudad, c.nombre "
                + "HAVING COUNT(p.id_propiedad) >= 2 "
                + "ORDER BY total DESC, c.nombre ASC";

        List<ConteoCiudad> lista = new ArrayList<>();

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ConteoCiudad c = new ConteoCiudad();
                c.setNombreCiudad(rs.getString("nombre_ciudad"));
                c.setTotal(rs.getInt("total"));
                lista.add(c);
            }
        }
        return lista;
    }

    /**
     * Mapea la fila actual del ResultSet a un objeto Propiedad.
     */
    private Propiedad mapearPropiedad(ResultSet rs) throws SQLException {
        Propiedad p = new Propiedad();
        p.setIdPropiedad(rs.getInt("id_propiedad"));
        p.setMatriculaInmobiliaria(rs.getString("matricula_inmobiliaria"));
        p.setTitulo(rs.getString("titulo"));
        p.setDescripcion(rs.getString("descripcion"));
        p.setPrecio(rs.getBigDecimal("precio"));
        p.setHabitaciones(rs.getInt("habitaciones"));
        p.setBanos(rs.getInt("banos"));
        p.setAreaM2(rs.getBigDecimal("area_m2"));
        p.setDireccion(rs.getString("direccion"));
        p.setEstadoLogico(rs.getBoolean("estado_logico"));
        p.setIdInmobiliaria(rs.getInt("id_inmobiliaria"));
        p.setIdTipo(rs.getInt("id_tipo"));
        p.setIdCiudad(rs.getInt("id_ciudad"));

        java.sql.Timestamp fecha = rs.getTimestamp("fecha_publicacion");
        if (fecha != null) {
            p.setFechaPublicacion(fecha.toLocalDateTime());
        }

        p.setNombreTipo(rs.getString("nombre_tipo"));
        p.setNombreCiudad(rs.getString("nombre_ciudad"));
        return p;
    }
}
