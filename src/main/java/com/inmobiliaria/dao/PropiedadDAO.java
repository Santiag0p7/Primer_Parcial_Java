package com.inmobiliaria.dao;

import com.inmobiliaria.model.Propiedad;
import com.inmobiliaria.util.ConexionDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO (Data Access Object) para la entidad Propiedad.
 * Implementa las operaciones JDBC contra la tabla 'propiedad',
 * usando siempre PreparedStatement para prevenir SQL Injection.
 *
 * Requisito clave del parcial:
 *   - La eliminacion es LOGICA (bajaLogica), nunca fisica.
 *   - insertar() y actualizar() propagan SQLException para que el
 *     controlador valide la restriccion UNIQUE de matricula_inmobiliaria.
 */
public class PropiedadDAO {

    // SELECT base con JOIN a los catalogos para traer nombre de tipo y ciudad
    private static final String SELECT_BASE =
            "SELECT p.id_propiedad, p.matricula_inmobiliaria, p.titulo, p.descripcion, "
          + "p.precio, p.habitaciones, p.banos, p.area_m2, p.direccion, p.estado_logico, "
          + "p.id_inmobiliaria, p.id_tipo, p.id_ciudad, p.fecha_publicacion, "
          + "t.nombre AS nombre_tipo, c.nombre AS nombre_ciudad "
          + "FROM propiedad p "
          + "INNER JOIN tipo_propiedad t ON p.id_tipo = t.id_tipo "
          + "INNER JOIN ciudad c ON p.id_ciudad = c.id_ciudad ";

    /**
     * Lista todas las propiedades activas (estado_logico = TRUE).
     *
     * @return Lista de propiedades activas ordenadas por fecha descendente
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public List<Propiedad> listarTodasActivas() throws SQLException {
        String sql = SELECT_BASE + "WHERE p.estado_logico = TRUE ORDER BY p.fecha_publicacion DESC";

        List<Propiedad> lista = new ArrayList<>();

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(mapear(rs));
            }
        }
        return lista;
    }

    /**
     * Lista las propiedades activas pertenecientes a una inmobiliaria.
     *
     * @param idInmobiliaria ID del usuario con rol INMOBILIARIA
     * @return Lista de propiedades activas de esa inmobiliaria
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public List<Propiedad> listarPorInmobiliaria(int idInmobiliaria) throws SQLException {
        String sql = SELECT_BASE
                + "WHERE p.estado_logico = TRUE AND p.id_inmobiliaria = ? "
                + "ORDER BY p.fecha_publicacion DESC";

        List<Propiedad> lista = new ArrayList<>();

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idInmobiliaria);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapear(rs));
                }
            }
        }
        return lista;
    }

    /**
     * Obtiene una propiedad por su clave primaria, sin importar su estado.
     *
     * @param id ID de la propiedad
     * @return Propiedad encontrada o null si no existe
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public Propiedad obtenerPorId(int id) throws SQLException {
        String sql = SELECT_BASE + "WHERE p.id_propiedad = ?";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapear(rs);
                }
            }
        }
        return null;
    }

    /**
     * Inserta una nueva propiedad.
     * Propaga SQLException para que el controlador detecte
     * la violacion de la restriccion UNIQUE (matricula_inmobiliaria).
     *
     * @param p Propiedad a insertar
     * @return true si se inserto correctamente
     * @throws SQLException si ocurre un error (incluye duplicados UNIQUE)
     */
    public boolean insertar(Propiedad p) throws SQLException {
        String sql = "INSERT INTO propiedad "
                + "(matricula_inmobiliaria, titulo, descripcion, precio, habitaciones, banos, "
                + "area_m2, direccion, estado_logico, id_inmobiliaria, id_tipo, id_ciudad, fecha_publicacion) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, TRUE, ?, ?, ?, NOW())";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getMatriculaInmobiliaria());
            ps.setString(2, p.getTitulo());
            ps.setString(3, p.getDescripcion());
            ps.setBigDecimal(4, p.getPrecio());
            ps.setInt(5, p.getHabitaciones());
            ps.setInt(6, p.getBanos());
            ps.setBigDecimal(7, p.getAreaM2());
            ps.setString(8, p.getDireccion());
            ps.setInt(9, p.getIdInmobiliaria());
            ps.setInt(10, p.getIdTipo());
            ps.setInt(11, p.getIdCiudad());

            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Actualiza los campos de una propiedad existente.
     * Propaga SQLException para validar la restriccion UNIQUE.
     *
     * @param p Propiedad con los datos actualizados (debe incluir idPropiedad)
     * @return true si se actualizo al menos un registro
     * @throws SQLException si ocurre un error (incluye duplicados UNIQUE)
     */
    public boolean actualizar(Propiedad p) throws SQLException {
        String sql = "UPDATE propiedad SET "
                + "matricula_inmobiliaria = ?, titulo = ?, descripcion = ?, precio = ?, "
                + "habitaciones = ?, banos = ?, area_m2 = ?, direccion = ?, "
                + "id_tipo = ?, id_ciudad = ? "
                + "WHERE id_propiedad = ?";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getMatriculaInmobiliaria());
            ps.setString(2, p.getTitulo());
            ps.setString(3, p.getDescripcion());
            ps.setBigDecimal(4, p.getPrecio());
            ps.setInt(5, p.getHabitaciones());
            ps.setInt(6, p.getBanos());
            ps.setBigDecimal(7, p.getAreaM2());
            ps.setString(8, p.getDireccion());
            ps.setInt(9, p.getIdTipo());
            ps.setInt(10, p.getIdCiudad());
            ps.setInt(11, p.getIdPropiedad());

            return ps.executeUpdate() > 0;
        }
    }

    /**
     * REQUISITO OBLIGATORIO DEL PARCIAL.
     * Realiza la baja logica de una propiedad (no se borra fisicamente).
     * UPDATE propiedad SET estado_logico = FALSE WHERE id_propiedad = ?
     *
     * @param idPropiedad ID de la propiedad a desactivar
     * @return true si se desactivo correctamente
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public boolean bajaLogica(int idPropiedad) throws SQLException {
        String sql = "UPDATE propiedad SET estado_logico = FALSE WHERE id_propiedad = ?";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idPropiedad);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Lista el catalogo de tipos de propiedad para los selectores del formulario.
     *
     * @return Mapa id_tipo -> nombre
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public java.util.Map<Integer, String> listarTipos() throws SQLException {
        String sql = "SELECT id_tipo, nombre FROM tipo_propiedad ORDER BY nombre";
        java.util.Map<Integer, String> tipos = new java.util.LinkedHashMap<>();

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                tipos.put(rs.getInt("id_tipo"), rs.getString("nombre"));
            }
        }
        return tipos;
    }

    /**
     * Lista el catalogo de ciudades para los selectores del formulario.
     *
     * @return Mapa id_ciudad -> nombre
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public java.util.Map<Integer, String> listarCiudades() throws SQLException {
        String sql = "SELECT id_ciudad, nombre FROM ciudad ORDER BY nombre";
        java.util.Map<Integer, String> ciudades = new java.util.LinkedHashMap<>();

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ciudades.put(rs.getInt("id_ciudad"), rs.getString("nombre"));
            }
        }
        return ciudades;
    }

    /**
     * Mapea la fila actual del ResultSet a un objeto Propiedad.
     */
    private Propiedad mapear(ResultSet rs) throws SQLException {
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
