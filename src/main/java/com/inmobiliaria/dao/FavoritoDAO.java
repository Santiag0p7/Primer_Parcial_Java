package com.inmobiliaria.dao;

import com.inmobiliaria.model.Propiedad;
import com.inmobiliaria.util.ConexionDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO (Data Access Object) para el modulo de Favoritos.
 * Gestiona la relacion N:M entre 'usuario' (cliente) y 'propiedad' a traves
 * de la tabla intermedia 'favorito', usando PreparedStatement.
 */
public class FavoritoDAO {

    /**
     * Agrega una propiedad a los favoritos de un usuario. Es idempotente:
     * si ya existe, no genera error ni duplica el registro.
     *
     * @param idUsuario   ID del usuario
     * @param idPropiedad ID de la propiedad
     * @return true si la operacion se completo
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public boolean agregar(int idUsuario, int idPropiedad) throws SQLException {
        String sql = "INSERT INTO favorito (id_usuario, id_propiedad, fecha_agregado) "
                + "VALUES (?, ?, NOW()) "
                + "ON DUPLICATE KEY UPDATE fecha_agregado = fecha_agregado";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            ps.setInt(2, idPropiedad);
            ps.executeUpdate();
            return true;
        }
    }

    /**
     * Quita una propiedad de los favoritos de un usuario.
     *
     * @param idUsuario   ID del usuario
     * @param idPropiedad ID de la propiedad
     * @return true si se elimino al menos un registro
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public boolean eliminar(int idUsuario, int idPropiedad) throws SQLException {
        String sql = "DELETE FROM favorito WHERE id_usuario = ? AND id_propiedad = ?";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            ps.setInt(2, idPropiedad);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Indica si una propiedad ya esta en los favoritos de un usuario.
     *
     * @param idUsuario   ID del usuario
     * @param idPropiedad ID de la propiedad
     * @return true si ya es favorita
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public boolean esFavorito(int idUsuario, int idPropiedad) throws SQLException {
        String sql = "SELECT 1 FROM favorito WHERE id_usuario = ? AND id_propiedad = ?";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            ps.setInt(2, idPropiedad);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Lista las propiedades favoritas (activas) de un usuario, con su tipo y
     * ciudad, ordenadas por la mas recientemente agregada.
     *
     * @param idUsuario ID del usuario
     * @return Lista de propiedades favoritas
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public List<Propiedad> listarPorUsuario(int idUsuario) throws SQLException {
        String sql = "SELECT p.id_propiedad, p.matricula_inmobiliaria, p.titulo, p.descripcion, "
                + "p.precio, p.habitaciones, p.banos, p.area_m2, p.direccion, p.estado_logico, "
                + "p.id_inmobiliaria, p.id_tipo, p.id_ciudad, p.fecha_publicacion, "
                + "t.nombre AS nombre_tipo, c.nombre AS nombre_ciudad "
                + "FROM favorito f "
                + "INNER JOIN propiedad p ON f.id_propiedad = p.id_propiedad "
                + "INNER JOIN tipo_propiedad t ON p.id_tipo = t.id_tipo "
                + "INNER JOIN ciudad c ON p.id_ciudad = c.id_ciudad "
                + "WHERE f.id_usuario = ? AND p.estado_logico = TRUE "
                + "ORDER BY f.fecha_agregado DESC";

        List<Propiedad> lista = new ArrayList<>();

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapear(rs));
                }
            }
        }
        return lista;
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

        Timestamp fecha = rs.getTimestamp("fecha_publicacion");
        if (fecha != null) {
            p.setFechaPublicacion(fecha.toLocalDateTime());
        }

        p.setNombreTipo(rs.getString("nombre_tipo"));
        p.setNombreCiudad(rs.getString("nombre_ciudad"));
        return p;
    }
}
