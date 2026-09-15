package com.inmobiliaria.dao;

import com.inmobiliaria.model.ConteoCiudad;
import com.inmobiliaria.model.MetricaAgrupada;
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

    // ====================================================
    // METRICAS DEL DASHBOARD (Sprint 3 - Item 3)
    // ====================================================

    /**
     * Cuenta las propiedades activas del sistema.
     *
     * @return total de inmuebles con estado_logico = TRUE
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public int totalPropiedadesActivas() throws SQLException {
        String sql = "SELECT COUNT(*) FROM propiedad WHERE estado_logico = TRUE";
        return contar(sql);
    }

    /**
     * Cuenta las propiedades activas de una inmobiliaria especifica.
     *
     * @param idInmobiliaria ID del usuario (INMOBILIARIA) dueno de las publicaciones
     * @return total de inmuebles activos de esa inmobiliaria
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public int totalPropiedadesActivasPorInmobiliaria(int idInmobiliaria) throws SQLException {
        String sql = "SELECT COUNT(*) FROM propiedad "
                + "WHERE estado_logico = TRUE AND id_inmobiliaria = ?";
        return contar(sql, idInmobiliaria);
    }

    /**
     * Cuenta las solicitudes de visita en estado PENDIENTE.
     *
     * @return total de citas por atender
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public int totalSolicitudesPendientes() throws SQLException {
        String sql = "SELECT COUNT(*) FROM solicitud_visita WHERE estado = 'PENDIENTE'";
        return contar(sql);
    }

    /**
     * Cuenta las solicitudes PENDIENTES recibidas por una inmobiliaria.
     *
     * @param idInmobiliaria ID del usuario (INMOBILIARIA) dueno de las propiedades
     * @return total de citas pendientes sobre sus inmuebles
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public int totalSolicitudesPendientesPorInmobiliaria(int idInmobiliaria) throws SQLException {
        String sql = "SELECT COUNT(*) FROM solicitud_visita sv "
                + "INNER JOIN propiedad p ON sv.id_propiedad = p.id_propiedad "
                + "WHERE sv.estado = 'PENDIENTE' AND p.id_inmobiliaria = ?";
        return contar(sql, idInmobiliaria);
    }

    /**
     * Cuenta el total de usuarios registrados en el sistema.
     *
     * @return total general de usuarios
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public int totalUsuarios() throws SQLException {
        String sql = "SELECT COUNT(*) FROM usuario";
        return contar(sql);
    }

    /**
     * Agrupa las propiedades activas por ciudad (incluye ciudades sin
     * propiedades con total 0). Alimenta las metricas visuales del dashboard.
     *
     * @return Lista de etiqueta (ciudad) + total, ordenada de mayor a menor
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public List<MetricaAgrupada> obtenerMetricasPorCiudad() throws SQLException {
        String sql = "SELECT c.nombre AS etiqueta, COUNT(p.id_propiedad) AS total "
                + "FROM ciudad c "
                + "LEFT JOIN propiedad p ON c.id_ciudad = p.id_ciudad AND p.estado_logico = TRUE "
                + "GROUP BY c.id_ciudad, c.nombre "
                + "ORDER BY total DESC, c.nombre ASC";
        return listarMetricas(sql);
    }

    /**
     * Agrupa las propiedades activas por tipo de propiedad (incluye tipos sin
     * propiedades con total 0). Alimenta las metricas visuales del dashboard.
     *
     * @return Lista de etiqueta (tipo) + total, ordenada de mayor a menor
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public List<MetricaAgrupada> obtenerMetricasPorTipo() throws SQLException {
        String sql = "SELECT t.nombre AS etiqueta, COUNT(p.id_propiedad) AS total "
                + "FROM tipo_propiedad t "
                + "LEFT JOIN propiedad p ON t.id_tipo = p.id_tipo AND p.estado_logico = TRUE "
                + "GROUP BY t.id_tipo, t.nombre "
                + "ORDER BY total DESC, t.nombre ASC";
        return listarMetricas(sql);
    }

    /**
     * Cuenta las citas (solicitud_visita) agrupadas por estado.
     * Alimenta el reporte "Citas por estado".
     *
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public List<MetricaAgrupada> contarCitasPorEstado() throws SQLException {
        String sql = "SELECT sv.estado AS etiqueta, COUNT(*) AS total "
                + "FROM solicitud_visita sv "
                + "GROUP BY sv.estado "
                + "ORDER BY total DESC";
        return listarMetricas(sql);
    }

    /**
     * Cuenta las solicitudes de compra/arriendo agrupadas por inmobiliaria.
     * Alimenta el reporte "Solicitudes por inmobiliaria".
     *
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public List<MetricaAgrupada> listarSolicitudesPorInmobiliaria() throws SQLException {
        String sql = "SELECT u.correo AS etiqueta, COUNT(s.id_solicitud) AS total "
                + "FROM solicitud s "
                + "INNER JOIN propiedad p ON s.id_propiedad = p.id_propiedad "
                + "INNER JOIN usuario u ON p.id_inmobiliaria = u.id_usuario "
                + "GROUP BY u.id_usuario, u.correo "
                + "ORDER BY total DESC";
        return listarMetricas(sql);
    }

    /**
     * Cuenta las propiedades por estado (Activa / Inactiva), evidencia de la
     * baja logica. Alimenta el reporte "Propiedades por estado".
     *
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public List<MetricaAgrupada> contarPropiedadesPorEstado() throws SQLException {
        String sql = "SELECT CASE WHEN p.estado_logico = TRUE THEN 'Activa' ELSE 'Inactiva' END AS etiqueta, "
                + "COUNT(*) AS total "
                + "FROM propiedad p "
                + "GROUP BY p.estado_logico "
                + "ORDER BY total DESC";
        return listarMetricas(sql);
    }

    /**
     * Ejecuta una consulta COUNT(*) sin parametros.
     */
    private int contar(String sql) throws SQLException {
        return contar(sql, null);
    }

    /**
     * Ejecuta una consulta COUNT(*) con un parametro entero opcional.
     */
    private int contar(String sql, Integer parametro) throws SQLException {
        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (parametro != null) {
                ps.setInt(1, parametro);
            }

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    /**
     * Ejecuta una consulta de agrupacion que devuelve las columnas
     * 'etiqueta' y 'total'.
     */
    private List<MetricaAgrupada> listarMetricas(String sql) throws SQLException {
        List<MetricaAgrupada> lista = new ArrayList<>();

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(new MetricaAgrupada(rs.getString("etiqueta"), rs.getInt("total")));
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
