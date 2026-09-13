package com.inmobiliaria.dao;

import com.inmobiliaria.model.Perfil;
import com.inmobiliaria.util.ConexionDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;

/**
 * DAO (Data Access Object) para la entidad Perfil.
 * Implementa las operaciones JDBC contra la tabla 'perfil' usando
 * PreparedStatement para prevenir SQL Injection.
 *
 * La relacion usuario <-> perfil es 1:1 (id_usuario es UNIQUE), por lo
 * que todas las operaciones se filtran por el id del usuario en sesion.
 */
public class PerfilDAO {

    /**
     * Obtiene el perfil asociado a un usuario.
     *
     * @param idUsuario ID del usuario en sesion
     * @return Objeto Perfil si existe, null si el usuario no tiene perfil
     */
    public Perfil obtenerPorIdUsuario(int idUsuario) {
        String sql = "SELECT id_perfil, id_usuario, nombres, apellidos, documento, "
                + "telefono, direccion, fecha_actualizacion "
                + "FROM perfil WHERE id_usuario = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = ConexionDB.obtenerConexion();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();

            if (rs.next()) {
                Perfil perfil = new Perfil();
                perfil.setIdPerfil(rs.getInt("id_perfil"));
                perfil.setIdUsuario(rs.getInt("id_usuario"));
                perfil.setNombres(rs.getString("nombres"));
                perfil.setApellidos(rs.getString("apellidos"));
                perfil.setDocumento(rs.getString("documento"));
                perfil.setTelefono(rs.getString("telefono"));
                perfil.setDireccion(rs.getString("direccion"));

                Timestamp fecha = rs.getTimestamp("fecha_actualizacion");
                if (fecha != null) {
                    perfil.setFechaActualizacion(fecha.toLocalDateTime());
                }
                return perfil;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
            if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
            ConexionDB.cerrar(conn);
        }

        return null;
    }

    /**
     * Guarda o actualiza el perfil de un usuario.
     * Si el usuario ya tiene un perfil se realiza UPDATE filtrando por
     * id_usuario; en caso contrario se realiza el INSERT correspondiente.
     *
     * @param perfil Objeto Perfil con los datos a persistir
     * @return true si la operacion fue exitosa, false en caso contrario
     * @throws SQLException si ocurre un error de integridad (documento duplicado)
     */
    public boolean guardarOActualizar(Perfil perfil) throws SQLException {
        if (perfil == null || perfil.getIdUsuario() <= 0) {
            return false;
        }

        if (obtenerPorIdUsuario(perfil.getIdUsuario()) != null) {
            return actualizar(perfil);
        }
        return insertar(perfil);
    }

    /**
     * Actualiza los datos del perfil filtrando por id_usuario.
     */
    private boolean actualizar(Perfil perfil) throws SQLException {
        String sql = "UPDATE perfil SET nombres = ?, apellidos = ?, documento = ?, "
                + "telefono = ?, direccion = ?, fecha_actualizacion = NOW() "
                + "WHERE id_usuario = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = ConexionDB.obtenerConexion();
            ps = conn.prepareStatement(sql);
            ps.setString(1, perfil.getNombres());
            ps.setString(2, perfil.getApellidos());
            ps.setString(3, perfil.getDocumento());
            setNullableString(ps, 4, perfil.getTelefono());
            setNullableString(ps, 5, perfil.getDireccion());
            ps.setInt(6, perfil.getIdUsuario());

            return ps.executeUpdate() > 0;

        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
            ConexionDB.cerrar(conn);
        }
    }

    /**
     * Inserta un nuevo perfil asociado al usuario.
     */
    private boolean insertar(Perfil perfil) throws SQLException {
        String sql = "INSERT INTO perfil (id_usuario, nombres, apellidos, documento, "
                + "telefono, direccion, fecha_actualizacion) "
                + "VALUES (?, ?, ?, ?, ?, ?, NOW())";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = ConexionDB.obtenerConexion();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, perfil.getIdUsuario());
            ps.setString(2, perfil.getNombres());
            ps.setString(3, perfil.getApellidos());
            ps.setString(4, perfil.getDocumento());
            setNullableString(ps, 5, perfil.getTelefono());
            setNullableString(ps, 6, perfil.getDireccion());

            return ps.executeUpdate() > 0;

        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
            ConexionDB.cerrar(conn);
        }
    }

    /**
     * Asigna un texto al PreparedStatement o NULL si viene vacio.
     */
    private void setNullableString(PreparedStatement ps, int index, String valor)
            throws SQLException {
        if (valor == null || valor.trim().isEmpty()) {
            ps.setNull(index, Types.VARCHAR);
        } else {
            ps.setString(index, valor.trim());
        }
    }
}
